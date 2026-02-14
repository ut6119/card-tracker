import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// リアルタイムSNS情報取得サービス
/// Yahoo!リアルタイム検索とGoogle検索を使用してX投稿を取得
class RealtimeSnsService {
  /// ボンボンドロップ関連のX投稿を検索（大阪・兵庫のみ）
  Future<List<Map<String, dynamic>>> searchSealPosts() async {
    final List<Map<String, dynamic>> allPosts = [];
    
    // 基本検索キーワード（「シール」ワードは除外）
    final baseKeywords = [
      'ボンボンドロップ 入荷',
      'ボンボンドロップ 販売',
      'ボンボンドロップ 抽選',
      'ボンボンドロップ 再販',
    ];
    
    // 大阪・兵庫の地域キーワードを追加
    final keywords = [
      ...baseKeywords,
      ..._getRegionalKeywords(),
    ];
    
    try {
      for (final keyword in keywords) {
        final posts = await _searchByKeyword(keyword);
        allPosts.addAll(posts);
      }
      
      // 重複を削除
      final uniquePosts = <String, Map<String, dynamic>>{};
      for (final post in allPosts) {
        final url = post['url'] as String;
        if (!uniquePosts.containsKey(url)) {
          uniquePosts[url] = post;
        }
      }
      
      return uniquePosts.values.toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('リアルタイム検索エラー: $e');
      }
      return [];
    }
  }
  
  /// キーワードでX投稿を検索
  Future<List<Map<String, dynamic>>> _searchByKeyword(String keyword) async {
    final List<Map<String, dynamic>> posts = [];
    
    try {
      // Yahoo!リアルタイム検索のURL
      final yahooSearchUrl = Uri.parse(
        'https://search.yahoo.co.jp/realtime/search?p=${Uri.encodeComponent(keyword)}&ei=UTF-8'
      );
      
      // HTTPリクエスト
      final response = await http.get(
        yahooSearchUrl,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        // HTMLから投稿情報を抽出
        final htmlContent = response.body;
        
        // 簡易的なパース（実際のX URLを抽出）
        final xUrlPattern = RegExp(r'https://(?:twitter\.com|x\.com)/[^/]+/status/\d+');
        final matches = xUrlPattern.allMatches(htmlContent);
        
        for (final match in matches) {
          final url = match.group(0);
          if (url != null && !posts.any((p) => p['url'] == url)) {
            // X URLから投稿情報を構築
            final username = _extractUsername(url);
            final statusId = _extractStatusId(url);
            
            posts.add({
              'id': 'real_$statusId',
              'platform': 'X',
              'authorUsername': username,
              'content': '$keywordに関する投稿',
              'url': url,
              'postedAt': DateTime.now().toIso8601String(),
              'storeName': null,
              'location': null,
              'price': null,
              'verified': false,
              'imageUrl': null,
            });
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('検索エラー ($keyword): $e');
      }
    }
    
    return posts;
  }
  
  /// X URLからユーザー名を抽出
  String _extractUsername(String url) {
    final pattern = RegExp(r'(?:twitter\.com|x\.com)/([^/]+)/status/');
    final match = pattern.firstMatch(url);
    return match != null ? '@${match.group(1)}' : '@unknown';
  }
  
  /// X URLからステータスIDを抽出
  String _extractStatusId(String url) {
    final pattern = RegExp(r'/status/(\d+)');
    final match = pattern.firstMatch(url);
    return match?.group(1) ?? 'unknown';
  }
  
  /// Google検索を使用してX投稿を検索（補助的な方法）
  Future<List<Map<String, dynamic>>> searchViaGoogle(String keyword) async {
    final List<Map<String, dynamic>> posts = [];
    
    try {
      // Google検索でX投稿を検索
      final googleSearchUrl = Uri.parse(
        'https://www.google.com/search?q=site:x.com+OR+site:twitter.com+${Uri.encodeComponent(keyword)}'
      );
      
      final response = await http.get(
        googleSearchUrl,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final htmlContent = response.body;
        
        // X URLを抽出
        final xUrlPattern = RegExp(r'https://(?:twitter\.com|x\.com)/[^/]+/status/\d+');
        final matches = xUrlPattern.allMatches(htmlContent);
        
        for (final match in matches.take(5)) {
          final url = match.group(0);
          if (url != null) {
            final username = _extractUsername(url);
            final statusId = _extractStatusId(url);
            
            posts.add({
              'id': 'google_$statusId',
              'platform': 'X',
              'authorUsername': username,
              'content': '$keywordに関する投稿（Google検索）',
              'url': url,
              'postedAt': DateTime.now().toIso8601String(),
              'storeName': null,
              'location': null,
              'price': null,
              'verified': false,
              'imageUrl': null,
            });
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Google検索エラー: $e');
      }
    }
    
    return posts;
  }
  
  /// 地域別検索キーワードを生成
  List<String> _getRegionalKeywords() {
    const cities = [
      '大阪',
      '梅田',
      '難波',
      '天王寺',
      '神戸',
      '三宮',
      '西宮',
      '尼崎',
      '姫路',
    ];
    
    final regionalKeywords = <String>[];
    for (final city in cities) {
      regionalKeywords.add('ボンボンドロップ $city');
    }
    
    // 府県名も追加
    regionalKeywords.add('ボンボンドロップ 大阪府');
    regionalKeywords.add('ボンボンドロップ 兵庫県');
    
    return regionalKeywords;
  }
}
