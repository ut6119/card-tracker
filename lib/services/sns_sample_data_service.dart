import '../models/sns_post.dart';

/// SNS情報サンプルデータサービス
class SnsSampleDataService {
  /// サンプルSNS投稿データを取得
  static List<Map<String, dynamic>> getSampleSnsPosts() {
    final now = DateTime.now();
    
    return [
      // ボンボンドロップ関連のSNS投稿
      {
        'id': 'sns_001',
        'type': 'twitter',
        'productId': 'prod_001',
        'username': '@card_hunter_tokyo',
        'content': '渋谷のトイズショップAでボンボンドロップ第1弾見つけた！まだ在庫あります。¥1,280でした。#ボンボンドロップ #シール収集',
        'imageUrl': 'https://via.placeholder.com/300/FF69B4/FFFFFF?text=BonBon+Drop+Photo',
        'postUrl': 'https://twitter.com/card_hunter_tokyo/status/123456',
        'postedAt': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'storeName': 'トイズショップA',
        'location': '東京都渋谷区',
        'price': 1280.0,
        'isVerified': true,
      },
      {
        'id': 'sns_002',
        'type': 'instagram',
        'productId': 'prod_001',
        'username': 'sticker_collector_jp',
        'content': 'ボンボンドロップコンプリート！全12種揃いました✨ 横浜のホビーストアCで購入。レアシールも入ってた🎉',
        'imageUrl': 'https://via.placeholder.com/300/87CEEB/FFFFFF?text=Complete+Set',
        'postUrl': 'https://instagram.com/p/abcdefg',
        'postedAt': now.subtract(const Duration(hours: 5)).toIso8601String(),
        'storeName': 'ホビーストアC',
        'location': '神奈川県横浜市',
        'price': null,
        'isVerified': false,
      },
      {
        'id': 'sns_003',
        'type': 'line',
        'productId': 'prod_002',
        'username': 'シール交換グループ',
        'content': 'ボンボンドロップ第2弾の情報です！オンラインショップDで¥780で買えました。送料無料キャンペーン中みたいです。',
        'imageUrl': null,
        'postUrl': 'https://line.me/ti/g/abc123',
        'postedAt': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'storeName': 'オンラインショップD',
        'location': 'オンライン',
        'price': 780.0,
        'isVerified': true,
      },
      
      // キラキラシール関連
      {
        'id': 'sns_004',
        'type': 'twitter',
        'productId': 'prod_003',
        'username': '@osaka_card_info',
        'content': '大阪のカードショップBでキラキラシール入荷してました！Vol.1が¥950です。ホログラムが超綺麗✨ #キラキラシール',
        'imageUrl': 'https://via.placeholder.com/300/FFD700/FFFFFF?text=Kirakira+Sticker',
        'postUrl': 'https://twitter.com/osaka_card_info/status/789012',
        'postedAt': now.subtract(const Duration(hours: 4)).toIso8601String(),
        'storeName': 'カードショップB',
        'location': '大阪府大阪市',
        'price': 950.0,
        'isVerified': true,
      },
      {
        'id': 'sns_005',
        'type': 'instagram',
        'productId': 'prod_003',
        'username': 'hologram_lover',
        'content': 'キラキラシールコレクション開封動画アップしました！どれも可愛すぎる😍 横浜で買いました〜',
        'imageUrl': 'https://via.placeholder.com/300/FFD700/FFFFFF?text=Unboxing',
        'postUrl': 'https://instagram.com/p/xyz789',
        'postedAt': now.subtract(const Duration(hours: 8)).toIso8601String(),
        'storeName': 'ホビーストアC',
        'location': '神奈川県横浜市',
        'price': 920.0,
        'isVerified': false,
      },
      
      // アニメシール関連
      {
        'id': 'sns_006',
        'type': 'line',
        'productId': 'prod_004',
        'username': 'アニメグッズ交換',
        'content': '【入荷情報】アニメキャラシール詰め合わせが各店舗で再入荷してます！渋谷¥680、オンライン¥650で見かけました。',
        'imageUrl': null,
        'postUrl': 'https://line.me/ti/g/xyz456',
        'postedAt': now.subtract(const Duration(minutes: 45)).toIso8601String(),
        'storeName': null,
        'location': null,
        'price': null,
        'isVerified': false,
      },
      {
        'id': 'sns_007',
        'type': 'twitter',
        'productId': 'prod_004',
        'username': '@anime_sticker_news',
        'content': 'アニメキャラシール人気キャラ詰め合わせ、オンラインショップDで¥650！今なら送料無料🎁 在庫あるうちに急げ！',
        'imageUrl': 'https://via.placeholder.com/300/FF6347/FFFFFF?text=Anime+Characters',
        'postUrl': 'https://twitter.com/anime_sticker_news/status/345678',
        'postedAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'storeName': 'オンラインショップD',
        'location': 'オンライン',
        'price': 650.0,
        'isVerified': true,
      },
      
      // レトロシール関連
      {
        'id': 'sns_008',
        'type': 'instagram',
        'productId': 'prod_005',
        'username': 'retro_collection_80s',
        'content': '80-90年代復刻シール発見！懐かしすぎて涙出そう😢 大阪のカードショップBで¥1,580でした。コレクター必見です！',
        'imageUrl': 'https://via.placeholder.com/300/9370DB/FFFFFF?text=Retro+Stickers',
        'postUrl': 'https://instagram.com/p/retro123',
        'postedAt': now.subtract(const Duration(hours: 10)).toIso8601String(),
        'storeName': 'カードショップB',
        'location': '大阪府大阪市',
        'price': 1580.0,
        'isVerified': true,
      },
      {
        'id': 'sns_009',
        'type': 'twitter',
        'productId': 'prod_005',
        'username': '@yokohama_hobby',
        'content': 'レトロシール復刻版入荷しました！横浜ホビーストアCにて¥1,480。80年代好きにはたまらないラインナップです。',
        'imageUrl': null,
        'postUrl': 'https://twitter.com/yokohama_hobby/status/901234',
        'postedAt': now.subtract(const Duration(hours: 12)).toIso8601String(),
        'storeName': 'ホビーストアC',
        'location': '神奈川県横浜市',
        'price': 1480.0,
        'isVerified': true,
      },
      {
        'id': 'sns_010',
        'type': 'line',
        'productId': 'prod_005',
        'username': 'レトログッズ愛好会',
        'content': '80-90年代シール復刻版、めちゃくちゃ貴重です！見かけたら即買い推奨。定価より高くなる前に確保しましょう。',
        'imageUrl': null,
        'postUrl': 'https://line.me/ti/g/retro789',
        'postedAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        'storeName': null,
        'location': null,
        'price': null,
        'isVerified': false,
      },
    ];
  }
  
  /// 商品IDでSNS投稿をフィルター
  static List<Map<String, dynamic>> getPostsByProduct(String productId) {
    return getSampleSnsPosts()
        .where((post) => post['productId'] == productId)
        .toList();
  }
  
  /// SNSタイプでフィルター
  static List<Map<String, dynamic>> getPostsByType(SnsType type) {
    final typeString = type.toString().split('.').last;
    return getSampleSnsPosts()
        .where((post) => post['type'] == typeString)
        .toList();
  }
}
