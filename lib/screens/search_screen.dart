import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';
import '../services/search_url_service.dart';

/// マルチプラットフォーム検索画面
/// 自由キーワードで各プラットフォームを一括検索
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  // プリセットキーワード
  static const _presetKeywords = [
    'ボンボンドロップシール',
    'たまごっち ガチャ',
    'ズートピア ガチャ',
    'ボンボンドロップ 入荷',
    'たまごっち カプセルトイ 新作',
    'ガチャガチャ 新作 2025',
    'ボンボンドロップ サンリオ',
    'ディズニー ガチャ',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      _currentQuery = query.trim();
      _searchController.text = _currentQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: const Text(
          '検索',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // 検索バー
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'キーワードを入力して各サイトを検索',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _currentQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _currentQuery = value.trim();
                });
              },
              onSubmitted: (value) {
                _search(value);
              },
            ),
          ),

          // 検索結果 or プリセット
          Expanded(
            child: _currentQuery.isEmpty
                ? _buildPresetView()
                : _buildSearchResultsView(),
          ),
        ],
      ),
    );
  }

  /// プリセットキーワード表示
  Widget _buildPresetView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'おすすめキーワード',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _presetKeywords.map((keyword) {
            return ActionChip(
              label: Text(keyword, style: const TextStyle(fontSize: 13)),
              onPressed: () => _search(keyword),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        Text(
          'カテゴリ別クイックリンク',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),

        _buildCategoryCard(
          'ボンボンドロップシール',
          Icons.auto_awesome,
          Colors.pink,
          SearchUrlService.getBonbonDropLinks().take(4).toList(),
        ),
        _buildCategoryCard(
          'たまごっちガチャ',
          Icons.egg,
          Colors.teal,
          SearchUrlService.getTamagotchiGachaLinks().take(4).toList(),
        ),
        _buildCategoryCard(
          'ズートピアガチャ',
          Icons.pets,
          Colors.green,
          SearchUrlService.getZootopiaGachaLinks().take(4).toList(),
        ),
      ],
    );
  }

  /// カテゴリカード
  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color color,
    List<SearchLink> links,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: links.map((link) {
                final linkColor = Color(link.source.iconColor);
                return ActionChip(
                  avatar: Icon(_getIcon(link.source),
                      size: 14, color: linkColor),
                  label: Text(
                    link.source.displayName,
                    style: TextStyle(fontSize: 11, color: linkColor),
                  ),
                  onPressed: () => _openUrl(link.url),
                  backgroundColor: linkColor.withValues(alpha: 0.08),
                  side: BorderSide(color: linkColor.withValues(alpha: 0.2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 検索結果表示（キーワード入力時）
  Widget _buildSearchResultsView() {
    final keyword = _currentQuery;

    final searchTargets = [
      _SearchTarget(
        'Grokに聞く（AI要約）',
        SearchUrlService.grokSearchUrl(keyword),
        SourceType.grok,
        'GrokがX上の最新情報をAIで分析・要約',
      ),
      _SearchTarget(
        'X (Twitter) リアルタイム検索',
        SearchUrlService.xSearchUrl(keyword),
        SourceType.xTwitter,
        'X上の最新投稿をリアルタイムで検索',
      ),
      _SearchTarget(
        'Yahoo! リアルタイム検索',
        SearchUrlService.yahooRealtimeUrl(keyword),
        SourceType.yahoo,
        'X投稿をログイン不要で検索（推奨）',
      ),
      _SearchTarget(
        'Instagram ハッシュタグ',
        SearchUrlService.instagramTagUrl(keyword),
        SourceType.instagram,
        'Instagramの関連投稿',
      ),
      _SearchTarget(
        '楽天市場',
        SearchUrlService.rakutenSearchUrl(keyword),
        SourceType.rakuten,
        '楽天市場の在庫・価格をチェック',
      ),
      _SearchTarget(
        'Amazon.co.jp',
        SearchUrlService.amazonSearchUrl(keyword),
        SourceType.amazon,
        'Amazonの在庫・価格をチェック',
      ),
      _SearchTarget(
        'メルカリ',
        SearchUrlService.mercariSearchUrl(keyword),
        SourceType.mercari,
        'メルカリの出品をチェック',
      ),
      _SearchTarget(
        'YouTube',
        SearchUrlService.youtubeSearchUrl(keyword),
        SourceType.youtube,
        '開封動画・レビュー',
      ),
      _SearchTarget(
        'Google ニュース',
        SearchUrlService.googleNewsUrl(keyword),
        SourceType.google,
        '最新のニュース記事',
      ),
      _SearchTarget(
        'Google 検索（直近1週間）',
        SearchUrlService.googleSearchUrl(keyword),
        SourceType.google,
        '直近1週間のWeb検索結果',
      ),
      _SearchTarget(
        'LINE オープンチャット',
        SearchUrlService.lineOpenChatSearchUrl(keyword),
        SourceType.line,
        '関連コミュニティを検索',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '「$keyword」で各サイトを検索',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...searchTargets.map((target) {
          final color = Color(target.source.iconColor);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: color.withValues(alpha: 0.2)),
            ),
            elevation: 0,
            child: InkWell(
              onTap: () => _openUrl(target.url),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getIcon(target.source),
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            target.label,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            target.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.open_in_new,
                        size: 18, color: Colors.grey.shade400),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 60),
      ],
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

class _SearchTarget {
  final String label;
  final String url;
  final SourceType source;
  final String description;

  const _SearchTarget(this.label, this.url, this.source, this.description);
}
