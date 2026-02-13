import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/models/news_item.dart';

void main() {
  test('NewsItem JSON round-trip', () {
    final item = NewsItem(
      id: 'test_001',
      title: 'テスト',
      content: 'テスト内容',
      url: 'https://example.com',
      source: SourceType.xTwitter,
      category: InfoCategory.bonbonDrop,
      publishedAt: DateTime(2025, 1, 1),
    );

    final json = item.toJson();
    final restored = NewsItem.fromJson(json);

    expect(restored.id, equals(item.id));
    expect(restored.title, equals(item.title));
    expect(restored.source, equals(item.source));
    expect(restored.category, equals(item.category));
  });

  test('InfoCategory displayName', () {
    expect(InfoCategory.bonbonDrop.displayName, 'ボンボンドロップシール');
    expect(InfoCategory.tamagotchi.displayName, 'たまごっちガチャ');
    expect(InfoCategory.zootopia.displayName, 'ズートピアガチャ');
  });

  test('SourceType displayName', () {
    expect(SourceType.xTwitter.displayName, 'X (Twitter)');
    expect(SourceType.grok.displayName, 'Grok');
    expect(SourceType.instagram.displayName, 'Instagram');
  });
}
