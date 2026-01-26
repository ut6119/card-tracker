import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

/// シンプルな実データ取得サービス
/// 楽天商品検索APIを使用
class SimpleRealDataService {
  // 楽天APIのアプリケーションID（デモ用）
  static const String _rakutenAppId = '1001';
  
  /// 楽天商品検索APIから実データを取得
  Future<List<Map<String, dynamic>>> searchRakuten(String keyword) async {
    try {
      // 楽天商品検索API v2を使用
      final url = Uri.parse(
        'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706'
        '?format=json'
        '&keyword=$keyword'
        '&applicationId=$_rakutenAppId'
        '&hits=20'
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['Items'] as List? ?? [];
        
        return items.map<Map<String, dynamic>>((item) {
          final itemData = item['Item'] as Map<String, dynamic>;
          
          return {
            'id': 'rakuten_${itemData['itemCode']}',
            'name': itemData['itemName'] ?? '',
            'price': (itemData['itemPrice'] ?? 0).toDouble(),
            'imageUrl': itemData['mediumImageUrls']?[0]?['imageUrl'] ?? 
                       itemData['smallImageUrls']?[0]?['imageUrl'] ?? 
                       'https://via.placeholder.com/150',
            'url': itemData['itemUrl'] ?? '',
            'storeName': itemData['shopName'] ?? '楽天市場',
            'category': 'トレーディングカード',
            'description': (itemData['itemCaption'] ?? '').replaceAll(RegExp(r'<[^>]*>'), '').substring(0, 100) + '...',
            'inStock': true,
            'lastUpdated': DateTime.now().toIso8601String(),
            'prices': [
              {
                'storeId': 'rakuten_${itemData['shopCode']}',
                'storeName': itemData['shopName'] ?? '楽天市場',
                'price': (itemData['itemPrice'] ?? 0).toDouble(),
                'inStock': true,
                'location': 'オンライン',
                'url': itemData['itemUrl'] ?? '',
                'lastUpdated': DateTime.now().toIso8601String(),
              }
            ],
          };
        }).toList();
      } else {
        if (kDebugMode) {
          debugPrint('楽天API エラー: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('楽天商品検索エラー: $e');
      }
    }
    
    return [];
  }
  
  /// 複数キーワードで検索
  Future<List<Map<String, dynamic>>> searchMultipleKeywords(List<String> keywords) async {
    final allResults = <Map<String, dynamic>>[];
    
    for (var keyword in keywords) {
      final results = await searchRakuten(keyword);
      allResults.addAll(results);
      
      // API制限を考慮して待機
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    return allResults;
  }
  
  /// デフォルトのキーワードで検索
  Future<List<Map<String, dynamic>>> searchDefaultProducts() async {
    return await searchMultipleKeywords([
      'ボンボンドロップ',
      'シール',
      'トレーディングカード',
    ]);
  }
}
