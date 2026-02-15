import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/sns_post.dart';
import '../services/remote_data_service.dart';
import '../services/keyword_settings_service.dart';

/// SNS画面
/// X・Instagram・Web情報を表示（大阪・兵庫のみ）
class SnsScreen extends StatefulWidget {
  final String title;
  final bool isGacha;

  const SnsScreen({
    super.key,
    required this.title,
    required this.isGacha,
  });

  @override
  State<SnsScreen> createState() => _SnsScreenState();
}

class _SnsScreenState extends State<SnsScreen> {
  List<SnsPost> _snsPosts = [];
  bool _isLoading = true;
  static const String _fixedRegionLabel = '大阪・兵庫';
  static const List<String> _prefectureKeywords = ['大阪', '大阪府', '兵庫', '兵庫県', '神戸', '姫路', '尼崎', '西宮', '芦屋', '明石', '宝塚'];
  List<String> _keywordFilters = [];
  List<String> _excludeKeywordFilters = [];

  @override
  void initState() {
    super.initState();
    _loadKeywords();
    _loadSnsPosts();
  }

  Future<void> _loadKeywords() async {
    final keywords = widget.isGacha
        ? await KeywordSettingsService.loadGachaKeywords()
        : await KeywordSettingsService.loadBonbonKeywords();
    final excludeKeywords = widget.isGacha
        ? await KeywordSettingsService.loadGachaExcludeKeywords()
        : await KeywordSettingsService.loadBonbonExcludeKeywords();
    if (mounted) {
      setState(() {
        _keywordFilters = keywords;
        _excludeKeywordFilters = excludeKeywords;
      });
    }
  }

  /// SNS投稿データを読み込み
  Future<void> _loadSnsPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final remoteService = RemoteDataService();
      final remoteJson = widget.isGacha
          ? await remoteService.fetchGachaPosts()
          : await remoteService.fetchBonbonPosts();
      List<SnsPost> posts = remoteJson.map((json) => SnsPost.fromJson(json)).toList();

      // リアルタイム投稿を優先、取得できなければ空
      final allPosts = posts;
      
      // 投稿日時順にソート（新しい順）
      allPosts.sort((a, b) => b.postedAt.compareTo(a.postedAt));

      setState(() {
        _snsPosts = allPosts;
        _isLoading = false;
      });
      
      // 成功メッセージ
      if (mounted && posts.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${posts.length}件の最新投稿を取得しました'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted && posts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('最新情報が取得できませんでした'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _snsPosts = [];
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('最新情報の取得に失敗しました'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  /// フィルター済みの投稿を取得
  List<SnsPost> get _filteredPosts {
    var posts = _snsPosts;

    // 地域でフィルタ
    posts = posts.where((post) {
      final target = _normalize('${post.location ?? ''} ${post.storeName ?? ''} ${post.content}');
      return _prefectureKeywords.any((keyword) => target.contains(_normalize(keyword)));
    }).toList();

    // キーワードフィルタ（設定がある場合）
    if (_keywordFilters.isNotEmpty) {
      posts = posts.where((post) {
        final target = _normalize(_buildTarget(post));
        return _keywordFilters.any((keyword) => target.contains(_normalize(keyword)));
      }).toList();
    }

    // 除外キーワード
    if (_excludeKeywordFilters.isNotEmpty) {
      posts = posts.where((post) {
        final target = _normalize(_buildTarget(post));
        return !_excludeKeywordFilters.any((keyword) => target.contains(_normalize(keyword)));
      }).toList();
    }
    
    return posts;
  }

  Future<void> _showKeywordDialog() async {
    await _loadKeywords();
    final includeController = TextEditingController(
      text: _keywordFilters.join('\n'),
    );
    final excludeController = TextEditingController(
      text: _excludeKeywordFilters.join('\n'),
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.isGacha ? 'ガチャワード設定' : 'ボンボンドロップ設定'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: includeController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: '含めるワード',
                  hintText: '1行に1ワードで入力',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: excludeController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '除外ワード',
                  hintText: '1行に1ワードで入力',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'ok'),
            child: const Text('保存'),
          ),
        ],
      ),
    );

    if (result == null) {
      return;
    }

    final keywords = includeController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final excludeKeywords = excludeController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    if (widget.isGacha) {
      await KeywordSettingsService.saveGachaKeywords(keywords);
      await KeywordSettingsService.saveGachaExcludeKeywords(excludeKeywords);
    } else {
      await KeywordSettingsService.saveBonbonKeywords(keywords);
      await KeywordSettingsService.saveBonbonExcludeKeywords(excludeKeywords);
    }

    if (mounted) {
      setState(() {
        _keywordFilters = keywords;
        _excludeKeywordFilters = excludeKeywords;
      });
    }
  }

  String _buildTarget(SnsPost post) {
    return [
      post.content,
      post.storeName ?? '',
      post.location ?? '',
      post.username,
      post.postUrl,
      post.productId,
    ].join(' ');
  }

  String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showKeywordDialog,
            tooltip: 'ワード設定',
          ),
          // 更新ボタン
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadSnsPosts,
            tooltip: '最新情報を取得',
          ),
        ],
      ),
      body: Column(
        children: [
          // 現在地表示
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '表示地域: $_fixedRegionLabel',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  '${_filteredPosts.length}件',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 投稿リスト
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  )
                : _filteredPosts.isEmpty
                    ? const Center(
                        child: Text(
                          '投稿が見つかりませんでした',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredPosts.length,
                        itemBuilder: (context, index) {
                          return _SnsPostCard(post: _filteredPosts[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

}

/// SNS投稿カード
class _SnsPostCard extends StatelessWidget {
  final SnsPost post;

  const _SnsPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () => _openUrl(post.postUrl),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー（SNSアイコン、ユーザー名、投稿日時）
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(post.type.iconColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.tag,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            if (post.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                size: 14,
                                color: Colors.blue,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          _formatTimestamp(post.postedAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(post.type.iconColor).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      post.type.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(post.type.iconColor),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 投稿内容
              Text(
                post.content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              if (post.imageUrl != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ],

              // 店舗情報・価格情報
              if (post.storeName != null ||
                  post.location != null ||
                  post.price != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post.storeName != null)
                              Text(
                                post.storeName!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (post.location != null)
                              Text(
                                post.location!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (post.price != null)
                        Text(
                          '¥${post.price!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// タイムスタンプをフォーマット
  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }

  /// URLを開く
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // Web版: 新しいタブで開く
      // モバイル版: 外部ブラウザで開く
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank', // Webで新しいタブを開く
      );
    }
  }
}
