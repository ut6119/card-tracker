import 'package:flutter/material.dart';
import '../services/location_service.dart';

/// プロフィール画面
/// アプリ情報と設定を表示
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _savedLocation;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  /// 保存された位置情報を読み込み
  Future<void> _loadSavedLocation() async {
    final location = await LocationService.getSavedLocation();
    if (mounted) {
      setState(() {
        _savedLocation = location;
      });
    }
  }

  /// 現在地を設定
  Future<void> _setCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    final position = await LocationService.getCurrentPosition();

    if (position != null) {
      await LocationService.saveLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        name: '現在地',
      );

      await _loadSavedLocation();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('現在地を設定しました'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('位置情報の取得に失敗しました'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isLoadingLocation = false;
    });
  }

  /// 現在地設定をクリア
  Future<void> _clearLocation() async {
    await LocationService.clearLocation();
    await _loadSavedLocation();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('現在地設定を解除しました'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('プロフィール'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          
          // アプリアイコンとタイトル
          const Column(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: Colors.black,
              ),
              SizedBox(height: 16),
              Text(
                'Card Tracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'シール・トレーディングカード価格比較',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          const Divider(height: 1),
          
          // メニューリスト
          _MenuItem(
            icon: Icons.info_outline,
            title: 'アプリについて',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          
          _MenuItem(
            icon: Icons.description_outlined,
            title: '使い方ガイド',
            onTap: () {
              _showGuideDialog(context);
            },
          ),
          
          _MenuItem(
            icon: Icons.help_outline,
            title: 'ヘルプ・FAQ',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('準備中です')),
              );
            },
          ),
          
          const Divider(height: 1),
          
          // 現在地設定
          _LocationMenuItem(
            savedLocation: _savedLocation,
            isLoading: _isLoadingLocation,
            onSetLocation: _setCurrentLocation,
            onClearLocation: _clearLocation,
          ),
          
          const Divider(height: 1),
          
          _MenuItem(
            icon: Icons.settings_outlined,
            title: '設定',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('準備中です')),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // バージョン情報
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  /// アプリについてダイアログ
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Card Trackerについて'),
        content: const SingleChildScrollView(
          child: Text(
            'Card Trackerは、シールやトレーディングカードの販売情報を収集し、価格比較を行うアプリです。\n\n'
            '【主な機能】\n'
            '• 商品の最安値・平均価格の表示\n'
            '• 複数店舗の価格比較\n'
            '• カテゴリー別フィルター\n'
            '• キーワード検索\n'
            '• お気に入り機能\n\n'
            '現在はデモ版として動作しており、サンプルデータを使用しています。',
            style: TextStyle(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '閉じる',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 使い方ガイドダイアログ
  void _showGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('使い方ガイド'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '【ホーム画面】',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• カテゴリーチップで商品をフィルター\n'
                  '• 商品をタップして詳細を表示\n'
                  '• ハートアイコンでお気に入り登録'),
              SizedBox(height: 16),
              
              Text(
                '【検索画面】',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 商品名やカテゴリーで検索\n'
                  '• カテゴリーチップで絞り込み'),
              SizedBox(height: 16),
              
              Text(
                '【お気に入り画面】',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• お気に入り登録した商品を一覧表示\n'
                  '• ハートアイコンで登録解除'),
              SizedBox(height: 16),
              
              Text(
                '【商品詳細画面】',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 最安値・平均価格・最高値を表示\n'
                  '• 価格順に店舗情報を比較\n'
                  '• 在庫状況を確認'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '閉じる',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

/// メニューアイテムウィジェット
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

/// 現在地設定メニューアイテム
class _LocationMenuItem extends StatelessWidget {
  final Map<String, dynamic>? savedLocation;
  final bool isLoading;
  final VoidCallback onSetLocation;
  final VoidCallback onClearLocation;

  const _LocationMenuItem({
    required this.savedLocation,
    required this.isLoading,
    required this.onSetLocation,
    required this.onClearLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on_outlined, color: Colors.black),
      title: const Text('現在地設定'),
      subtitle: savedLocation != null
          ? Text(
              savedLocation!['name'] as String,
              style: const TextStyle(fontSize: 12),
            )
          : const Text(
              '未設定',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
      trailing: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              savedLocation != null ? Icons.edit : Icons.add_location,
              color: Colors.grey,
            ),
      onTap: () {
        if (savedLocation != null) {
          _showLocationOptions(context);
        } else {
          onSetLocation();
        }
      },
    );
  }

  /// 現在地設定オプションを表示
  void _showLocationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text('現在地を再取得'),
              onTap: () {
                Navigator.pop(context);
                onSetLocation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('現在地設定を解除'),
              onTap: () {
                Navigator.pop(context);
                onClearLocation();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
