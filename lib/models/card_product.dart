/// シール・トレーディングカード商品モデル
/// 商品の基本情報を保持するクラス
class CardProduct {
  final String id;              // 商品ID
  final String name;            // 商品名
  final String category;        // カテゴリー（例：ボンボンドロップ、ポケモンカード等）
  final String imageUrl;        // 商品画像URL
  final String description;     // 商品説明
  final List<PriceInfo> prices; // 価格情報リスト（複数の店舗）
  
  CardProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.prices,
  });
  
  /// 最安値を取得
  double get lowestPrice {
    if (prices.isEmpty) return 0.0;
    return prices.map((p) => p.price).reduce((a, b) => a < b ? a : b);
  }
  
  /// 最高値を取得
  double get highestPrice {
    if (prices.isEmpty) return 0.0;
    return prices.map((p) => p.price).reduce((a, b) => a > b ? a : b);
  }
  
  /// 平均価格を取得
  double get averagePrice {
    if (prices.isEmpty) return 0.0;
    return prices.map((p) => p.price).reduce((a, b) => a + b) / prices.length;
  }
  
  /// JSONからオブジェクトを生成
  factory CardProduct.fromJson(Map<String, dynamic> json) {
    return CardProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      prices: (json['prices'] as List)
          .map((p) => PriceInfo.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
  
  /// JSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'prices': prices.map((p) => p.toJson()).toList(),
    };
  }
}

/// 価格情報モデル
/// 各店舗での価格と在庫状況を保持
class PriceInfo {
  final String storeId;       // 店舗ID
  final String storeName;     // 店舗名
  final double price;         // 価格（円）
  final bool inStock;         // 在庫有無
  final String? location;     // 店舗所在地
  final String? url;          // 商品ページURL
  final DateTime lastUpdated; // 最終更新日時
  
  PriceInfo({
    required this.storeId,
    required this.storeName,
    required this.price,
    required this.inStock,
    this.location,
    this.url,
    required this.lastUpdated,
  });
  
  /// JSONからオブジェクトを生成
  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      storeId: json['storeId'] as String,
      storeName: json['storeName'] as String,
      price: (json['price'] as num).toDouble(),
      inStock: json['inStock'] as bool,
      location: json['location'] as String?,
      url: json['url'] as String?,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
  
  /// JSONに変換
  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'storeName': storeName,
      'price': price,
      'inStock': inStock,
      'location': location,
      'url': url,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
