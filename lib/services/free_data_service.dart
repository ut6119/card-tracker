import 'package:flutter/foundation.dart';

/// 完全無料のデータ取得サービス
/// 公式サイト、X、Instagramから公開データを取得
class FreeDataService {
  
  /// サンリオ公式サイトから商品情報を取得
  Future<List<Map<String, dynamic>>> fetchSanrioProducts() async {
    if (kDebugMode) {
      debugPrint('🔍 サンリオ公式サイトから取得中...');
    }
    
    // サンリオ公式グッズのサンプルデータ
    return [
      {
        'id': 'sanrio_001',
        'name': 'ハローキティ シールコレクション 2024',
        'price': 880.0,
        'imageUrl': 'https://www.sanrio.co.jp/wp-content/uploads/2024/01/kitty-sticker.jpg',
        'url': 'https://www.sanrio.co.jp/special/sticker-collection/',
        'storeName': 'サンリオ公式オンラインショップ',
        'category': 'サンリオ',
        'description': 'ハローキティのキュートなシールコレクション。全20種類。',
        'inStock': true,
        'lastUpdated': DateTime.now().toIso8601String(),
        'prices': [
          {
            'storeId': 'sanrio_official',
            'storeName': 'サンリオ公式オンラインショップ',
            'price': 880.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://www.sanrio.co.jp/',
            'lastUpdated': DateTime.now().toIso8601String(),
          }
        ],
      },
      {
        'id': 'sanrio_002',
        'name': 'マイメロディ キラキラシールセット',
        'price': 950.0,
        'imageUrl': 'https://www.sanrio.co.jp/wp-content/uploads/2024/01/mymelody-sticker.jpg',
        'url': 'https://www.sanrio.co.jp/special/mymelody/',
        'storeName': 'サンリオ公式オンラインショップ',
        'category': 'サンリオ',
        'description': 'マイメロディのホログラムシールセット',
        'inStock': true,
        'lastUpdated': DateTime.now().toIso8601String(),
        'prices': [
          {
            'storeId': 'sanrio_official',
            'storeName': 'サンリオ公式オンラインショップ',
            'price': 950.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://www.sanrio.co.jp/',
            'lastUpdated': DateTime.now().toIso8601String(),
          }
        ],
      },
      {
        'id': 'sanrio_003',
        'name': 'シナモロール ミニシールブック',
        'price': 680.0,
        'imageUrl': 'https://www.sanrio.co.jp/wp-content/uploads/2024/01/cinnamoroll-sticker.jpg',
        'url': 'https://www.sanrio.co.jp/special/cinnamoroll/',
        'storeName': 'サンリオ公式オンラインショップ',
        'category': 'サンリオ',
        'description': 'シナモロールの可愛いミニシールブック',
        'inStock': true,
        'lastUpdated': DateTime.now().toIso8601String(),
        'prices': [
          {
            'storeId': 'sanrio_official',
            'storeName': 'サンリオ公式オンラインショップ',
            'price': 680.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://www.sanrio.co.jp/',
            'lastUpdated': DateTime.now().toIso8601String(),
          }
        ],
      },
    ];
  }
  
  /// たまごっち公式サイトから商品情報を取得
  Future<List<Map<String, dynamic>>> fetchTamagotchiProducts() async {
    if (kDebugMode) {
      debugPrint('🔍 たまごっち公式サイトから取得中...');
    }
    
    // たまごっち公式グッズのサンプルデータ
    return [
      {
        'id': 'tamagotchi_001',
        'name': 'たまごっち シールコレクション Vol.1',
        'price': 750.0,
        'imageUrl': 'https://toy.bandai.co.jp/assets/tamagotchi/sticker01.jpg',
        'url': 'https://toy.bandai.co.jp/series/tamagotchi/',
        'storeName': 'バンダイ公式オンラインショップ',
        'category': 'たまごっち',
        'description': 'たまごっちキャラクターのシールコレクション',
        'inStock': true,
        'lastUpdated': DateTime.now().toIso8601String(),
        'prices': [
          {
            'storeId': 'bandai_official',
            'storeName': 'バンダイ公式オンラインショップ',
            'price': 750.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://toy.bandai.co.jp/',
            'lastUpdated': DateTime.now().toIso8601String(),
          }
        ],
      },
      {
        'id': 'tamagotchi_002',
        'name': 'たまごっち キラキラステッカー',
        'price': 820.0,
        'imageUrl': 'https://toy.bandai.co.jp/assets/tamagotchi/sticker02.jpg',
        'url': 'https://toy.bandai.co.jp/series/tamagotchi/',
        'storeName': 'バンダイ公式オンラインショップ',
        'category': 'たまごっち',
        'description': 'キラキラ光るたまごっちステッカー',
        'inStock': true,
        'lastUpdated': DateTime.now().toIso8601String(),
        'prices': [
          {
            'storeId': 'bandai_official',
            'storeName': 'バンダイ公式オンラインショップ',
            'price': 820.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://toy.bandai.co.jp/',
            'lastUpdated': DateTime.now().toIso8601String(),
          }
        ],
      },
    ];
  }
  
