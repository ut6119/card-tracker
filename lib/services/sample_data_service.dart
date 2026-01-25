/// サンプルデータ提供サービス
/// Web APIが実装されるまでの仮データを提供
class SampleDataService {
  /// サンプル商品データを取得
  static List<Map<String, dynamic>> getSampleProducts() {
    final now = DateTime.now();
    
    return [
      {
        'id': 'prod_001',
        'name': 'ボンボンドロップ 第1弾 コンプリートセット',
        'category': 'ボンボンドロップ',
        'imageUrl': 'https://via.placeholder.com/150/FF69B4/FFFFFF?text=BonBon+Drop+1',
        'description': 'ボンボンドロップシリーズの第1弾。全12種類のシールがセットになった商品です。',
        'prices': [
          {
            'storeId': 'store_001',
            'storeName': 'トイズショップA',
            'price': 1280.0,
            'inStock': true,
            'location': '東京都渋谷区',
            'url': 'https://example.com/shop-a/prod001',
            'lastUpdated': now.subtract(const Duration(hours: 2)).toIso8601String(),
          },
          {
            'storeId': 'store_002',
            'storeName': 'カードショップB',
            'price': 1350.0,
            'inStock': true,
            'location': '大阪府大阪市',
            'url': 'https://example.com/shop-b/prod001',
            'lastUpdated': now.subtract(const Duration(hours: 5)).toIso8601String(),
          },
          {
            'storeId': 'store_003',
            'storeName': 'ホビーストアC',
            'price': 1200.0,
            'inStock': false,
            'location': '神奈川県横浜市',
            'url': 'https://example.com/shop-c/prod001',
            'lastUpdated': now.subtract(const Duration(days: 1)).toIso8601String(),
          },
        ],
      },
      {
        'id': 'prod_002',
        'name': 'ボンボンドロップ 第2弾 レアシールパック',
        'category': 'ボンボンドロップ',
        'imageUrl': 'https://via.placeholder.com/150/87CEEB/FFFFFF?text=BonBon+Drop+2',
        'description': 'ボンボンドロップ第2弾のレアシール入りパック。限定デザインあり。',
        'prices': [
          {
            'storeId': 'store_001',
            'storeName': 'トイズショップA',
            'price': 850.0,
            'inStock': true,
            'location': '東京都渋谷区',
            'url': 'https://example.com/shop-a/prod002',
            'lastUpdated': now.subtract(const Duration(hours: 3)).toIso8601String(),
          },
          {
            'storeId': 'store_004',
            'storeName': 'オンラインショップD',
            'price': 780.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://example.com/shop-d/prod002',
            'lastUpdated': now.subtract(const Duration(hours: 1)).toIso8601String(),
          },
        ],
      },
      {
        'id': 'prod_003',
        'name': 'キラキラシールコレクション Vol.1',
        'category': 'キラキラシール',
        'imageUrl': 'https://via.placeholder.com/150/FFD700/FFFFFF?text=Kirakira+1',
        'description': 'キラキラ光るホログラムシールのコレクション第1弾。',
        'prices': [
          {
            'storeId': 'store_002',
            'storeName': 'カードショップB',
            'price': 950.0,
            'inStock': true,
            'location': '大阪府大阪市',
            'url': 'https://example.com/shop-b/prod003',
            'lastUpdated': now.subtract(const Duration(hours: 4)).toIso8601String(),
          },
          {
            'storeId': 'store_003',
            'storeName': 'ホビーストアC',
            'price': 920.0,
            'inStock': true,
            'location': '神奈川県横浜市',
            'url': 'https://example.com/shop-c/prod003',
            'lastUpdated': now.subtract(const Duration(hours: 6)).toIso8601String(),
          },
        ],
      },
      {
        'id': 'prod_004',
        'name': 'アニメキャラシール 人気キャラ詰め合わせ',
        'category': 'アニメシール',
        'imageUrl': 'https://via.placeholder.com/150/FF6347/FFFFFF?text=Anime+Mix',
        'description': '人気アニメキャラクターのシールがランダムで入ったお得なセット。',
        'prices': [
          {
            'storeId': 'store_001',
            'storeName': 'トイズショップA',
            'price': 680.0,
            'inStock': true,
            'location': '東京都渋谷区',
            'url': 'https://example.com/shop-a/prod004',
            'lastUpdated': now.subtract(const Duration(minutes: 30)).toIso8601String(),
          },
          {
            'storeId': 'store_004',
            'storeName': 'オンラインショップD',
            'price': 650.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://example.com/shop-d/prod004',
            'lastUpdated': now.subtract(const Duration(hours: 2)).toIso8601String(),
          },
          {
            'storeId': 'store_005',
            'storeName': 'メガストアE',
            'price': 720.0,
            'inStock': false,
            'location': '愛知県名古屋市',
            'url': 'https://example.com/shop-e/prod004',
            'lastUpdated': now.subtract(const Duration(days: 2)).toIso8601String(),
          },
        ],
      },
      {
        'id': 'prod_005',
        'name': 'レトロシール 80-90年代復刻版',
        'category': 'レトロシール',
        'imageUrl': 'https://via.placeholder.com/150/9370DB/FFFFFF?text=Retro+80s',
        'description': '80-90年代の懐かしいシールを復刻。コレクターアイテムとしても人気。',
        'prices': [
          {
            'storeId': 'store_002',
            'storeName': 'カードショップB',
            'price': 1580.0,
            'inStock': true,
            'location': '大阪府大阪市',
            'url': 'https://example.com/shop-b/prod005',
            'lastUpdated': now.subtract(const Duration(hours: 8)).toIso8601String(),
          },
          {
            'storeId': 'store_003',
            'storeName': 'ホビーストアC',
            'price': 1480.0,
            'inStock': true,
            'location': '神奈川県横浜市',
            'url': 'https://example.com/shop-c/prod005',
            'lastUpdated': now.subtract(const Duration(hours: 12)).toIso8601String(),
          },
        ],
      },
    ];
  }
  
  /// カテゴリー一覧を取得
  static List<String> getCategories() {
    return [
      'すべて',
      'ボンボンドロップ',
      'キラキラシール',
      'アニメシール',
      'レトロシール',
    ];
  }
}
