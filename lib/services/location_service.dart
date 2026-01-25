import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// 位置情報管理サービス
/// 現在地の取得と保存を管理
class LocationService {
  static const String _latKey = 'user_latitude';
  static const String _lngKey = 'user_longitude';
  static const String _locationNameKey = 'user_location_name';
  
  /// 現在地を取得（デバイスGPSから）
  static Future<Position?> getCurrentPosition() async {
    try {
      // 位置情報サービスが有効かチェック
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          debugPrint('位置情報サービスが無効です');
        }
        return null;
      }

      // 位置情報のパーミッションをチェック
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            debugPrint('位置情報のパーミッションが拒否されました');
          }
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          debugPrint('位置情報のパーミッションが永久に拒否されました');
        }
        return null;
      }

      // 現在地を取得
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('現在地取得エラー: $e');
      }
      return null;
    }
  }
  
  /// 保存された位置情報を取得
  static Future<Map<String, dynamic>?> getSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble(_latKey);
      final lng = prefs.getDouble(_lngKey);
      final name = prefs.getString(_locationNameKey);
      
      if (lat != null && lng != null) {
        return {
          'latitude': lat,
          'longitude': lng,
          'name': name ?? '保存された位置',
        };
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('位置情報読み込みエラー: $e');
      }
      return null;
    }
  }
  
  /// 位置情報を保存
  static Future<bool> saveLocation({
    required double latitude,
    required double longitude,
    String? name,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_latKey, latitude);
      await prefs.setDouble(_lngKey, longitude);
      if (name != null) {
        await prefs.setString(_locationNameKey, name);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('位置情報保存エラー: $e');
      }
      return false;
    }
  }
  
  /// 保存された位置情報をクリア
  static Future<bool> clearLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_latKey);
      await prefs.remove(_lngKey);
      await prefs.remove(_locationNameKey);
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('位置情報削除エラー: $e');
      }
      return false;
    }
  }
  
  /// 2点間の距離を計算（単位: km）
  static double calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
  }
  
  /// 店舗の座標を取得（住所から推定）
  static Map<String, double>? getStoreCoordinates(String location) {
    // 実際の実装では住所→座標変換APIを使用
    // ここではサンプルとして主要都市の座標を返す
    final Map<String, Map<String, double>> cityCoordinates = {
      '東京都渋谷区': {'latitude': 35.6595, 'longitude': 139.7004},
      '大阪府大阪市': {'latitude': 34.6937, 'longitude': 135.5023},
      '大阪府堺市': {'latitude': 34.5733, 'longitude': 135.4830},
      '神奈川県横浜市': {'latitude': 35.4437, 'longitude': 139.6380},
      '愛知県名古屋市': {'latitude': 35.1815, 'longitude': 136.9066},
      '福岡県福岡市': {'latitude': 33.5904, 'longitude': 130.4017},
      '北海道札幌市': {'latitude': 43.0642, 'longitude': 141.3469},
    };
    
    for (var entry in cityCoordinates.entries) {
      if (location.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return null;
  }
}
