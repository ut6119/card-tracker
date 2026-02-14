import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'screens/sns_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ProviderでProductProviderを全画面で利用可能にする
    return ChangeNotifierProvider(
      create: (context) => ProductProvider()..initialize(),
      child: MaterialApp(
        title: 'シールトラッカー',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // ミニマルデザインに合わせたテーマ設定
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          // AppBarのテーマ
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
          // ボトムナビゲーションバーのテーマ
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

/// メイン画面（ボトムナビゲーション付き）
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 各タブの画面
  final List<Widget> _screens = const [
    SnsScreen(key: ValueKey('gacha'), title: 'ガチャガチャ', isGacha: true),
    SnsScreen(key: ValueKey('bonbon'), title: 'ボンボンドロップ', isGacha: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'ガチャガチャ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'ボンボンドロップ',
          ),
        ],
      ),
    );
  }
}