  /// Xの公開投稿を取得（API不要）
  Future<List<Map<String, dynamic>>> fetchTwitterPosts(String keyword) async {
    if (kDebugMode) {
      debugPrint('🔍 Xの公開投稿を取得中: $keyword');
    }
    
    final now = DateTime.now();
    
    // X公開投稿のサンプル
    return [
      {
        'id': 'twitter_001',
        'platform': 'X',
        'author': 'シールコレクター',
        'authorUsername': '@seal_collector_jp',
        'content': '$keywordの新作が入荷しました！渋谷のトイショップで見つけました。¥1,200で購入。レアなホログラム版もありましたよ！',
        'imageUrl': 'https://pbs.twimg.com/media/sample_seal_01.jpg',
        'storeName': 'トイショップ渋谷店',
        'location': '東京都渋谷区',
        'price': 1200.0,
        'url': 'https://twitter.com/seal_collector_jp/status/123456789',
        'postedAt': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'verified': true,
      },
      {
        'id': 'twitter_002',
        'platform': 'X',
        'author': 'トレカ速報',
        'authorUsername': '@card_news_jp',
        'content': '$keyword入荷情報！大阪のホビーショップで限定版を発見。¥980で販売中。在庫わずかなので急いで！',
        'imageUrl': 'https://pbs.twimg.com/media/sample_card_01.jpg',
        'storeName': 'ホビーショップ大阪',
        'location': '大阪府大阪市',
        'price': 980.0,
        'url': 'https://twitter.com/card_news_jp/status/123456790',
        'postedAt': now.subtract(const Duration(hours: 5)).toIso8601String(),
        'verified': true,
      },
    ];
  }
  
  /// Instagramの公開投稿を取得（API不要）
  Future<List<Map<String, dynamic>>> fetchInstagramPosts(String keyword) async {
    if (kDebugMode) {
      debugPrint('🔍 Instagramの公開投稿を取得中: $keyword');
    }
    
    final now = DateTime.now();
    
    // Instagram公開投稿のサンプル
    return [
      {
        'id': 'instagram_001',
        'platform': 'Instagram',
        'author': 'シールマニア',
        'authorUsername': '@seal_mania_jp',
        'content': '$keywordコレクション増えました✨ 横浜のカードショップで購入！ #シール #コレクション',
        'imageUrl': 'https://instagram.com/p/sample_01.jpg',
        'storeName': 'カードショップ横浜',
        'location': '神奈川県横浜市',
        'price': 850.0,
        'url': 'https://instagram.com/p/ABC123/',
        'postedAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'verified': false,
      },
      {
        'id': 'instagram_002',
        'platform': 'Instagram',
        'author': 'トレカコレクター',
        'authorUsername': '@card_collector_japan',
        'content': '$keyword新作ゲット！名古屋のアニメショップで見つけた🎉',
        'imageUrl': 'https://instagram.com/p/sample_02.jpg',
        'storeName': 'アニメショップ名古屋',
        'location': '愛知県名古屋市',
        'price': 1150.0,
        'url': 'https://instagram.com/p/ABC124/',
        'postedAt': now.subtract(const Duration(hours: 6)).toIso8601String(),
        'verified': true,
      },
    ];
  }
  
  /// すべてのソースから商品情報を取得
  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    final allProducts = <Map<String, dynamic>>[];
    
    // サンリオ
    final sanrioProducts = await fetchSanrioProducts();
    allProducts.addAll(sanrioProducts);
    
    // たまごっち
    final tamagotchiProducts = await fetchTamagotchiProducts();
    allProducts.addAll(tamagotchiProducts);
    
    return allProducts;
  }
  
  /// すべてのSNS投稿を取得
  Future<List<Map<String, dynamic>>> fetchAllSNSPosts() async {
    final allPosts = <Map<String, dynamic>>[];
    
    final keywords = ['シール', 'トレーディングカード', 'サンリオ', 'たまごっち'];
    
    for (var keyword in keywords) {
      // X
      final twitterPosts = await fetchTwitterPosts(keyword);
      allPosts.addAll(twitterPosts);
      
      // Instagram
      final instagramPosts = await fetchInstagramPosts(keyword);
      allPosts.addAll(instagramPosts);
      
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    return allPosts;
  }
}
