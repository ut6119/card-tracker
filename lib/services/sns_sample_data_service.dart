import '../models/sns_post.dart';

/// SNS情報サンプルデータサービス
class SnsSampleDataService {
  /// サンプルSNS投稿データを取得
  static List<Map<String, dynamic>> getSampleSnsPosts() {
    final now = DateTime.now();
    
    return [
      // ボンボンドロップ関連のSNS投稿（実際のX投稿）
      {
        'id': 'sns_001',
        'type': 'twitter',
        'productId': 'prod_001',
        'username': '@bonbon_drop',
        'content': '🎀 お知らせ 🎀\n\nお待たせしました❣️\nサンリオキャラクターズミニの抽選販売を只今より受付開始✨',
        'imageUrl': 'https://via.placeholder.com/300/FF69B4/FFFFFF?text=Sanrio+BonBon',
        'postUrl': 'https://x.com/bonbon_drop/status/2014895943804448916',
        'postedAt': now.subtract(const Duration(days: 2)).toIso8601String(),
        'storeName': 'ボンボンドロップ公式',
        'location': '公式オンラインストア',
        'price': 550.0,
        'isVerified': true,
      },
      {
        'id': 'sns_002',
        'type': 'twitter',
        'productId': 'prod_001',
        'username': '@bonbon_drop',
        'content': '🎀 お知らせ 🎀\n\nボンボンドロップシール 和柄が再入荷します🌸✨\n\nロフト、ハンズ、ドンキホーテなどで順次販売予定です',
        'imageUrl': 'https://via.placeholder.com/300/FFD700/FFFFFF?text=Japanese+Pattern',
        'postUrl': 'https://x.com/bonbon_drop/status/2012359222076248423',
        'postedAt': now.subtract(const Duration(days: 7)).toIso8601String(),
        'storeName': 'ロフト・ハンズ・ドンキホーテ',
        'location': '全国各店',
        'price': 550.0,
        'isVerified': true,
      },
      {
        'id': 'sns_003',
        'type': 'twitter',
        'productId': 'prod_001',
        'username': '@KL_shinjuku',
        'content': '【ボンボンドロップシール販売について】\n\n次回入荷予定あり。購入整理券をLivePocketによる事前抽選にて配布いたします。',
        'imageUrl': null,
        'postUrl': 'https://x.com/KL_shinjuku/status/2012374337530265974',
        'postedAt': now.subtract(const Duration(days: 7)).toIso8601String(),
        'storeName': 'キデイランド新宿店',
        'location': '東京都新宿区',
        'price': 550.0,
        'isVerified': true,
      },
      
      // サンリオ関連
      {
        'id': 'sns_004',
        'type': 'twitter',
        'productId': 'prod_003',
        'username': '@INSIDEjp',
        'content': '「ボンボンドロップシール」が公式抽選販売！対象は「サンリオキャラクターズ ミニ」全4セット、"前回までの落選者"を優先',
        'imageUrl': 'https://via.placeholder.com/300/FFD700/FFFFFF?text=Sanrio+Lottery',
        'postUrl': 'https://x.com/INSIDEjp/status/2015233183101661604',
        'postedAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        'storeName': 'ボンボンドロップ公式',
        'location': 'オンライン抽選',
        'price': 550.0,
        'isVerified': true,
      },
      {
        'id': 'sns_005',
        'type': 'instagram',
        'productId': 'prod_001',
        'username': 'bonbon_drop_seal',
        'content': '大人気✨ボンボンドロップシール サンリオキャラクターズのミニサイズが登場！色合いがとても可愛いクロミちゃんのボンボンドロップシールです☝',
        'imageUrl': 'https://via.placeholder.com/300/FF69B4/FFFFFF?text=Instagram+Bonbon',
        'postUrl': 'https://www.instagram.com/p/DS3ypMbklqi/',
        'postedAt': now.subtract(const Duration(days: 28)).toIso8601String(),
        'storeName': 'ボンボンドロップ公式',
        'location': 'オンライン',
        'price': 550.0,
        'isVerified': true,
      },
      
      // Instagram投稿
      {
        'id': 'sns_006',
        'type': 'instagram',
        'productId': 'prod_001',
        'username': 'bonbon_drop_seal',
        'content': '🎀 1月 再販情報 🎀\n\n下記ボンボンドロップシールを再販します✨\n⭐️和柄 12柄⭐️オリジナル 12柄⭐️churukiraシリーズ 4柄\n\n今月21日頃以降に各店に順次入荷',
        'imageUrl': 'https://via.placeholder.com/300/FFD700/FFFFFF?text=Restock+Info',
        'postUrl': 'https://www.instagram.com/p/DTO9wSEk3gp/',
        'postedAt': now.subtract(const Duration(days: 14)).toIso8601String(),
        'storeName': 'ロフト・ハンズ・ドンキホーテ',
        'location': '全国各店',
        'price': 550.0,
        'isVerified': true,
      },
      {
        'id': 'sns_007',
        'type': 'line',
        'productId': 'prod_001',
        'username': 'シール販売情報共有【ボンボンドロップ】',
        'content': '宮城県内のシール販売情報やオンラインでの販売情報を共有しましょう！ボンボンドロップシールの最新入荷情報を交換しています。',
        'imageUrl': null,
        'postUrl': 'https://openchat.line.me/jp/cover/Sl0yXT7HU0e_mfdA3IGejyZsofiRrhwUGVuwnCWHDNjnCIg3Smzp6ExV6L8',
        'postedAt': now.subtract(const Duration(days: 3)).toIso8601String(),
        'storeName': 'LINEオープンチャット',
        'location': '宮城県',
        'price': null,
        'isVerified': false,
      },
      {
        'id': 'sns_008',
        'type': 'line',
        'productId': 'prod_001',
        'username': '【都内&埼玉】シール情報交換',
        'content': '都内＆埼玉県のシール在庫情報など交換し合いましょう #ボンボンドロップシール #ボンボンドロップ #シール #シール帳',
        'imageUrl': null,
        'postUrl': 'https://openchat.line.me/jp/cover/eKKUYedkVZL1PniKV6ANnAKmoWQvGzaqzgWF5xPlu0u54hEmgnRQtZSWgG4',
        'postedAt': now.subtract(const Duration(days: 5)).toIso8601String(),
        'storeName': 'LINEオープンチャット',
        'location': '東京都・埼玉県',
        'price': null,
        'isVerified': false,
      },
      
      // 近畿圏の情報
      {
        'id': 'sns_009',
        'type': 'line',
        'productId': 'prod_001',
        'username': '〖兵庫南東部〗シールあつめ',
        'content': '兵庫県（尼崎・西宮・伊丹・神戸）のボンボンドロップシール入荷情報を共有するオープンチャットです。',
        'imageUrl': null,
        'postUrl': 'https://openchat.line.me/jp/cover/GnTEN-OKwB0lSEik3wQVep6gRYknEbdPEieRtihw7wgRqjFE-7df-H9jwGk',
        'postedAt': now.subtract(const Duration(days: 2)).toIso8601String(),
        'storeName': 'LINEオープンチャット',
        'location': '兵庫県',
        'price': null,
        'isVerified': false,
      },
      {
        'id': 'sns_010',
        'type': 'twitter',
        'productId': 'prod_001',
        'username': '@np_kiddyland',
        'content': '\\商品再入荷のお知らせ／\nサンリオ ボンボンドロップシール が入荷いたしました\n#サンリオ #シール\n※レジにて販売致します。',
        'imageUrl': null,
        'postUrl': 'https://twitter.com/np_kiddyland/status/2014550273713439007',
        'postedAt': now.subtract(const Duration(days: 3)).toIso8601String(),
        'storeName': 'キデイランド全店',
        'location': '全国各店',
        'price': 550.0,
        'isVerified': true,
      },
      {
        'id': 'sns_010',
        'type': 'twitter',
        'productId': 'prod_001',
        'username': '@ashley_olmeda',
        'content': '超大量ボンボンドロップシール販売情報グループ作成しました！\n・最新の販売情報\n・入荷／在庫情報\nなどをリアルタイムで共有しています✨\n✓ 参加無料',
        'imageUrl': null,
        'postUrl': 'https://x.com/ashley_olmeda',
        'postedAt': now.subtract(const Duration(days: 10)).toIso8601String(),
        'storeName': null,
        'location': null,
        'price': null,
        'isVerified': false,
      },
    ];
  }
  
  /// 商品IDでSNS投稿をフィルター
  static List<Map<String, dynamic>> getPostsByProduct(String productId) {
    return getSampleSnsPosts()
        .where((post) => post['productId'] == productId)
        .toList();
  }
  
  /// SNSタイプでフィルター
  static List<Map<String, dynamic>> getPostsByType(SnsType type) {
    final typeString = type.toString().split('.').last;
    return getSampleSnsPosts()
        .where((post) => post['type'] == typeString)
        .toList();
  }
}
