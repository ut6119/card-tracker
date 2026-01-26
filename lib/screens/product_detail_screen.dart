import 'package:flutter/material.dart';
import '../models/card_product.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// 商品詳細画面
/// 商品情報と価格比較テーブルを表示
class ProductDetailScreen extends StatelessWidget {
  final CardProduct product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('商品詳細'),
        actions: [
          // お気に入りボタン
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              final isFavorite = provider.isFavorite(product.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_outline,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  provider.toggleFavorite(product.id);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 商品画像
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey.shade100,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 商品情報セクション
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // カテゴリー
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // 商品名
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 商品説明
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 価格情報サマリー
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _PriceSummaryItem(
                          label: '最安値',
                          price: product.lowestPrice,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey.shade300,
                        ),
                        _PriceSummaryItem(
                          label: '平均価格',
                          price: product.averagePrice,
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.grey.shade300,
                        ),
                        _PriceSummaryItem(
                          label: '最高値',
                          price: product.highestPrice,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 価格比較テーブル見出し
                  const Text(
                    '価格比較',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            
            // 価格比較テーブル
            _PriceComparisonTable(product: product),
            
            const SizedBox(height: 16),
            
            // メルカリ検索ボタン
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MercariSearchButton(product: product),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// メルカリ検索ボタン
class _MercariSearchButton extends StatelessWidget {
  final CardProduct product;

  const _MercariSearchButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300, width: 2),
        color: Colors.red.shade50,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _searchOnMercari(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.red.shade700,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'メルカリで検索',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.open_in_new,
                  color: Colors.red.shade700,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// メルカリで商品を検索
  Future<void> _searchOnMercari() async {
    // 商品名からメルカリ検索URLを生成
    final searchKeyword = Uri.encodeComponent(product.name);
    final mercariUrl = 'https://jp.mercari.com/search?keyword=$searchKeyword';
    
    final uri = Uri.parse(mercariUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// 価格サマリーアイテム
class _PriceSummaryItem extends StatelessWidget {
  final String label;
  final double price;

  const _PriceSummaryItem({
    required this.label,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '¥${price.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// 価格比較テーブル
class _PriceComparisonTable extends StatelessWidget {
  final CardProduct product;

  const _PriceComparisonTable({required this.product});

  @override
  Widget build(BuildContext context) {
    // 価格順にソート
    final sortedPrices = List<PriceInfo>.from(product.prices)
      ..sort((a, b) => a.price.compareTo(b.price));
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedPrices.length,
      itemBuilder: (context, index) {
        final priceInfo = sortedPrices[index];
        final isLowestPrice = index == 0;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isLowestPrice ? Colors.black : Colors.white,
            border: Border.all(
              color: isLowestPrice ? Colors.black : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // 店舗情報
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                priceInfo.storeName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isLowestPrice ? Colors.white : Colors.black,
                                ),
                              ),
                              if (isLowestPrice) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '最安',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (priceInfo.location != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 12,
                                  color: isLowestPrice
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  priceInfo.location!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isLowestPrice
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    
                    // 価格と在庫状況
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '¥${priceInfo.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isLowestPrice ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: priceInfo.inStock
                                ? (isLowestPrice ? Colors.white : Colors.green.shade50)
                                : (isLowestPrice ? Colors.white24 : Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            priceInfo.inStock ? '在庫あり' : '在庫なし',
                            style: TextStyle(
                              fontSize: 10,
                              color: priceInfo.inStock
                                  ? (isLowestPrice ? Colors.green : Colors.green.shade700)
                                  : (isLowestPrice ? Colors.white70 : Colors.grey.shade600),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // サイトリンクボタン
              if (priceInfo.url != null && priceInfo.url!.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isLowestPrice 
                            ? Colors.white24 
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        final url = Uri.parse(priceInfo.url!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.open_in_new,
                              size: 16,
                              color: isLowestPrice ? Colors.white : Colors.blue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '公式サイトで見る',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isLowestPrice ? Colors.white : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
