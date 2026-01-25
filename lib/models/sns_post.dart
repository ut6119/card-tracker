/// SNS投稿情報モデル
/// X、Instagram、LINEオープンチャットなどの情報を保持
class SnsPost {
  final String id;              // 投稿ID
  final SnsType type;           // SNSの種類
  final String productId;       // 関連商品ID
  final String username;        // 投稿者名
  final String content;         // 投稿内容
  final String? imageUrl;       // 投稿画像URL
  final String postUrl;         // 投稿URL
  final DateTime postedAt;      // 投稿日時
  final String? storeName;      // 店舗名（あれば）
  final String? location;       // 場所情報（あれば）
  final double? price;          // 価格情報（あれば）
  final bool isVerified;        // 検証済み情報かどうか
  
  SnsPost({
    required this.id,
    required this.type,
    required this.productId,
    required this.username,
    required this.content,
    this.imageUrl,
    required this.postUrl,
    required this.postedAt,
    this.storeName,
    this.location,
    this.price,
    this.isVerified = false,
  });
  
  /// JSONからオブジェクトを生成
  factory SnsPost.fromJson(Map<String, dynamic> json) {
    return SnsPost(
      id: json['id'] as String,
      type: SnsType.values.firstWhere(
        (e) => e.toString() == 'SnsType.${json['type']}',
      ),
      productId: json['productId'] as String,
      username: json['username'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      postUrl: json['postUrl'] as String,
      postedAt: DateTime.parse(json['postedAt'] as String),
      storeName: json['storeName'] as String?,
      location: json['location'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
  
  /// JSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'productId': productId,
      'username': username,
      'content': content,
      'imageUrl': imageUrl,
      'postUrl': postUrl,
      'postedAt': postedAt.toIso8601String(),
      'storeName': storeName,
      'location': location,
      'price': price,
      'isVerified': isVerified,
    };
  }
}

/// SNSの種類を定義
enum SnsType {
  twitter,    // X (旧Twitter)
  instagram,  // Instagram
  line,       // LINEオープンチャット
  other,      // その他
}

/// SNSアイコン取得用の拡張
extension SnsTypeExtension on SnsType {
  /// SNS名を取得
  String get displayName {
    switch (this) {
      case SnsType.twitter:
        return 'X (Twitter)';
      case SnsType.instagram:
        return 'Instagram';
      case SnsType.line:
        return 'LINE';
      case SnsType.other:
        return 'その他';
    }
  }
  
  /// アイコン色を取得
  int get iconColor {
    switch (this) {
      case SnsType.twitter:
        return 0xFF1DA1F2; // Xブルー
      case SnsType.instagram:
        return 0xFFE4405F; // Instagramピンク
      case SnsType.line:
        return 0xFF00B900; // LINEグリーン
      case SnsType.other:
        return 0xFF9E9E9E; // グレー
    }
  }
}
