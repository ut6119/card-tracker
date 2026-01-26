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
        'type': 'twitter',
        'productId': 'prod_003',
        'username': '@seal_ya_san',
        'content': 'サンリオ miniシリーズ 定価 抽選販売のお知らせ\n【D\'or 原宿 様】\n販売内容 ボンボンドロップシール 【サンリオ】miniシリーズ (各￥550-)',
        'imageUrl': null,
        'postUrl': 'https://x.com/seal_ya_san/status/2013166512081965332',
        'postedAt': now.subtract(const Duration(days: 7)).toIso8601String(),
        'storeName': 'D\'or 原宿',
        'location': '東京都渋谷区',
        'price': 550.0,
        'isVerified': false,
      },
      
      // たまごっち・その他
      {
        'id': 'sns_006',
        'type': 'twitter',
        'productId': 'prod_002',
        'username': '@Will_suzaka',
        'content': '#ウィル須坂インター店\nボンボンドロップシール 入荷しました!!\n※ごくごく少量の為、売り切れの際はご容赦ください🙇‍♀️',
        'imageUrl': null,
        'postUrl': 'https://x.com/Will_suzaka/status/2012338896269656231',
        'postedAt': now.subtract(const Duration(days: 7)).toIso8601String(),
        'storeName': 'ウィル須坂インター店',
        'location': '長野県須坂市',
        'price': 550.0,
        'isVerified': false,
      },
      {
        'id': 'sns_007',
        'type': 'twitter',
        'productId': 'prod_004',
        'username': '@will_toyoshina',
        'content': 'Will豊科店よりお知らせです。\n✨️ボンボンドロップシールが入荷致しました✨️\n・お取り寄せお取置きはお断りしております。',
        'imageUrl': null,
        'postUrl': 'https://x.com/will_toyoshina/status/2014136532559433972',
        'postedAt': now.subtract(const Duration(days: 4)).toIso8601String(),
        'storeName': 'Will豊科店',
        'location': '長野県安曇野市',
        'price': 550.0,
        'isVerified': false,
      },
      
      // 店舗入荷情報
      {
        'id': 'sns_008',
        'type': 'twitter',
        'productId': 'prod_005',
        'username': '@jyohoku_kobabun',
        'content': '📢シール入荷情報📢\n画像のシールが入荷しました！\n⚠️お一家族様種類問わず2枚まで⚠️電話等での取り置き不可⚠️',
        'imageUrl': null,
        'postUrl': 'https://x.com/jyohoku_kobabun/status/2012683870441758790',
        'postedAt': now.subtract(const Duration(days: 7)).toIso8601String(),
        'storeName': '文具館コバヤシ城北店',
        'location': '石川県金沢市',
        'price': 550.0,
        'isVerified': false,
      },
      {
        'id': 'sns_009',
        'type': 'twitter',
        'productId': 'prod_001',
        'username': '@np_kiddyland',
        'content': '\\商品再入荷のお知らせ／\nサンリオ ボンボンドロップシール が入荷いたしました\n#サンリオ #シール\n※レジにて販売致します。',
        'imageUrl': null,
        'postUrl': 'https://twitter.com/np_kiddyland/status/2014550273713439007',
        'postedAt': now.subtract(const Duration(days: 3)).toIso8601String(),
        'storeName': 'キデイランド',
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
