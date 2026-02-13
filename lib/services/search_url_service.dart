import '../models/news_item.dart';

/// 各プラットフォームの検索URL生成サービス
/// X, Grok, Instagram, 楽天, Amazon, メルカリ, YouTube, Yahoo!, Google
class SearchUrlService {
  /// --- X (Twitter) 検索URL ---
  static String xSearchUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://x.com/search?q=$encoded&src=typed_query&f=live';
  }

  /// --- Grok 検索URL ---
  /// Grokに質問形式で最新情報を問い合わせ
  static String grokSearchUrl(String keyword) {
    final query = Uri.encodeComponent('$keywordの最新情報を教えて');
    return 'https://x.com/i/grok?text=$query';
  }

  /// --- Yahoo! リアルタイム検索URL ---
  /// X投稿の検索結果を表示（API不要で閲覧可能）
  static String yahooRealtimeUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://search.yahoo.co.jp/realtime/search?p=$encoded&ei=UTF-8';
  }

  /// --- Instagram ハッシュタグ検索URL ---
  static String instagramTagUrl(String tag) {
    final cleanTag = tag.replaceAll('#', '').replaceAll(' ', '');
    return 'https://www.instagram.com/explore/tags/$cleanTag/';
  }

  /// --- Instagram プロフィールURL ---
  static String instagramProfileUrl(String username) {
    final clean = username.replaceAll('@', '');
    return 'https://www.instagram.com/$clean/';
  }

  /// --- 楽天市場 検索URL ---
  static String rakutenSearchUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://search.rakuten.co.jp/search/mall/$encoded/';
  }

  /// --- Amazon.co.jp 検索URL ---
  static String amazonSearchUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://www.amazon.co.jp/s?k=$encoded';
  }

  /// --- メルカリ 検索URL ---
  static String mercariSearchUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://jp.mercari.com/search?keyword=$encoded';
  }

  /// --- YouTube 検索URL ---
  static String youtubeSearchUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://www.youtube.com/results?search_query=$encoded&sp=CAI%253D';
  }

  /// --- Google 検索URL ---
  static String googleSearchUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://www.google.com/search?q=$encoded&tbs=qdr:w';
  }

  /// --- Google ニュース検索URL ---
  static String googleNewsUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://news.google.com/search?q=$encoded&hl=ja&gl=JP&ceid=JP:ja';
  }

  /// --- LINE オープンチャット検索URL ---
  static String lineOpenChatSearchUrl(String keyword) {
    final encoded = Uri.encodeComponent(keyword);
    return 'https://openchat.line.me/jp/explore?query=$encoded';
  }

  /// === ボンボンドロップシール向け検索リンク一覧 ===
  static List<SearchLink> getBonbonDropLinks() {
    return [
      // Grok（X情報のAI要約）
      SearchLink(
        label: 'Grokで最新情報を聞く',
        url: grokSearchUrl('ボンボンドロップシール 入荷 販売'),
        source: SourceType.grok,
        description: 'GrokにボンボンドロップシールのリアルタイムX情報を聞く',
      ),
      // X検索
      SearchLink(
        label: 'Xで検索（リアルタイム）',
        url: xSearchUrl('ボンボンドロップシール'),
        source: SourceType.xTwitter,
        description: 'X上の最新投稿をリアルタイムで検索',
      ),
      // Yahoo!リアルタイム
      SearchLink(
        label: 'Yahoo!リアルタイム検索',
        url: yahooRealtimeUrl('ボンボンドロップシール'),
        source: SourceType.yahoo,
        description: 'Yahoo!でX投稿を検索（ログイン不要）',
      ),
      // Instagram
      SearchLink(
        label: 'Instagram #ボンボンドロップシール',
        url: instagramTagUrl('ボンボンドロップシール'),
        source: SourceType.instagram,
        description: 'Instagramのハッシュタグ投稿',
      ),
      SearchLink(
        label: 'Instagram 公式アカウント',
        url: instagramProfileUrl('bonbon_drop_seal'),
        source: SourceType.instagram,
        description: 'ボンボンドロップシール公式Instagram',
      ),
      // 通販サイト
      SearchLink(
        label: '楽天市場で検索',
        url: rakutenSearchUrl('ボンボンドロップシール'),
        source: SourceType.rakuten,
        description: '楽天市場の在庫・価格をチェック',
      ),
      SearchLink(
        label: 'Amazonで検索',
        url: amazonSearchUrl('ボンボンドロップシール'),
        source: SourceType.amazon,
        description: 'Amazon.co.jpの在庫・価格をチェック',
      ),
      SearchLink(
        label: 'メルカリで検索',
        url: mercariSearchUrl('ボンボンドロップシール'),
        source: SourceType.mercari,
        description: 'メルカリの出品をチェック',
      ),
      // YouTube
      SearchLink(
        label: 'YouTube 開封・レビュー動画',
        url: youtubeSearchUrl('ボンボンドロップシール 開封'),
        source: SourceType.youtube,
        description: '最新の開封動画やレビュー',
      ),
      // Google
      SearchLink(
        label: 'Google ニュース検索',
        url: googleNewsUrl('ボンボンドロップシール'),
        source: SourceType.google,
        description: '最新ニュース記事を検索',
      ),
      // LINE
      SearchLink(
        label: 'LINEオープンチャット',
        url: lineOpenChatSearchUrl('ボンボンドロップシール'),
        source: SourceType.line,
        description: 'シール情報交換コミュニティ',
      ),
    ];
  }

  /// === たまごっちガチャ向け検索リンク一覧 ===
  static List<SearchLink> getTamagotchiGachaLinks() {
    return [
      SearchLink(
        label: 'Grokで最新情報を聞く',
        url: grokSearchUrl('たまごっち ガチャガチャ 最新'),
        source: SourceType.grok,
        description: 'Grokにたまごっちガチャの最新情報を聞く',
      ),
      SearchLink(
        label: 'Xで検索（リアルタイム）',
        url: xSearchUrl('たまごっち ガチャ'),
        source: SourceType.xTwitter,
        description: 'X上の最新投稿',
      ),
      SearchLink(
        label: 'Yahoo!リアルタイム検索',
        url: yahooRealtimeUrl('たまごっち ガチャガチャ'),
        source: SourceType.yahoo,
        description: 'Yahoo!でX投稿を検索（ログイン不要）',
      ),
      SearchLink(
        label: 'バンダイ たまごっち公式',
        url: 'https://tamagotchi-official.com/jp/',
        source: SourceType.official,
        description: 'たまごっち公式サイト',
      ),
      SearchLink(
        label: 'Instagram #たまごっちガチャ',
        url: instagramTagUrl('たまごっちガチャ'),
        source: SourceType.instagram,
        description: 'Instagramのハッシュタグ投稿',
      ),
      SearchLink(
        label: '楽天市場で検索',
        url: rakutenSearchUrl('たまごっち ガチャ'),
        source: SourceType.rakuten,
        description: '楽天市場の在庫・価格',
      ),
      SearchLink(
        label: 'Amazonで検索',
        url: amazonSearchUrl('たまごっち ガチャガチャ'),
        source: SourceType.amazon,
        description: 'Amazon.co.jpの在庫・価格',
      ),
      SearchLink(
        label: 'メルカリで検索',
        url: mercariSearchUrl('たまごっち ガチャ'),
        source: SourceType.mercari,
        description: 'メルカリの出品',
      ),
      SearchLink(
        label: 'YouTube 開封動画',
        url: youtubeSearchUrl('たまごっち ガチャ 開封'),
        source: SourceType.youtube,
        description: '最新の開封動画',
      ),
      SearchLink(
        label: 'Google ニュース',
        url: googleNewsUrl('たまごっち ガチャガチャ 新作'),
        source: SourceType.google,
        description: '最新ニュース',
      ),
    ];
  }

  /// === ズートピアガチャ向け検索リンク一覧 ===
  static List<SearchLink> getZootopiaGachaLinks() {
    return [
      SearchLink(
        label: 'Grokで最新情報を聞く',
        url: grokSearchUrl('ズートピア ガチャガチャ 最新'),
        source: SourceType.grok,
        description: 'Grokにズートピアガチャの最新情報を聞く',
      ),
      SearchLink(
        label: 'Xで検索（リアルタイム）',
        url: xSearchUrl('ズートピア ガチャ'),
        source: SourceType.xTwitter,
        description: 'X上の最新投稿',
      ),
      SearchLink(
        label: 'Yahoo!リアルタイム検索',
        url: yahooRealtimeUrl('ズートピア ガチャガチャ'),
        source: SourceType.yahoo,
        description: 'Yahoo!でX投稿を検索（ログイン不要）',
      ),
      SearchLink(
        label: 'ディズニー公式',
        url: 'https://www.disney.co.jp/movie/zootopia',
        source: SourceType.official,
        description: 'ディズニー公式サイト',
      ),
      SearchLink(
        label: 'Instagram #ズートピアガチャ',
        url: instagramTagUrl('ズートピアガチャ'),
        source: SourceType.instagram,
        description: 'Instagramのハッシュタグ投稿',
      ),
      SearchLink(
        label: '楽天市場で検索',
        url: rakutenSearchUrl('ズートピア ガチャ'),
        source: SourceType.rakuten,
        description: '楽天市場の在庫・価格',
      ),
      SearchLink(
        label: 'Amazonで検索',
        url: amazonSearchUrl('ズートピア ガチャガチャ'),
        source: SourceType.amazon,
        description: 'Amazon.co.jpの在庫・価格',
      ),
      SearchLink(
        label: 'メルカリで検索',
        url: mercariSearchUrl('ズートピア ガチャ'),
        source: SourceType.mercari,
        description: 'メルカリの出品',
      ),
      SearchLink(
        label: 'YouTube 開封動画',
        url: youtubeSearchUrl('ズートピア ガチャ 開封'),
        source: SourceType.youtube,
        description: '最新の開封動画',
      ),
      SearchLink(
        label: 'Google ニュース',
        url: googleNewsUrl('ズートピア ガチャガチャ'),
        source: SourceType.google,
        description: '最新ニュース',
      ),
    ];
  }

  /// === 全カテゴリの検索リンクを取得 ===
  static List<SearchLink> getLinksForCategory(InfoCategory category) {
    switch (category) {
      case InfoCategory.bonbonDrop:
        return getBonbonDropLinks();
      case InfoCategory.tamagotchi:
        return getTamagotchiGachaLinks();
      case InfoCategory.zootopia:
        return getZootopiaGachaLinks();
      case InfoCategory.gacha:
        return [
          ...getTamagotchiGachaLinks(),
          ...getZootopiaGachaLinks(),
        ];
      case InfoCategory.other:
        return [];
    }
  }
}
