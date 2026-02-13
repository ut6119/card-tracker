import '../models/news_item.dart';

/// キュレーション済みデータサービス
/// 公式アカウント、既知の情報源、最新ニュースをまとめて提供
class CuratedDataService {
  /// ボンボンドロップシールの最新情報（既知の確定情報）
  static List<NewsItem> getBonbonDropNews() {
    final now = DateTime.now();
    return [
      NewsItem(
        id: 'bd_official_01',
        title: 'ボンボンドロップシール公式 - 新作・入荷情報',
        content:
            'ボンボンドロップシールの公式アカウント。新作情報、抽選販売、再入荷情報はここでチェック。\n\n'
            '販売店舗：ロフト、ハンズ、ドン・キホーテ、キデイランド他',
        url: 'https://x.com/bonbon_drop',
        source: SourceType.xTwitter,
        category: InfoCategory.bonbonDrop,
        publishedAt: now,
        author: '@bonbon_drop',
        isVerified: true,
      ),
      NewsItem(
        id: 'bd_official_02',
        title: 'ボンボンドロップシール 公式Instagram',
        content:
            '公式Instagramアカウント。新柄プレビュー、再販情報、コレクション写真を投稿。',
        url: 'https://www.instagram.com/bonbon_drop_seal/',
        source: SourceType.instagram,
        category: InfoCategory.bonbonDrop,
        publishedAt: now,
        author: 'bonbon_drop_seal',
        isVerified: true,
      ),
      NewsItem(
        id: 'bd_store_01',
        title: 'キデイランド - ボンボンドロップシール取扱い',
        content:
            'キデイランド各店でボンボンドロップシールを販売中。入荷情報は各店舗のXアカウントで確認。\n'
            '整理券配布/LivePocket抽選の場合あり。',
        url: 'https://x.com/search?q=%E3%82%AD%E3%83%87%E3%82%A4%E3%83%A9%E3%83%B3%E3%83%89%20%E3%83%9C%E3%83%B3%E3%83%9C%E3%83%B3%E3%83%89%E3%83%AD%E3%83%83%E3%83%97&src=typed_query&f=live',
        source: SourceType.xTwitter,
        category: InfoCategory.bonbonDrop,
        publishedAt: now.subtract(const Duration(hours: 1)),
        author: 'キデイランド各店',
        isVerified: true,
      ),
      NewsItem(
        id: 'bd_inside_01',
        title: 'INSIDE - ボンボンドロップシール ニュース',
        content:
            'ゲーム・ホビー系ニュースサイトINSIDEがボンボンドロップシールの抽選販売情報を配信。',
        url: 'https://www.google.com/search?q=site:inside-games.jp+%E3%83%9C%E3%83%B3%E3%83%9C%E3%83%B3%E3%83%89%E3%83%AD%E3%83%83%E3%83%97&tbs=qdr:m',
        source: SourceType.news,
        category: InfoCategory.bonbonDrop,
        publishedAt: now.subtract(const Duration(hours: 2)),
        author: 'INSIDE',
        isVerified: true,
      ),
      NewsItem(
        id: 'bd_line_01',
        title: 'LINEオープンチャット - シール情報交換',
        content:
            '地域ごとのボンボンドロップシール情報交換コミュニティ。入荷・在庫情報をリアルタイムで共有。',
        url: 'https://openchat.line.me/jp/explore?query=%E3%83%9C%E3%83%B3%E3%83%9C%E3%83%B3%E3%83%89%E3%83%AD%E3%83%83%E3%83%97%E3%82%B7%E3%83%BC%E3%83%AB',
        source: SourceType.line,
        category: InfoCategory.bonbonDrop,
        publishedAt: now.subtract(const Duration(hours: 3)),
        author: 'コミュニティ',
        isVerified: false,
      ),
    ];
  }

