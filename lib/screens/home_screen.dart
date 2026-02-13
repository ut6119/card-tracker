import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_provider.dart';
import '../models/news_item.dart';
import '../widgets/news_card.dart';
import '../services/search_url_service.dart';
import '../widgets/search_link_button.dart';

/// ホーム画面（ダッシュボード）
/// 全カテゴリの最新情報を統合表示
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Consumer<TrackerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.black),
                  SizedBox(height: 16),
                  Text('最新情報を取得中...'),
                ],
              ),
            );
          }

          final items = provider.allItems;
          items.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

          return RefreshIndicator(
            onRefresh: provider.refresh,
            color: Colors.black,
            child: CustomScrollView(
              slivers: [
                // AppBar
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0.5,
                  title: const Text(
                    'ボンボン＆ガチャトラッカー',
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
                            color: Colors.black,
                          ),
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: provider.refresh,
                        tooltip: '最新情報を取得',
                      ),
                  ],
                ),

                // ステータスバー
                SliverToBoxAdapter(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(Icons.circle,
                            size: 8,
                            color: provider.lastError == null
                                ? Colors.green
                                : Colors.orange),
                        const SizedBox(width: 6),
                        Text(
                          provider.lastUpdated != null
                              ? '最終更新: ${_formatTime(provider.lastUpdated!)}'
                              : '未更新',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${items.length}件の情報',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // クイックアクセス（Grokへのリンク）
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Grokに聞く（AI要約）',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SearchLinkGrid(
                          links: [
                            SearchLink(
                              label: 'ボンボンドロップ',
                              url: SearchUrlService.grokSearchUrl(
                                  'ボンボンドロップシール 入荷 販売 最新'),
                              source: SourceType.grok,
                            ),
                            SearchLink(
                              label: 'たまごっちガチャ',
                              url: SearchUrlService.grokSearchUrl(
                                  'たまごっち ガチャガチャ 新作 最新'),
                              source: SourceType.grok,
                            ),
                            SearchLink(
                              label: 'ズートピアガチャ',
                              url: SearchUrlService.grokSearchUrl(
                                  'ズートピア ガチャガチャ 新作 最新'),
                              source: SourceType.grok,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 情報フィード
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      '最新情報',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ),

                // ニュースカードリスト
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        return NewsCard(
                          item: item,
                          showCategory: true,
                          isFavorite: provider.isFavorite(item.id),
                          onFavoriteToggle: () =>
                              provider.toggleFavorite(item.id),
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                ),

                // 余白
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'たった今';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分前';
    if (diff.inHours < 24) return '${diff.inHours}時間前';
    return '${time.month}/${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
