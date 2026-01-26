import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/sns_post.dart';
import '../services/sns_sample_data_service.dart';
import '../services/free_data_service.dart';

/// SNS画面
/// X、Instagram、LINEなどのSNS情報を表示
class SnsScreen extends StatefulWidget {
  const SnsScreen({super.key});

  @override
  State<SnsScreen> createState() => _SnsScreenState();
}

class _SnsScreenState extends State<SnsScreen> {
  SnsType? _selectedSnsType;
  List<SnsPost> _snsPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSnsPosts();
  }

  /// SNS投稿データを読み込み
  Future<void> _loadSnsPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 無料データサービスから実データを取得
      final freeDataService = FreeDataService();
      final snsData = await freeDataService.fetchAllSNSPosts();
      
      // SnsPost形式に変換
      final posts = snsData.map((json) {
        return SnsPost(
          id: json['id'] as String,
          type: json['platform'] == 'X' ? SnsType.twitter : SnsType.instagram,
          productId: json['id'] as String, // IDをproductIdとして使用
          username: json['authorUsername'] as String,
          content: json['content'] as String,
          imageUrl: json['imageUrl'] as String? ?? '',
          postUrl: json['url'] as String,
          postedAt: DateTime.parse(json['postedAt'] as String),
          storeName: json['storeName'] as String? ?? '',
          location: json['location'] as String? ?? '',
          price: (json['price'] as num?)?.toDouble(),
          isVerified: json['verified'] as bool? ?? false,
        );
      }).toList();

      // 投稿日時順にソート（新しい順）
      posts.sort((a, b) => b.postedAt.compareTo(a.postedAt));

      setState(() {
        _snsPosts = posts;
        _isLoading = false;
      });
    } catch (e) {
      // エラー時はサンプルデータを使用
      final jsonData = SnsSampleDataService.getSampleSnsPosts();
      final posts = jsonData.map((json) => SnsPost.fromJson(json)).toList();
      posts.sort((a, b) => b.postedAt.compareTo(a.postedAt));

      setState(() {
        _snsPosts = posts;
        _isLoading = false;
      });
    }
  }

  /// フィルター済みの投稿を取得
  List<SnsPost> get _filteredPosts {
    if (_selectedSnsType == null) {
      return _snsPosts;
    }
    return _snsPosts.where((post) => post.type == _selectedSnsType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SNS情報'),
      ),
      body: Column(
        children: [
          // SNSタイプフィルター
          _buildSnsTypeFilter(),
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

  /// SNSタイプフィルター
  Widget _buildSnsTypeFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('すべて', null),
          _buildFilterChip('X', SnsType.twitter),
          _buildFilterChip('Instagram', SnsType.instagram),
          _buildFilterChip('LINE', SnsType.line),
        ],
      ),
    );
  }

  /// フィルターチップ
  Widget _buildFilterChip(String label, SnsType? type) {
    final isSelected = _selectedSnsType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSnsType = selected ? type : null;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.black,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
        ),
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
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
