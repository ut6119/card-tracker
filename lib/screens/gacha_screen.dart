import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_provider.dart';
import '../models/news_item.dart';
import '../widgets/news_card.dart';
import '../widgets/search_link_button.dart';
import '../services/search_url_service.dart';

/// ガチャガチャ専用画面（たまごっち＆ズートピア）
class GachaScreen extends StatefulWidget {
  const GachaScreen({super.key});

  @override
  State<GachaScreen> createState() => _GachaScreenState();
}

class _GachaScreenState extends State<GachaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0.5,
              title: const Text(
                'ガチャガチャ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              actions: [
                Consumer<TrackerProvider>(
                  builder: (context, provider, _) {
                    if (provider.isRefreshing) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.purple,
                          ),
                        ),
                      );
                    }
                    return IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: provider.refresh,
                    );
                  },
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: 'すべて'),
                  Tab(text: 'たまごっち'),
                  Tab(text: 'ズートピア'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _GachaCategoryView(category: InfoCategory.gacha),
            _GachaCategoryView(category: InfoCategory.tamagotchi),
            _GachaCategoryView(category: InfoCategory.zootopia),
          ],
        ),
      ),
    );
  }
}

/// ガチャカテゴリ別ビュー
class _GachaCategoryView extends StatelessWidget {
  final InfoCategory category;

  const _GachaCategoryView({required this.category});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackerProvider>(
      builder: (context, provider, child) {
        final items = provider.getItemsByCategory(category);
        final searchLinks = SearchUrlService.getLinksForCategory(category);

        return RefreshIndicator(
          onRefresh: provider.refresh,
          color: Colors.purple,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Grokクイックアクセス
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade50,
                      Colors.teal.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.smart_toy,
                            size: 20, color: Colors.purple.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Grokに${category.shortName}ガチャの最新情報を聞く',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SearchLinkGrid(
                      links: _getGrokLinks(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 検索リンク集
              Text(
                '各サイトで検索',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              ...searchLinks.map((link) => SearchLinkButton(link: link)),

              const SizedBox(height: 16),

              // キュレーション情報
              Row(
                children: [
                  Text(
                    'キュレーション情報',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${items.length}件',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      '情報がありません。下に引っ張って更新してください。',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...items.map((item) => NewsCard(
                      item: item,
                      showCategory: category == InfoCategory.gacha,
                      isFavorite: provider.isFavorite(item.id),
                      onFavoriteToggle: () =>
                          provider.toggleFavorite(item.id),
                    )),

              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }

  List<SearchLink> _getGrokLinks() {
    switch (category) {
      case InfoCategory.tamagotchi:
        return [
          SearchLink(
            label: 'たまごっち新作',
            url: SearchUrlService.grokSearchUrl(
                'たまごっち ガチャガチャ 新作 最新情報'),
            source: SourceType.grok,
          ),
          SearchLink(
            label: '設置場所',
            url: SearchUrlService.grokSearchUrl(
                'たまごっち ガチャ 設置場所 どこ'),
            source: SourceType.grok,
          ),
        ];
      case InfoCategory.zootopia:
        return [
          SearchLink(
            label: 'ズートピア新作',
            url: SearchUrlService.grokSearchUrl(
                'ズートピア ガチャガチャ 新作 最新情報'),
            source: SourceType.grok,
          ),
          SearchLink(
            label: '設置場所',
            url: SearchUrlService.grokSearchUrl(
                'ズートピア ガチャ 設置場所 どこ'),
            source: SourceType.grok,
          ),
        ];
      default:
        return [
          SearchLink(
            label: 'ガチャ全般',
            url: SearchUrlService.grokSearchUrl(
                'ガチャガチャ 新作 人気 最新情報'),
            source: SourceType.grok,
          ),
        ];
    }
  }
}
