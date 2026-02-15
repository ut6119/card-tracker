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
      'キタ',
      '梅田',
      '大阪駅',
      '北区',
      '中央区',
      '中之島',
      '新大阪',
      '淀川',
      '東淀川',
      '西淀川',
      '都島',
      '旭区',
      '福島',
      '天満',
      '天満橋',
      '京橋',
      '南森町',
      '江坂',
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
      'ミナミ',
      '天王寺',
      '阿倍野',
      '難波',
      'なんば',
      '心斎橋',
      '日本橋',
      '本町',
      '堺',
      '住吉',
      '住之江',
      '平野',
      '東住吉',
      '西成',
      '浪速',
      '大正',
      '岸和田',
      '泉佐野',
      '泉南',
      '貝塚',
      '八尾',
      '東大阪',
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