  /// たまごっちガチャの最新情報
  static List<NewsItem> getTamagotchiGachaNews() {
    final now = DateTime.now();
    return [
      NewsItem(
        id: 'tg_official_01',
        title: 'たまごっち公式 - 最新グッズ＆ガチャ情報',
        content:
            'たまごっち公式サイト。新作ガチャ、グッズ情報、コラボ商品の発売スケジュールを確認。\n'
            'バンダイ公式のガチャガチャ情報も掲載。',
        url: 'https://tamagotchi-official.com/jp/',
        source: SourceType.official,
        category: InfoCategory.tamagotchi,
        publishedAt: now,
        author: 'たまごっち公式',
        isVerified: true,
      ),
      NewsItem(
        id: 'tg_bandai_01',
        title: 'バンダイ ガシャポン - たまごっちシリーズ',
        content:
            'バンダイ公式ガシャポンサイト。たまごっちのカプセルトイ最新ラインナップを確認。\n'
            '設置場所検索も可能。',
        url: 'https://gashapon.jp/search/?q=%E3%81%9F%E3%81%BE%E3%81%94%E3%81%A3%E3%81%A1',
        source: SourceType.official,
        category: InfoCategory.tamagotchi,
        publishedAt: now,
        author: 'バンダイ ガシャポン',
        isVerified: true,
      ),
      NewsItem(
        id: 'tg_x_01',
        title: 'X検索 - たまごっちガチャ 最新投稿',
        content:
            'Xで「たまごっちガチャ」の最新投稿を検索。発見報告、新作情報、設置場所の口コミなど。',
        url: 'https://x.com/search?q=%E3%81%9F%E3%81%BE%E3%81%94%E3%81%A3%E3%81%A1%20%E3%82%AC%E3%83%81%E3%83%A3&src=typed_query&f=live',
        source: SourceType.xTwitter,
        category: InfoCategory.tamagotchi,
        publishedAt: now.subtract(const Duration(minutes: 30)),
        author: 'X検索',
        isVerified: false,
      ),
      NewsItem(
        id: 'tg_grok_01',
        title: 'Grok - たまごっちガチャ最新情報',
        content:
            'GrokのAIがX上の最新情報を分析・要約。たまごっちガチャの入荷状況や新作情報をAIが整理して回答。',
        url: 'https://x.com/i/grok?text=${Uri.encodeComponent("たまごっちガチャガチャの最新情報を教えて")}',
        source: SourceType.grok,
        category: InfoCategory.tamagotchi,
        publishedAt: now.subtract(const Duration(minutes: 15)),
        author: 'Grok AI',
        isVerified: false,
      ),
    ];
  }

  /// ズートピアガチャの最新情報
  static List<NewsItem> getZootopiaGachaNews() {
    final now = DateTime.now();
    return [
      NewsItem(
        id: 'zg_official_01',
        title: 'ディズニー公式 - ズートピア グッズ＆ガチャ',
        content:
            'ディズニー公式サイトのズートピアページ。新作グッズ、ガチャガチャ、コラボ商品の情報を確認。',
        url: 'https://www.disney.co.jp/movie/zootopia',
        source: SourceType.official,
        category: InfoCategory.zootopia,
        publishedAt: now,
        author: 'ディズニー公式',
        isVerified: true,
      ),
      NewsItem(
        id: 'zg_bandai_01',
        title: 'バンダイ ガシャポン - ズートピアシリーズ',
        content:
            'バンダイ公式ガシャポンサイトでズートピア関連のカプセルトイを検索。\n'
            'ジュディ、ニック等のフィギュア・チャーム系ガチャ。',
        url: 'https://gashapon.jp/search/?q=%E3%82%BA%E3%83%BC%E3%83%88%E3%83%94%E3%82%A2',
        source: SourceType.official,
        category: InfoCategory.zootopia,
        publishedAt: now,
        author: 'バンダイ ガシャポン',
        isVerified: true,
      ),
      NewsItem(
        id: 'zg_x_01',
        title: 'X検索 - ズートピアガチャ 最新投稿',
        content:
            'Xで「ズートピア ガチャ」の最新投稿を検索。発見報告、レビュー、設置場所情報など。',
        url: 'https://x.com/search?q=%E3%82%BA%E3%83%BC%E3%83%88%E3%83%94%E3%82%A2%20%E3%82%AC%E3%83%81%E3%83%A3&src=typed_query&f=live',
        source: SourceType.xTwitter,
        category: InfoCategory.zootopia,
        publishedAt: now.subtract(const Duration(minutes: 30)),
        author: 'X検索',
        isVerified: false,
      ),
      NewsItem(
        id: 'zg_grok_01',
        title: 'Grok - ズートピアガチャ最新情報',
        content:
            'GrokのAIがX上の最新情報を分析・要約。ズートピアガチャの入荷状況や新作情報をAIが整理して回答。',
        url: 'https://x.com/i/grok?text=${Uri.encodeComponent("ズートピア ガチャガチャの最新情報を教えて")}',
        source: SourceType.grok,
        category: InfoCategory.zootopia,
        publishedAt: now.subtract(const Duration(minutes: 15)),
        author: 'Grok AI',
        isVerified: false,
      ),
    ];
  }

  /// 全カテゴリのニュースを取得
  static List<NewsItem> getAllNews() {
    final all = <NewsItem>[
      ...getBonbonDropNews(),
      ...getTamagotchiGachaNews(),
      ...getZootopiaGachaNews(),
    ];
    all.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return all;
  }

  /// カテゴリ別にニュースを取得
  static List<NewsItem> getNewsByCategory(InfoCategory category) {
    switch (category) {
      case InfoCategory.bonbonDrop:
        return getBonbonDropNews();
      case InfoCategory.tamagotchi:
        return getTamagotchiGachaNews();
      case InfoCategory.zootopia:
        return getZootopiaGachaNews();
      case InfoCategory.gacha:
        return [
          ...getTamagotchiGachaNews(),
          ...getZootopiaGachaNews(),
        ]..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      case InfoCategory.other:
        return [];
    }
  }
}
