import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/card_product.dart';
import 'product_detail_screen.dart';

/// ホーム画面
/// 商品一覧とカテゴリーフィルターを表示
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'シールトラッカー',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          return Column(
            children: [
              // カテゴリーフィルター
              _CategoryFilter(),
              
              const Divider(height: 1),
              
              // 実データ取得ボタン
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[100],
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: provider.isLoading ? null : () async {
                        try {
                          // 楽天APIから実データを取得
                          await provider.fetchAllRealData();
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('✅ ${provider.filteredProducts.length}件のデータを取得しました！（サンリオ・たまごっち公式）'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ データ取得に失敗しました'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      icon: provider.isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(
                        provider.isLoading ? '取得中...' : '🔄 サンリオ・たまごっち公式から取得',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '※ サンリオ・たまごっち公式サイトから商品情報を取得します',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // 商品リスト
              Expanded(
                child: provider.filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          '商品が見つかりませんでした',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: provider.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = provider.filteredProducts[index];
                          return _ProductListItem(product: product);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// カテゴリーフィルターウィジェット
class _CategoryFilter extends StatelessWidget {
  final List<String> categories = const [
    'すべて',
    'ボンボンドロップ',
    'キラキラシール',
    'アニメシール',
    'レトロシール',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = provider.selectedCategory == category;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      provider.setCategory(category);
                    }
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
            },
          ),
        );
      },
    );
  }
}

/// 商品リストアイテム
class _ProductListItem extends StatelessWidget {
  final CardProduct product;

  const _ProductListItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final isFavorite = provider.isFavorite(product.id);
        
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 商品画像
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // 商品情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // カテゴリー
                      Text(
                        product.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // 商品名
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      // 価格情報
                      Row(
                        children: [
                          Text(
                            '¥${product.lowestPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '〜',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      
                      // 店舗数
                      Text(
                        '${product.prices.length}店舗',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // お気に入りボタン
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    provider.toggleFavorite(product.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
