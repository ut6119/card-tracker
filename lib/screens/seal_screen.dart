import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_provider.dart';
import '../models/news_item.dart';
import '../widgets/news_card.dart';
import '../widgets/search_link_button.dart';
import '../services/search_url_service.dart';

/// ボンボンドロップシール専用画面
class SealScreen extends StatelessWidget {
  const SealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Consumer<TrackerProvider>(
        builder: (context, provider, child) {
          final items =
              provider.getItemsByCategory(InfoCategory.bonbonDrop);

          return RefreshIndicator(
            onRefresh: provider.refresh,
            color: Colors.pink,
            child: CustomScrollView(
              slivers: [
                // AppBar
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0.5,
                  title: const Text(
                    'ボンボンドロップシール',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  actions: [
                    if (provider.isRefreshing)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.pink,
                          ),
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: provider.refresh,
                      ),
                  ],
                ),

                // Grokクイックアクセス
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.pink.shade50,
                          Colors.pink.shade100.withValues(alpha: 0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.pink.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.smart_toy,
                                size: 20, color: Colors.pink.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'GrokにボンボンドロップシールのX最新情報を聞く',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.pink.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SearchLinkGrid(
                          links: [
                            SearchLink(
                              label: '入荷・販売情報',
                              url: SearchUrlService.grokSearchUrl(
                                  'ボンボンドロップシール 入荷 販売 最新情報'),
                              source: SourceType.grok,
                            ),
                            SearchLink(
                              label: '新作・抽選情報',
                              url: SearchUrlService.grokSearchUrl(
                                  'ボンボンドロップシール 新作 抽選 2025'),
                              source: SourceType.grok,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 検索リンク集
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '各サイトで検索',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...SearchUrlService.getBonbonDropLinks()
                            .map((link) => SearchLinkButton(link: link)),
                      ],
                    ),
                  ),
                ),

                // 情報フィード見出し
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
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
                  ),
                ),

                // ニュースカードリスト
                if (items.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          '情報がありません。下に引っ張って更新してください。',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          return NewsCard(
                            item: item,
                            showCategory: false,
                            isFavorite: provider.isFavorite(item.id),
                            onFavoriteToggle: () =>
                                provider.toggleFavorite(item.id),
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
