import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_item.dart';
import '../services/curated_data_service.dart';
import '../services/web_scraper_service.dart';

/// メインの状態管理プロバイダー
/// データ取得、自動更新、お気に入り管理を担当
class TrackerProvider with ChangeNotifier {
  // --- 状態 ---
  List<NewsItem> _allItems = [];
  List<NewsItem> _liveItems = []; // WebScraperから取得した動的アイテム
  Set<String> _favoriteIds = {};
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _lastError;
  DateTime? _lastUpdated;
  Timer? _autoRefreshTimer;

  // --- ゲッター ---
  List<NewsItem> get allItems => [..._allItems, ..._liveItems];
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get lastError => _lastError;
  DateTime? get lastUpdated => _lastUpdated;
  Set<String> get favoriteIds => _favoriteIds;

  /// カテゴリ別アイテム取得
  List<NewsItem> getItemsByCategory(InfoCategory category) {
    final items = allItems.where((item) {
      if (category == InfoCategory.gacha) {
        return item.category == InfoCategory.tamagotchi ||
            item.category == InfoCategory.zootopia ||
            item.category == InfoCategory.gacha;
      }
      return item.category == category;
    }).toList();
    items.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return items;
  }

  /// お気に入りアイテム取得
  List<NewsItem> get favoriteItems {
    return allItems
        .where((item) => _favoriteIds.contains(item.id))
        .toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  /// お気に入り判定
  bool isFavorite(String id) => _favoriteIds.contains(id);

  /// 初期化
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // お気に入り復元
      await _loadFavorites();

      // キュレーションデータ読み込み
      _allItems = CuratedDataService.getAllNews();

      // ライブデータ取得を試みる
      await _fetchLiveData();

      _lastUpdated = DateTime.now();
      _lastError = null;
    } catch (e) {
      _lastError = e.toString();
      if (kDebugMode) {
        debugPrint('初期化エラー: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // 自動更新を開始（5分ごと）
    _startAutoRefresh();
  }

  /// 手動リフレッシュ
  Future<void> refresh() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    notifyListeners();

    try {
      // キュレーションデータを更新
      _allItems = CuratedDataService.getAllNews();

      // ライブデータを再取得
      await _fetchLiveData();

      _lastUpdated = DateTime.now();
      _lastError = null;
    } catch (e) {
      _lastError = e.toString();
      if (kDebugMode) {
        debugPrint('リフレッシュエラー: $e');
      }
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// ライブデータ取得（Yahoo!リアルタイム検索）
  Future<void> _fetchLiveData() async {
    try {
      final scraper = WebScraperService();
      final livePosts = await scraper.fetchAllPosts();
      _liveItems = livePosts;

      if (kDebugMode) {
        debugPrint('ライブデータ: ${livePosts.length}件取得');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ライブデータ取得エラー: $e');
      }
      // ライブデータ取得に失敗してもキュレーションデータは保持
    }
  }

  /// 自動更新開始
  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => refresh(),
    );
  }

  /// お気に入りトグル
  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    await _saveFavorites();
    notifyListeners();
  }

  /// お気に入り保存
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_items', _favoriteIds.toList());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('お気に入り保存エラー: $e');
      }
    }
  }

  /// お気に入り読み込み
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorite_items') ?? [];
      _favoriteIds = Set<String>.from(favorites);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('お気に入り読み込みエラー: $e');
      }
    }
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}
