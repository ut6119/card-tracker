import 'package:dio/dio.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter/foundation.dart';

/// 実際のデータを取得するサービス
class RealDataService {
  final Dio _dio = Dio();

  /// 楽天市場からシール・トレーディングカードの価格情報を取得
  Future<List<Map<String, dynamic>>> fetchRakutenProducts(String keyword) async {
    try {
      final response = await _dio.get(
        'https://search.rakuten.co.jp/search/mall/$keyword/',
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.data);
        final products = <Map<String, dynamic>>[];

        // 商品リストを解析
        final items = document.querySelectorAll('.searchresultitem');
        
        for (var item in items.take(10)) {
          try {
            final nameElement = item.querySelector('.title');
            final priceElement = item.querySelector('.price');
            final linkElement = item.querySelector('a');
            final imageElement = item.querySelector('img');
            final shopElement = item.querySelector('.merchant');

            if (nameElement != null && priceElement != null) {
              final name = nameElement.text.trim();
              final priceText = priceElement.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
              final price = double.tryParse(priceText) ?? 0.0;
              final link = linkElement?.attributes['href'] ?? '';
              final imageUrl = imageElement?.attributes['src'] ?? 'https://via.placeholder.com/150';
              final shopName = shopElement?.text.trim() ?? '楽天市場';

              products.add({
                'id': 'rakuten_${DateTime.now().millisecondsSinceEpoch}',
                'name': name,
                'price': price,
                'imageUrl': imageUrl,
                'url': link,
                'storeName': shopName,
                'platform': '楽天市場',
                'inStock': true,
                'lastUpdated': DateTime.now().toIso8601String(),
              });
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('商品解析エラー: $e');
            }
          }
        }

        return products;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('楽天市場データ取得エラー: $e');
      }
    }
    return [];
  }

  /// Yahoo!ショッピングから価格情報を取得
  Future<List<Map<String, dynamic>>> fetchYahooProducts(String keyword) async {
    try {
      final response = await _dio.get(
        'https://shopping.yahoo.co.jp/search?p=$keyword',
      );

      if (response.statusCode == 200) {
        final document = html_parser.parse(response.data);
        final products = <Map<String, dynamic>>[];

        // 商品リストを解析
        final items = document.querySelectorAll('.Product');
        
        for (var item in items.take(10)) {
          try {
            final nameElement = item.querySelector('.Product__title');
            final priceElement = item.querySelector('.Product__price');
            final linkElement = item.querySelector('a');
            final imageElement = item.querySelector('img');

            if (nameElement != null && priceElement != null) {
              final name = nameElement.text.trim();
              final priceText = priceElement.text.trim().replaceAll(RegExp(r'[^0-9]'), '');
              final price = double.tryParse(priceText) ?? 0.0;
              final link = 'https://shopping.yahoo.co.jp${linkElement?.attributes['href'] ?? ''}';
              final imageUrl = imageElement?.attributes['src'] ?? 'https://via.placeholder.com/150';

              products.add({
                'id': 'yahoo_${DateTime.now().millisecondsSinceEpoch}',
                'name': name,
                'price': price,
                'imageUrl': imageUrl,
                'url': link,
                'storeName': 'Yahoo!ショッピング',
                'platform': 'Yahoo!ショッピング',
                'inStock': true,
                'lastUpdated': DateTime.now().toIso8601String(),
              });
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('商品解析エラー: $e');
            }
          }
        }

        return products;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Yahoo!ショッピングデータ取得エラー: $e');
      }
    }
    return [];
  }

  /// メルカリから価格情報を取得
  Future<List<Map<String, dynamic>>> fetchMercariProducts(String keyword) async {
    try {
      // メルカリAPIを使用（公式APIが必要）
      // 注: 実際にはメルカリの公式APIまたはスクレイピングが必要
      if (kDebugMode) {
        debugPrint('メルカリAPI連携は公式APIキーが必要です');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('メルカリデータ取得エラー: $e');
      }
    }
    return [];
  }

  /// X (Twitter) から投稿を取得
  Future<List<Map<String, dynamic>>> fetchTwitterPosts(String keyword) async {
    try {
      // Twitter APIを使用（APIキーが必要）
      // 注: 実際にはTwitter API v2が必要
      if (kDebugMode) {
        debugPrint('Twitter API連携はAPIキーが必要です');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Twitter データ取得エラー: $e');
      }
    }
    return [];
  }

  /// Instagram から投稿を取得
  Future<List<Map<String, dynamic>>> fetchInstagramPosts(String keyword) async {
    try {
      // Instagram Graph APIを使用（アクセストークンが必要）
      // 注: 実際にはInstagram Graph APIが必要
      if (kDebugMode) {
        debugPrint('Instagram API連携はアクセストークンが必要です');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Instagram データ取得エラー: $e');
      }
    }
    return [];
  }

  /// すべてのプラットフォームから商品情報を取得
  Future<List<Map<String, dynamic>>> fetchAllProducts(String keyword) async {
    final results = <Map<String, dynamic>>[];

    // 楽天市場
    final rakutenProducts = await fetchRakutenProducts(keyword);
    results.addAll(rakutenProducts);

    // Yahoo!ショッピング
    final yahooProducts = await fetchYahooProducts(keyword);
    results.addAll(yahooProducts);

    // メルカリ（将来的に実装）
    // final mercariProducts = await fetchMercariProducts(keyword);
    // results.addAll(mercariProducts);

    return results;
  }

  /// SNS投稿を取得
  Future<List<Map<String, dynamic>>> fetchAllSNSPosts(String keyword) async {
    final results = <Map<String, dynamic>>[];

    // Twitter（将来的に実装）
    // final twitterPosts = await fetchTwitterPosts(keyword);
    // results.addAll(twitterPosts);

    // Instagram（将来的に実装）
    // final instagramPosts = await fetchInstagramPosts(keyword);
    // results.addAll(instagramPosts);

    return results;
  }
}
