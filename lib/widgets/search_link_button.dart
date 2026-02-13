import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';

/// 外部検索リンクボタン
/// 各プラットフォームへのリンクをカード形式で表示
class SearchLinkButton extends StatelessWidget {
  final SearchLink link;

  const SearchLinkButton({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    final color = Color(link.source.iconColor);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      elevation: 0,
      child: InkWell(
        onTap: () => _openUrl(link.url),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // ソースアイコン
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(link.source),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // テキスト
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (link.description != null)
                      Text(
                        link.description!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(SourceType source) {
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

/// 検索リンクグリッド（コンパクト表示）
class SearchLinkGrid extends StatelessWidget {
  final List<SearchLink> links;

  const SearchLinkGrid({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: links.map((link) {
        final color = Color(link.source.iconColor);
        return ActionChip(
          avatar: Icon(_getIcon(link.source), size: 16, color: color),
          label: Text(
            link.source.displayName,
            style: TextStyle(fontSize: 12, color: color),
          ),
          onPressed: () => _openUrl(link.url),
          backgroundColor: color.withValues(alpha: 0.08),
          side: BorderSide(color: color.withValues(alpha: 0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIcon(SourceType source) {
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
