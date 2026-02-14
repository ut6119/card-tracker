import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// リモートの最新データ取得サービス
/// GitHub上のJSONを取得してアプリに反映
class RemoteDataService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/ut6119/card-tracker/main/data';

  Uri _buildUri(String filename) {
    final cacheBust = DateTime.now().millisecondsSinceEpoch;
    return Uri.parse('$_baseUrl/$filename?t=$cacheBust');
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    return _fetchJsonList('products.json');
  }

  Future<List<Map<String, dynamic>>> fetchSnsPosts() async {
    return _fetchJsonList('sns.json');
  }

  Future<List<Map<String, dynamic>>> _fetchJsonList(String filename) async {
    try {
      final uri = _buildUri(filename);
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        if (kDebugMode) {
          debugPrint('リモート取得失敗: $filename (${response.statusCode})');
        }
        return [];
      }

      final decoded = json.decode(response.body);
      if (decoded is! List) {
        if (kDebugMode) {
          debugPrint('JSON形式が不正: $filename');
        }
        return [];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('リモート取得エラー: $filename ($e)');
      }
      return [];
    }
  }
}
