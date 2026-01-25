import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../services/location_service.dart';
import '../models/card_product.dart';
import 'product_detail_screen.dart';

/// マップ画面
/// 店舗位置と現在地を地図上に表示
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _currentCenter = const LatLng(35.6812, 139.7671); // 東京駅をデフォルト
  Map<String, dynamic>? _userLocation;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    _loadStoreMarkers();
  }

  /// 保存されたユーザー位置を読み込み
  Future<void> _loadUserLocation() async {
    final location = await LocationService.getSavedLocation();
    if (location != null && mounted) {
      setState(() {
        _userLocation = location;
        _currentCenter = LatLng(
          location['latitude'] as double,
          location['longitude'] as double,
        );
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentCenter, 12),
      );
    }
  }

  /// 店舗マーカーを読み込み
  void _loadStoreMarkers() {
    final provider = context.read<ProductProvider>();
    final markers = <Marker>{};

    // ユーザー位置のマーカー
    if (_userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            _userLocation!['latitude'] as double,
            _userLocation!['longitude'] as double,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
          infoWindow: InfoWindow(
            title: '現在地',
            snippet: _userLocation!['name'] as String?,
          ),
        ),
      );
    }

    // 店舗マーカー
    for (var product in provider.allProducts) {
      for (var price in product.prices) {
        if (price.location != null && price.location != 'オンライン') {
          final coords = LocationService.getStoreCoordinates(price.location!);
          if (coords != null) {
            final markerId = MarkerId('${product.id}_${price.storeId}');
            markers.add(
              Marker(
                markerId: markerId,
                position: LatLng(
                  coords['latitude']!,
                  coords['longitude']!,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  price.inStock
                      ? BitmapDescriptor.hueRed
                      : BitmapDescriptor.hueOrange,
                ),
                infoWindow: InfoWindow(
                  title: price.storeName,
                  snippet: '${product.name} - ¥${price.price.toStringAsFixed(0)}',
                  onTap: () {
                    _showStoreDetail(context, product, price);
                  },
                ),
              ),
            );
          }
        }
      }
    }

    setState(() {
      _markers = markers;
    });
  }

  /// 現在地を取得してマップを更新
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    final position = await LocationService.getCurrentPosition();

    if (position != null && mounted) {
      final newLocation = LatLng(position.latitude, position.longitude);

      // 位置情報を保存
      await LocationService.saveLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        name: '現在地',
      );

      setState(() {
        _currentCenter = newLocation;
        _userLocation = {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'name': '現在地',
        };
        _isLoadingLocation = false;
      });

      // マップを現在地に移動
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newLocation, 14),
      );

      // マーカーを再読み込み
      _loadStoreMarkers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('現在地を取得しました'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      setState(() {
        _isLoadingLocation = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('位置情報の取得に失敗しました'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('マップ'),
        actions: [
          if (_isLoadingLocation)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _getCurrentLocation,
              tooltip: '現在地を取得',
            ),
        ],
      ),
      body: Column(
        children: [
          // マップ
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentCenter,
                zoom: 12,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
            ),
          ),

          // 凡例
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                  Icons.location_on,
                  '在庫あり',
                  Colors.red,
                ),
                _buildLegendItem(
                  Icons.location_on,
                  '在庫なし',
                  Colors.orange,
                ),
                _buildLegendItem(
                  Icons.location_on,
                  '現在地',
                  Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 凡例アイテム
  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  /// 店舗詳細を表示
  void _showStoreDetail(
    BuildContext context,
    CardProduct product,
    PriceInfo price,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              price.storeName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price.location ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¥${price.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: price.inStock ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    price.inStock ? '在庫あり' : '在庫なし',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(
                        product: product,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('商品詳細を見る'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
