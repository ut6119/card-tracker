/// 情報カテゴリ
enum InfoCategory {
  bonbonDrop, // ボンボンドロップシール
  gacha,      // ガチャガチャ全般
  tamagotchi, // たまごっちガチャ
  zootopia,   // ズートピアガチャ
  other,      // その他
}

extension InfoCategoryExtension on InfoCategory {
  String get displayName {
    switch (this) {
      case InfoCategory.bonbonDrop:
        return 'ボンボンドロップシール';
      case InfoCategory.gacha:
        return 'ガチャガチャ';
      case InfoCategory.tamagotchi:
        return 'たまごっちガチャ';
      case InfoCategory.zootopia:
        return 'ズートピアガチャ';
      case InfoCategory.other:
        return 'その他';
    }
  }

  String get shortName {
    switch (this) {
      case InfoCategory.bonbonDrop:
        return 'シール';
      case InfoCategory.gacha:
        return 'ガチャ';
      case InfoCategory.tamagotchi:
        return 'たまごっち';
      case InfoCategory.zootopia:
        return 'ズートピア';
      case InfoCategory.other:
        return 'その他';
    }
  }
}

/// 情報ソースの種類
enum SourceType {
  xTwitter,   // X (Twitter)
  grok,       // Grok
  instagram,  // Instagram
  official,   // 公式サイト
  rakuten,    // 楽天
  amazon,     // Amazon
  mercari,    // メルカリ
  youtube,    // YouTube
  line,       // LINE
  yahoo,      // Yahoo!リアルタイム検索
  google,     // Google検索
  news,       // ニュースサイト
  other,      // その他
}

extension SourceTypeExtension on SourceType {
  String get displayName {
    switch (this) {
      case SourceType.xTwitter:
        return 'X (Twitter)';
      case SourceType.grok:
        return 'Grok';
      case SourceType.instagram:
        return 'Instagram';
      case SourceType.official:
        return '公式サイト';
      case SourceType.rakuten:
        return '楽天市場';
      case SourceType.amazon:
        return 'Amazon';
      case SourceType.mercari:
        return 'メルカリ';
      case SourceType.youtube:
        return 'YouTube';
      case SourceType.line:
        return 'LINE';
      case SourceType.yahoo:
        return 'Yahoo!検索';
      case SourceType.google:
        return 'Google';
      case SourceType.news:
        return 'ニュース';
      case SourceType.other:
        return 'その他';
    }
  }

  int get iconColor {
    switch (this) {
      case SourceType.xTwitter:
        return 0xFF000000;
      case SourceType.grok:
        return 0xFF1DA1F2;
      case SourceType.instagram:
        return 0xFFE4405F;
      case SourceType.official:
        return 0xFF4CAF50;
      case SourceType.rakuten:
        return 0xFFBF0000;
      case SourceType.amazon:
        return 0xFFFF9900;
      case SourceType.mercari:
        return 0xFFFF0211;
      case SourceType.youtube:
        return 0xFFFF0000;
      case SourceType.line:
        return 0xFF00B900;
      case SourceType.yahoo:
        return 0xFFFF0033;
      case SourceType.google:
        return 0xFF4285F4;
      case SourceType.news:
        return 0xFF607D8B;
      case SourceType.other:
        return 0xFF9E9E9E;
    }
  }
}

/// 統一情報アイテム
/// シール・ガチャ両方の情報を統一的に扱う
class NewsItem {
  final String id;
  final String title;
  final String content;
  final String url;
  final String? imageUrl;
  final SourceType source;
  final InfoCategory category;
  final DateTime publishedAt;
  final String? author;
  final String? location;
  final double? price;
  final bool isVerified;
  final Map<String, dynamic>? extra;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.url,
    this.imageUrl,
    required this.source,
    required this.category,
    required this.publishedAt,
    this.author,
    this.location,
    this.price,
    this.isVerified = false,
    this.extra,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'url': url,
      'imageUrl': imageUrl,
      'source': source.name,
      'category': category.name,
      'publishedAt': publishedAt.toIso8601String(),
      'author': author,
      'location': location,
      'price': price,
      'isVerified': isVerified,
    };
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String?,
      source: SourceType.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => SourceType.other,
      ),
      category: InfoCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => InfoCategory.other,
      ),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      author: json['author'] as String?,
      location: json['location'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }
}

/// 検索リンク（外部サイトを開くためのリンク情報）
class SearchLink {
  final String label;
  final String url;
  final SourceType source;
  final String? description;

  const SearchLink({
    required this.label,
    required this.url,
    required this.source,
    this.description,
  });
}
