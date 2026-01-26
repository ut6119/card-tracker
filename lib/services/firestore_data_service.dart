import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'real_data_service.dart';

/// Firestoreデータ管理サービス
class FirestoreDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RealDataService _realDataService = RealDataService();

  /// 商品データをFirestoreに保存
  Future<void> saveProductsToFirestore(List<Map<String, dynamic>> products) async {
    try {
      final batch = _firestore.batch();
      
      for (var product in products) {
        final docRef = _firestore.collection('products').doc(product['id'] as String);
        batch.set(docRef, product);
      }
      
      await batch.commit();
      
      if (kDebugMode) {
        debugPrint('${products.length}件の商品データをFirestoreに保存しました');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firestore保存エラー: $e');
      }
    }
  }

  /// Firestoreから商品データを取得
  Future<List<Map<String, dynamic>>> getProductsFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Firestore取得エラー: $e');
      }
      return [];
    }
  }

  /// 実データを取得してFirestoreに保存
  Future<void> fetchAndSaveRealData(String keyword) async {
    try {
      if (kDebugMode) {
        debugPrint('実データ取得開始: $keyword');
      }

      // 楽天市場とYahoo!ショッピングから実データを取得
      final products = await _realDataService.fetchAllProducts(keyword);
      
      if (products.isNotEmpty) {
        // Firestoreに保存
        await saveProductsToFirestore(products);
        
        if (kDebugMode) {
          debugPrint('${products.length}件の実データを取得・保存しました');
        }
      } else {
        if (kDebugMode) {
          debugPrint('実データが取得できませんでした');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('実データ取得・保存エラー: $e');
      }
    }
  }

  /// SNS投稿をFirestoreに保存
  Future<void> saveSNSPostsToFirestore(List<Map<String, dynamic>> posts) async {
    try {
      final batch = _firestore.batch();
      
      for (var post in posts) {
        final docRef = _firestore.collection('sns_posts').doc(post['id'] as String);
        batch.set(docRef, post);
      }
      
      await batch.commit();
      
      if (kDebugMode) {
        debugPrint('${posts.length}件のSNS投稿をFirestoreに保存しました');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SNS投稿Firestore保存エラー: $e');
      }
    }
  }

  /// FirestoreからSNS投稿を取得
  Future<List<Map<String, dynamic>>> getSNSPostsFromFirestore() async {
    try {
      final snapshot = await _firestore.collection('sns_posts').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SNS投稿Firestore取得エラー: $e');
      }
      return [];
    }
  }

  /// 実SNSデータを取得してFirestoreに保存
  Future<void> fetchAndSaveSNSData(String keyword) async {
    try {
      if (kDebugMode) {
        debugPrint('SNSデータ取得開始: $keyword');
      }

      // TwitterとInstagramから実データを取得
      final posts = await _realDataService.fetchAllSNSPosts(keyword);
      
      if (posts.isNotEmpty) {
        // Firestoreに保存
        await saveSNSPostsToFirestore(posts);
        
        if (kDebugMode) {
          debugPrint('${posts.length}件のSNSデータを取得・保存しました');
        }
      } else {
        if (kDebugMode) {
          debugPrint('SNSデータが取得できませんでした');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SNSデータ取得・保存エラー: $e');
      }
    }
  }

  /// 定期的にデータを更新
  Future<void> updateDataPeriodically() async {
    // ボンボンドロップやキラキラシールなどの人気キーワードで検索
    final keywords = [
      'ボンボンドロップ',
      'キラキラシール',
      'トレーディングカード',
      'レアシール',
    ];

    for (var keyword in keywords) {
      await fetchAndSaveRealData(keyword);
      await fetchAndSaveSNSData(keyword);
      
      // レート制限を考慮して待機
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
