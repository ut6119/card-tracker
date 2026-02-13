import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';

/// ニュース/情報カードウィジェット
/// 全画面で共通利用するカード表示
class NewsCard extends StatelessWidget {
  final NewsItem item;
  final bool showCategory;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const NewsCard({
    super.key,
    required this.item,
    this.showCategory = true,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final sourceColor = Color(item.source.iconColor);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () => _openUrl(item.url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー行
              Row(
                children: [
                  // ソースアイコン
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: sourceColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getSourceIcon(item.source),
                      color: sourceColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // ソース名 + 著者
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.source.displayName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: sourceColor,
                          ),
                        ),
                        if (item.author != null)
                          Text(
                            item.author!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // カテゴリバッジ
                  if (showCategory)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(item.category)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.category.shortName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getCategoryColor(item.category),
                        ),
                      ),
                    ),
                  // お気に入りボタン
                  if (onFavoriteToggle != null)
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                        size: 20,
                        color: isFavorite ? Colors.amber.shade700 : Colors.grey,
                      ),
                      onPressed: onFavoriteToggle,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // タイトル
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // コンテンツ
              Text(
                item.content,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // 価格/場所がある場合
              if (item.price != null || item.location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (item.location != null) ...[
                      Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 2),
                      Text(
                        item.location!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                    ],
                    if (item.price != null)
                      Text(
                        '¥${item.price!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],

              // フッター: 認証バッジ + リンク
              const SizedBox(height: 8),
              Row(
                children: [
                  if (item.isVerified) ...[
                    Icon(Icons.verified, size: 14, color: Colors.blue.shade400),
                    const SizedBox(width: 4),
                    Text(
                      '公式',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(Icons.open_in_new,
                      size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    'タップして開く',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSourceIcon(SourceType source) {
    switch (source) {
      case SourceType.xTwitter:
        return Icons.alternate_email;
      case SourceType.grok:
        return Icons.smart_toy;
      case SourceType.instagram:
        return Icons.camera_alt;
      case SourceType.official:
        return Icons.verified;
      case SourceType.rakuten:
        return Icons.shopping_bag;
      case SourceType.amazon:
        return Icons.shopping_cart;
      case SourceType.mercari:
        return Icons.storefront;
      case SourceType.youtube:
        return Icons.play_circle;
      case SourceType.line:
        return Icons.chat_bubble;
      case SourceType.yahoo:
        return Icons.search;
      case SourceType.google:
        return Icons.search;
      case SourceType.news:
        return Icons.article;
      case SourceType.other:
        return Icons.link;
    }
  }

  Color _getCategoryColor(InfoCategory category) {
    switch (category) {
      case InfoCategory.bonbonDrop:
        return Colors.pink;
      case InfoCategory.gacha:
        return Colors.purple;
      case InfoCategory.tamagotchi:
        return Colors.teal;
      case InfoCategory.zootopia:
        return Colors.green;
      case InfoCategory.other:
        return Colors.grey;
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    }
  }
}
