import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/news_item.dart';

/// Web情報取得サービス
/// Yahoo!リアルタイム検索等からX投稿情報を取得
class WebScraperService {
  static const _timeout = Duration(seconds: 15);
  static const _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  /// Yahoo!リアルタイム検索からX投稿URLを取得
  Future<List<NewsItem>> fetchFromYahooRealtime(
    String keyword, {
    InfoCategory category = InfoCategory.other,
  }) async {
    final posts = <NewsItem>[];

    try {
      final url = Uri.parse(
        'https://search.yahoo.co.jp/realtime/search'
        '?p=${Uri.encodeComponent(keyword)}&ei=UTF-8',
      );

      final response = await http
          .get(url, headers: {'User-Agent': _userAgent})
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final html = response.body;
        // X/Twitter URLを抽出
        final xUrlPattern =
            RegExp(r'https://(?:twitter\.com|x\.com)/([^/]+)/status/(\d+)');
        final matches = xUrlPattern.allMatches(html);
        final seen = <String>{};

        for (final match in matches) {
          final fullUrl = match.group(0)!;
          final username = match.group(1)!;
          final statusId = match.group(2)!;

          if (seen.contains(statusId)) continue;
          seen.add(statusId);

          posts.add(NewsItem(
            id: 'yahoo_$statusId',
            title: '@$username の投稿',
            content: '「$keyword」に関するX投稿。タップして内容を確認。',
            url: fullUrl,
            source: SourceType.xTwitter,
            category: category,
            publishedAt: DateTime.now(),
            author: '@$username',
            isVerified: false,
          ));
        }

        if (kDebugMode) {
          debugPrint('Yahoo!リアルタイム: ${posts.length}件取得 ($keyword)');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Yahoo!リアルタイム検索エラー ($keyword): $e');
      }
    }

    return posts;
  }

  /// 複数キーワードでYahoo!リアルタイム検索を実行
  Future<List<NewsItem>> fetchMultipleKeywords(
    List<String> keywords, {
    InfoCategory category = InfoCategory.other,
  }) async {
    final allPosts = <NewsItem>[];
    final seenUrls = <String>{};

    for (final keyword in keywords) {
      final posts = await fetchFromYahooRealtime(keyword, category: category);
      for (final post in posts) {
        if (!seenUrls.contains(post.url)) {
          seenUrls.add(post.url);
          allPosts.add(post);
        }
      }
      // レート制限対策
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return allPosts;
  }

  /// ボンボンドロップシール関連のX投稿を取得
  Future<List<NewsItem>> fetchBonbonDropPosts() async {
    return fetchMultipleKeywords(
      [
        'ボンボンドロップシール',
        'ボンボンドロップシール 入荷',
        'ボンボンドロップシール 販売',
        'ボンボンドロップ 再販',
      ],
      category: InfoCategory.bonbonDrop,
    );
  }

  /// たまごっちガチャ関連のX投稿を取得
  Future<List<NewsItem>> fetchTamagotchiGachaPosts() async {
    return fetchMultipleKeywords(
      [
        'たまごっち ガチャ',
        'たまごっち ガチャガチャ',
        'たまごっち カプセルトイ',
      ],
      category: InfoCategory.tamagotchi,
    );
  }

  /// ズートピアガチャ関連のX投稿を取得
  Future<List<NewsItem>> fetchZootopiaGachaPosts() async {
    return fetchMultipleKeywords(
      [
        'ズートピア ガチャ',
        'ズートピア ガチャガチャ',
        'ズートピア カプセルトイ',
      ],
      category: InfoCategory.zootopia,
    );
  }

  /// 全カテゴリのX投稿を一括取得
  Future<List<NewsItem>> fetchAllPosts() async {
    final results = <NewsItem>[];

    final bonbon = await fetchBonbonDropPosts();
    results.addAll(bonbon);

    final tamagotchi = await fetchTamagotchiGachaPosts();
    results.addAll(tamagotchi);

    final zootopia = await fetchZootopiaGachaPosts();
    results.addAll(zootopia);

    // 重複除去
    final seen = <String>{};
    final unique = <NewsItem>[];
    for (final item in results) {
      if (!seen.contains(item.url)) {
        seen.add(item.url);
        unique.add(item);
      }
    }

    return unique;
  }
}
