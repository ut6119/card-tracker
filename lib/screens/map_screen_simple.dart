import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../services/location_service.dart';
import '../models/card_product.dart';
import 'product_detail_screen.dart';

/// マップ画面（シンプル版）
/// 店舗位置情報をリスト形式で表示
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Map<String, dynamic>? _userLocation;
  bool _isLoadingLocation = false;
  List<_StoreInfo> _storeList = [];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _loadStoreList();
  }

  /// 保存されたユーザー位置を読み込み
  Future<void> _loadUserLocation() async {
    final location = await LocationService.getSavedLocation();
    if (location != null && mounted) {
      setState(() {
        _userLocation = location;
      });
      _loadStoreList(); // 位置情報更新後、店舗リストを再計算
    }
  }

  /// 店舗リストを読み込み
  void _loadStoreList() {
    final provider = context.read<ProductProvider>();
    final stores = <_StoreInfo>[];

    // 店舗情報を収集
    for (var product in provider.allProducts) {
      for (var price in product.prices) {
        if (price.location != null) {
          final coords = LocationService.getStoreCoordinates(price.location!);
          
          double? distance;
          if (_userLocation != null && coords != null) {
            distance = LocationService.calculateDistance(
              lat1: _userLocation!['latitude'] as double,
              lng1: _userLocation!['longitude'] as double,
              lat2: coords['latitude']!,
              lng2: coords['longitude']!,
            );
          }

          stores.add(_StoreInfo(
            product: product,
            price: price,
            location: price.location!,
            coords: coords,
            distance: distance,
          ));
        }
      }
    }

    // 距離順にソート
    if (_userLocation != null) {
      stores.sort((a, b) {
        if (a.distance == null) return 1;
        if (b.distance == null) return -1;
        return a.distance!.compareTo(b.distance!);
      });
    }

    setState(() {
      _storeList = stores;
    });
  }

  /// 現在地を取得
  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null && mounted) {
        await LocationService.saveLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          name: '現在地',
        );
        await _loadUserLocation();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ 現在地を取得しました'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ 位置情報の取得に失敗しました: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('店舗マップ'),
        actions: [
          IconButton(
            icon: _isLoadingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.my_location),
            onPressed: _isLoadingLocation ? null : _fetchCurrentLocation,
            tooltip: '現在地を取得',
          ),
        ],
      ),
      body: Column(
        children: [
          // 現在地表示
          if (_userLocation != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '現在地: ${_userLocation!['name'] ?? '設定済み'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // 店舗リスト
          Expanded(
            child: _storeList.isEmpty
                ? const Center(
                    child: Text(
                      '店舗情報がありません',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _storeList.length,
                    itemBuilder: (context, index) {
                      final store = _storeList[index];
                      return _StoreListTile(
                        store: store,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                product: store.product,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// 店舗情報
class _StoreInfo {
  final CardProduct product;
  final dynamic price;
  final String location;
  final Map<String, double>? coords;
  final double? distance;

  _StoreInfo({
    required this.product,
    required this.price,
    required this.location,
    this.coords,
    this.distance,
  });
}

/// 店舗リストタイル
class _StoreListTile extends StatelessWidget {
  final _StoreInfo store;
  final VoidCallback onTap;

  const _StoreListTile({
    required this.store,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 店舗名と距離
              Row(
                children: [
                  Expanded(
                    child: Text(
                      store.price.storeName ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (store.distance != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${store.distance!.toStringAsFixed(1)}km',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // 所在地
              Row(
                children: [
                  const Icon(Icons.place, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      store.location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 商品名と価格
              Row(
                children: [
                  Expanded(
                    child: Text(
                      store.product.name,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '¥${store.price.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 在庫状況
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: store.price.inStock ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  store.price.inStock ? '在庫あり' : '在庫なし',
                  style: TextStyle(
                    fontSize: 12,
                    color: store.price.inStock ? Colors.green[900] : Colors.red[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
