import 'package:flutter/foundation.dart';
import '../models/card_product.dart';
import '../services/remote_data_service.dart';

/// 商品データ管理プロバイダー
/// 商品一覧とフィルター機能を提供
class ProductProvider with ChangeNotifier {
  List<CardProduct> _allProducts = [];      // 全商品データ
  List<CardProduct> _filteredProducts = []; // フィルター後の商品データ
  String _selectedCategory = 'すべて';       // 選択中のカテゴリー
  bool _isLoading = false;                  // ロード中フラグ
  
  // ゲッター
  List<CardProduct> get filteredProducts => _filteredProducts;
  List<CardProduct> get allProducts => _allProducts;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  
  /// 初期化処理（データ読み込み）
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // 最新データを読み込み
      await loadProducts();
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
      // リモートの最新データを優先
      final remoteDataService = RemoteDataService();
      final remoteJson = await remoteDataService.fetchProducts();

      if (remoteJson.isNotEmpty) {
        _allProducts = remoteJson.map((json) => CardProduct.fromJson(json)).toList();
      } else {
        _allProducts = [];
        if (kDebugMode) {
          debugPrint('⚠️ リモートデータが空でした');
        }
      }
      
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
      final remoteDataService = RemoteDataService();
      final products = await remoteDataService.fetchProducts();
      
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
          debugPrint('⚠️ リモートデータが空でした');
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
      final remoteDataService = RemoteDataService();
      final products = await remoteDataService.fetchProducts();
      
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
          debugPrint('⚠️ リモートデータが空でした');
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
  
  /// フィルターを適用
  void _applyFilters() {
    List<CardProduct> filtered = _allProducts;
    
    // カテゴリーフィルター
    if (_selectedCategory != 'すべて') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }
    
    _filteredProducts = filtered;
  }
}
