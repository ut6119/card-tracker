import 'package:shared_preferences/shared_preferences.dart';

/// 現在地設定サービス
class LocationSettingsService {
  static const String _locationKey = 'user_location';
  
  /// 地域リスト
  static const List<String> regions = [
    '全国',
    '北海道',
    '東北',
    '関東',
    '中部',
    '近畿',
    '中国',
    '四国',
    '九州・沖縄',
  ];
  
  /// 地域と都道府県のマッピング
  static const Map<String, List<String>> regionPrefectures = {
    '全国': [],
    '北海道': ['北海道'],
    '東北': ['青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県'],
    '関東': ['茨城県', '栃木県', '群馬県', '埼玉県', '千葉県', '東京都', '神奈川県'],
    '中部': ['新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県', '岐阜県', '静岡県', '愛知県'],
    '近畿': ['三重県', '滋賀県', '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県'],
    '中国': ['鳥取県', '島根県', '岡山県', '広島県', '山口県'],
    '四国': ['徳島県', '香川県', '愛媛県', '高知県'],
    '九州・沖縄': ['福岡県', '佐賀県', '長崎県', '熊本県', '大分県', '宮崎県', '鹿児島県', '沖縄県'],
  };
  
  /// 全国共通のキーワード（地域フィルタ対象外）
  static const List<String> nationalKeywords = [
    '全店',
    '全国',
    '公式',
    'オンライン',
    '通販',
    'ネット',
    'Amazon',
    '楽天',
    'Yahoo',
    'メルカリ',
  ];
  
  /// 現在地設定を保存
  static Future<void> saveLocation(String region) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, region);
  }
  
  /// 現在地設定を取得
  static Future<String> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_locationKey) ?? '全国';
  }
  
  /// 現在地設定をクリア
  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_locationKey);
  }
  
  /// 投稿が現在地にマッチするかチェック
  static bool isLocationMatch(String? postLocation, String? storeName, String userRegion) {
    // 全国設定の場合はすべて表示
    if (userRegion == '全国') {
      return true;
    }
    
    // 全国共通キーワードを含む場合は表示
    if (storeName != null) {
      for (final keyword in nationalKeywords) {
        if (storeName.contains(keyword)) {
          return true;
        }
      }
    }
    
    if (postLocation != null) {
      for (final keyword in nationalKeywords) {
        if (postLocation.contains(keyword)) {
          return true;
        }
      }
    }
    
    // 投稿位置情報がない場合は表示
    if (postLocation == null || postLocation.isEmpty) {
      return true;
    }
    
    // 地域の都道府県リストを取得
    final prefectures = regionPrefectures[userRegion] ?? [];
    
    // 投稿位置が地域の都道府県に含まれるかチェック
    for (final prefecture in prefectures) {
      if (postLocation.contains(prefecture)) {
        return true;
      }
    }
    
    // 地域名が直接含まれるかチェック
    if (postLocation.contains(userRegion)) {
      return true;
    }
    
    return false;
  }
  
  /// 都道府県から地域を取得
  static String? getRegionFromPrefecture(String location) {
    for (final entry in regionPrefectures.entries) {
      for (final prefecture in entry.value) {
        if (location.contains(prefecture)) {
          return entry.key;
        }
      }
    }
    return null;
  }
}
