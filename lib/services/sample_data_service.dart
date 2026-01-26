/// サンプルデータ提供サービス
/// Web APIが実装されるまでの仮データを提供
class SampleDataService {
  /// サンプル商品データを取得
  static List<Map<String, dynamic>> getSampleProducts() {
    final now = DateTime.now();
    
    return [
      {
        'id': 'prod_001',
        'name': 'サンリオキャラクターズ ボンボンドロップシール',
        'category': 'ボンボンドロップ',
        'imageUrl': 'https://via.placeholder.com/150/FF69B4/FFFFFF?text=Sanrio',
        'description': 'サンリオキャラクターズのボンボンドロップシール。ハローキティ、マイメロディ、シナモロールなど人気キャラクターが登場。',
        'prices': [
          {
            'storeId': 'store_001',
            'storeName': 'サンリオオンラインショップ',
            'price': 550.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://shop.sanrio.co.jp/item?category_id=176',
            'lastUpdated': now.subtract(const Duration(hours: 2)).toIso8601String(),
          },
          {
            'storeId': 'store_002',
            'storeName': '楽天市場',
            'price': 580.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://search.rakuten.co.jp/search/mall/%E3%83%9C%E3%83%B3%E3%83%9C%E3%83%B3%E3%83%89%E3%83%AD%E3%83%83%E3%83%97+%E3%82%B5%E3%83%B3%E3%83%AA%E3%82%AA/',
            'lastUpdated': now.subtract(const Duration(hours: 5)).toIso8601String(),
          },
          {
            'storeId': 'store_003',
            'storeName': 'ロフト',
            'price': 550.0,
            'inStock': false,
            'location': '全国各店',
            'url': 'https://www.loft.co.jp/',
            'lastUpdated': now.subtract(const Duration(days: 1)).toIso8601String(),
          },
        ],
      },
      {
        'id': 'prod_002',
        'name': 'たまごっち キラキラシール',
        'category': 'キラキラシール',
        'imageUrl': 'https://via.placeholder.com/150/87CEEB/FFFFFF?text=Tamagotchi',
        'description': 'たまごっちの公式キラキラシール。ぷっくりした質感で可愛いデザイン。',
        'prices': [
          {
            'storeId': 'store_001',
            'storeName': 'たまごっち公式サイト',
            'price': 550.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://tamagotchi-official.com/jp/item/',
            'lastUpdated': now.subtract(const Duration(hours: 3)).toIso8601String(),
          },
          {
            'storeId': 'store_004',
            'storeName': 'Amazon',
            'price': 598.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://www.amazon.co.jp/s?k=%E3%81%9F%E3%81%BE%E3%81%94%E3%81%A3%E3%81%A1+%E3%82%B7%E3%83%BC%E3%83%AB',
            'lastUpdated': now.subtract(const Duration(hours: 1)).toIso8601String(),
          },
        ],
      },
      {
        'id': 'prod_003',
        'name': 'サンリオ シールコレクション',
        'category': 'サンリオ',
        'imageUrl': 'https://via.placeholder.com/150/FFD700/FFFFFF?text=Sanrio+Collection',
        'description': 'サンリオ公式のシールコレクション。ハローキティ、マイメロディ、ポムポムプリンなど多数。',
        'prices': [
          {
            'storeId': 'store_002',
            'storeName': 'サンリオオンラインショップ',
            'price': 440.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://shop.sanrio.co.jp/item?category_id=176',
            'lastUpdated': now.subtract(const Duration(hours: 4)).toIso8601String(),
          },
          {
            'storeId': 'store_003',
            'storeName': '楽天市場',
            'price': 480.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://search.rakuten.co.jp/search/mall/%E3%82%B5%E3%83%B3%E3%83%AA%E3%82%AA+%E3%82%B7%E3%83%BC%E3%83%AB/',
            'lastUpdated': now.subtract(const Duration(hours: 6)).toIso8601String(),
          },
        ],
      },
      {
        'id': 'prod_004',
        'name': 'ディズニー ボンボンドロップシール',
        'category': 'ボンボンドロップ',
        'imageUrl': 'https://via.placeholder.com/150/FF6347/FFFFFF?text=Disney',
        'description': 'ディズニーキャラクターのボンボンドロップシール。ミッキー、ミニー、プーさんなど人気キャラクター。',
        'prices': [
          {
            'storeId': 'store_001',
            'storeName': 'ロフト',
            'price': 550.0,
            'inStock': true,
            'location': '全国各店',
            'url': 'https://www.loft.co.jp/',
            'lastUpdated': now.subtract(const Duration(minutes: 30)).toIso8601String(),
          },
          {
            'storeId': 'store_004',
            'storeName': '楽天市場',
            'price': 580.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://search.rakuten.co.jp/search/mall/%E3%83%9C%E3%83%B3%E3%83%9C%E3%83%B3%E3%83%89%E3%83%AD%E3%83%83%E3%83%97+%E3%83%87%E3%82%A3%E3%82%BA%E3%83%8B%E3%83%BC/',
            'lastUpdated': now.subtract(const Duration(hours: 2)).toIso8601String(),
          },
          {
            'storeId': 'store_005',
            'storeName': 'Amazon',
            'price': 598.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://www.amazon.co.jp/s?k=%E3%83%9C%E3%83%B3%E3%83%9C%E3%83%B3%E3%83%89%E3%83%AD%E3%83%83%E3%83%97+%E3%83%87%E3%82%A3%E3%82%BA%E3%83%8B%E3%83%BC',
            'lastUpdated': now.subtract(const Duration(days: 2)).toIso8601String(),
          },
        ],
      },
      {
        'id': 'prod_005',
        'name': 'スヌーピー ボンボンドロップシール',
        'category': 'キャラクターシール',
        'imageUrl': 'https://via.placeholder.com/150/9370DB/FFFFFF?text=Snoopy',
        'description': 'スヌーピーとピーナッツの仲間たちのボンボンドロップシール。',
        'prices': [
          {
            'storeId': 'store_002',
            'storeName': 'ハンズ',
            'price': 550.0,
            'inStock': true,
            'location': '全国各店',
            'url': 'https://hands.net/',
            'lastUpdated': now.subtract(const Duration(hours: 8)).toIso8601String(),
          },
          {
            'storeId': 'store_003',
            'storeName': '楽天市場',
            'price': 580.0,
            'inStock': true,
            'location': 'オンライン',
            'url': 'https://search.rakuten.co.jp/search/mall/%E3%83%9C%E3%83%B3%E3%83%9C%E3%83%B3%E3%83%89%E3%83%AD%E3%83%83%E3%83%97+%E3%82%B9%E3%83%8C%E3%83%BC%E3%83%94%E3%83%BC/',
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
      'サンリオ',
      'たまごっち',
      'キャラクターシール',
    ];
  }
}
