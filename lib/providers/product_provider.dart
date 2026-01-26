import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/card_product.dart';
import '../services/sample_data_service.dart';
import '../services/free_data_service.dart';

/// 商品データ管理プロバイダー
/// 商品一覧、検索、フィルター、お気に入り機能を提供
class ProductProvider with ChangeNotifier {
  List<CardProduct> _allProducts = [];      // 全商品データ
  List<CardProduct> _filteredProducts = []; // フィルター後の商品データ
  Set<String> _favoriteIds = {};            // お気に入り商品IDのセット
  String _selectedCategory = 'すべて';       // 選択中のカテゴリー
  String _searchQuery = '';                 // 検索クエリ
  bool _isLoading = false;                  // ロード中フラグ
  
  // ゲッター
  List<CardProduct> get filteredProducts => _filteredProducts;
  List<CardProduct> get allProducts => _allProducts;
  Set<String> get favoriteIds => _favoriteIds;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  
  /// お気に入り商品のみを取得
  List<CardProduct> get favoriteProducts {
    return _allProducts.where((product) => _favoriteIds.contains(product.id)).toList();
  }
  
  /// 初期化処理（データ読み込みとお気に入り復元）
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // サンプルデータを読み込み
      await loadProducts();
      
      // お気に入りデータを復元
      await _loadFavorites();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('初期化エラー: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// 商品データを読み込み
  Future<void> loadProducts() async {
    try {
      // サンプルデータサービスから商品データを取得
      final jsonData = SampleDataService.getSampleProducts();
      _allProducts = jsonData.map((json) => CardProduct.fromJson(json)).toList();
      
      // フィルター適用
      _applyFilters();
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('商品読み込みエラー: $e');
      }
      rethrow;
    }
  }
  
  /// 実データを取得して更新（サンリオ・たまごっち公式から）
  Future<void> fetchRealData(String keyword) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final freeDataService = FreeDataService();
      final products = await freeDataService.fetchAllProducts();
      
      if (products.isNotEmpty) {
        // 既存のデータをクリアして新しいデータに置き換え
        _allProducts.clear();
        
        // 新しいデータを追加
        final newProducts = products.map((json) => CardProduct.fromJson(json)).toList();
        _allProducts.addAll(newProducts);
        
        // フィルター適用
        _applyFilters();
        
        if (kDebugMode) {
          debugPrint('✅ ${products.length}件の実データを取得しました（サンリオ・たまごっち）');
        }
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ データが取得できませんでした');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ 実データ取得エラー: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// すべてのソースから実データを取得
  Future<void> fetchAllRealData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final freeDataService = FreeDataService();
      final products = await freeDataService.fetchAllProducts();
      
      if (products.isNotEmpty) {
        // 既存のデータをクリアして新しいデータに置き換え
        _allProducts.clear();
        
        // 新しいデータを追加
        final newProducts = products.map((json) => CardProduct.fromJson(json)).toList();
        _allProducts.addAll(newProducts);
        
        // フィルター適用
        _applyFilters();
        
        if (kDebugMode) {
          debugPrint('✅ ${products.length}件の実データを取得しました');
        }
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ データが取得できませんでした');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ 実データ取得エラー: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// カテゴリーフィルターを設定
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }
  
  /// 検索クエリを設定
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }
  
  /// フィルターを適用
  void _applyFilters() {
    List<CardProduct> filtered = _allProducts;
    
    // カテゴリーフィルター
    if (_selectedCategory != 'すべて') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    
    // 検索フィルター
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(query) ||
               p.category.toLowerCase().contains(query) ||
               p.description.toLowerCase().contains(query);
      }).toList();
    }
    
    _filteredProducts = filtered;
  }
  
  /// お気に入りトグル
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    
    // ローカルストレージに保存
    await _saveFavorites();
    
    notifyListeners();
  }
  
  /// お気に入り状態を確認
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }
  
  /// お気に入りをローカルストレージに保存
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_products', _favoriteIds.toList());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('お気に入り保存エラー: $e');
      }
    }
  }
  
  /// お気に入りをローカルストレージから読み込み
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorite_products') ?? [];
      _favoriteIds = Set<String>.from(favorites);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('お気に入り読み込みエラー: $e');
      }
    }
  }
}
