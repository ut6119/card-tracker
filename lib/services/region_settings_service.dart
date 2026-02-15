import 'package:shared_preferences/shared_preferences.dart';

class RegionSettingsService {
  static const String _regionKey = 'sns_region';

  static const List<String> regions = [
    '北大阪',
    '南大阪',
    '兵庫',
  ];

  static const Map<String, List<String>> regionKeywords = {
    '北大阪': [
      '大阪',
      '大阪府',
      '梅田',
      '北区',
      '新大阪',
      '吹田',
      '豊中',
      '茨木',
      '高槻',
      '箕面',
      '池田',
      '摂津',
      '守口',
      '門真',
    ],
    '南大阪': [
      '大阪',
      '大阪府',
      '難波',
      'なんば',
      '天王寺',
      '阿倍野',
      '堺',
      '岸和田',
      '泉佐野',
      '泉南',
      '貝塚',
      '八尾',
      '東大阪',
      '住吉',
      '住之江',
      '河内',
      '松原',
      '藤井寺',
      '富田林',
    ],
    '兵庫': [
      '兵庫',
      '兵庫県',
      '神戸',
      '三宮',
      '姫路',
      '尼崎',
      '西宮',
      '芦屋',
      '明石',
      '宝塚',
      '垂水',
      '加古川',
    ],
  };

  static Future<String> loadRegion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_regionKey) ?? regions.first;
  }

  static Future<void> saveRegion(String region) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_regionKey, region);
  }
}
