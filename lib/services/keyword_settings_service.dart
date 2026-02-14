import 'package:shared_preferences/shared_preferences.dart';

class KeywordSettingsService {
  static const _gachaKey = 'gacha_keywords';
  static const _bonbonKey = 'bonbon_keywords';
  static const _gachaExcludeKey = 'gacha_keywords_exclude';
  static const _bonbonExcludeKey = 'bonbon_keywords_exclude';

  static List<String> _defaults(String key) {
    if (key == _gachaKey) {
      return [
        'ガチャ ズートピア',
        'ガチャ たまごっち',
      ];
    }
    return [
      'ボンボンドロップ',
      'ボンボンドロップ 入荷',
      'ボンボンドロップ 販売',
      'ボンボンドロップ 抽選',
    ];
  }

  static Future<List<String>> loadGachaKeywords() async {
    return _loadKeywords(_gachaKey);
  }

  static Future<List<String>> loadBonbonKeywords() async {
    return _loadKeywords(_bonbonKey);
  }

  static Future<List<String>> loadGachaExcludeKeywords() async {
    return _loadKeywords(_gachaExcludeKey, defaults: const []);
  }

  static Future<List<String>> loadBonbonExcludeKeywords() async {
    return _loadKeywords(_bonbonExcludeKey, defaults: const []);
  }

  static Future<void> saveGachaKeywords(List<String> keywords) async {
    await _saveKeywords(_gachaKey, keywords);
  }

  static Future<void> saveBonbonKeywords(List<String> keywords) async {
    await _saveKeywords(_bonbonKey, keywords);
  }

  static Future<void> saveGachaExcludeKeywords(List<String> keywords) async {
    await _saveKeywords(_gachaExcludeKey, keywords);
  }

  static Future<void> saveBonbonExcludeKeywords(List<String> keywords) async {
    await _saveKeywords(_bonbonExcludeKey, keywords);
  }

  static Future<List<String>> _loadKeywords(String key, {List<String>? defaults}) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(key);
    if (stored == null || stored.isEmpty) {
      if (defaults != null) {
        return defaults;
      }
      return _defaults(key);
    }
    return stored;
  }

  static Future<void> _saveKeywords(String key, List<String> keywords) async {
    final prefs = await SharedPreferences.getInstance();
    final cleaned = keywords
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();
    await prefs.setStringList(key, cleaned);
  }
}
