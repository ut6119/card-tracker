import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/sns_post.dart';
import '../services/sns_sample_data_service.dart';
import '../services/realtime_sns_service.dart';
import '../services/location_settings_service.dart';

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
  String _selectedRegion = '全国';

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _loadSnsPosts();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 画面が表示されるたびに地域設定をリロード
    _loadLocation();
  }
  
  /// 現在地設定を読み込み
  Future<void> _loadLocation() async {
    final region = await LocationSettingsService.getLocation();
    if (mounted) {
      setState(() {
        _selectedRegion = region;
      });
    }
  }
  
  /// 現在地設定ダイアログを表示
  Future<void> _showLocationDialog() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('現在地を設定'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: LocationSettingsService.regions.length,
            itemBuilder: (context, index) {
              final region = LocationSettingsService.regions[index];
              return ListTile(
                title: Text(region),
                trailing: _selectedRegion == region
                    ? const Icon(Icons.check, color: Colors.black)
                    : null,
                onTap: () => Navigator.pop(context, region),
              );
            },
          ),
        ),
      ),
    );
    
    if (selected != null) {
      await LocationSettingsService.saveLocation(selected);
      setState(() {
        _selectedRegion = selected;
      });
      // 地域変更後に投稿を再取得
      await _loadSnsPosts();
    }
  }

  /// SNS投稿データを読み込み
  Future<void> _loadSnsPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // リアルタイムでX投稿を取得（地域を指定）
      final realtimeService = RealtimeSnsService();
      final realtimePosts = await realtimeService.searchSealPosts(region: _selectedRegion);
      
      // リアルタイム投稿をSnsPost形式に変換
      final posts = realtimePosts.map((json) {
        return SnsPost(
          id: json['id'] as String,
          type: SnsType.twitter,
          productId: json['id'] as String,
          username: json['authorUsername'] as String,
          content: json['content'] as String,
          imageUrl: json['imageUrl'] as String?,
          postUrl: json['url'] as String,
          postedAt: DateTime.parse(json['postedAt'] as String),
          storeName: json['storeName'] as String?,
          location: json['location'] as String?,
          price: (json['price'] as num?)?.toDouble(),
          isVerified: json['verified'] as bool? ?? false,
        );
      }).toList();
      
      // サンプルデータも追加（実際の投稿が見つからない場合のバックアップ）
      final sampleData = SnsSampleDataService.getSampleSnsPosts();
      final samplePosts = sampleData.map((json) => SnsPost.fromJson(json)).toList();
      
      // リアルタイム投稿を優先、サンプルデータを追加
      final allPosts = [...posts, ...samplePosts];
      
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
      }
    } catch (e) {
      // エラー時はサンプルデータのみを使用
      final jsonData = SnsSampleDataService.getSampleSnsPosts();
      final posts = jsonData.map((json) => SnsPost.fromJson(json)).toList();
      posts.sort((a, b) => b.postedAt.compareTo(a.postedAt));

      setState(() {
        _snsPosts = posts;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('最新情報の取得に失敗しました。サンプルデータを表示します。'),
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
    
    // SNSタイプでフィルタ
    if (_selectedSnsType != null) {
      posts = posts.where((post) => post.type == _selectedSnsType).toList();
    }
    
    // 地域でフィルタ
    posts = posts.where((post) {
      return LocationSettingsService.isLocationMatch(
        post.location,
        post.storeName,
        _selectedRegion,
      );
    }).toList();
    
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SNS情報'),
        actions: [
          // 現在地設定ボタン
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _showLocationDialog,
            tooltip: '現在地設定: $_selectedRegion',
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
                  '表示地域: $_selectedRegion',
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
