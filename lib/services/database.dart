import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_firestore/services/calculator.dart';

import '../models/book_model.dart';
import '../models/borrow_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBookListFromApi(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }

  Future<void> deleteDocument(
      {required String collectionPath, required String docId}) async {
    await _firestore.collection(collectionPath).doc(docId).delete();
  }

  Future<void> setBookData(
      {required String collectionPath,
      required Map<String, dynamic> book}) async {
    await _firestore
        .collection(collectionPath)
        .doc(Book.fromMap(book).id)
        .set(book);
  }

  Future<void> deleteADocumentField(
      {required String collectionPath,
      required String docId,
      required String fieldName}) async {
    DocumentReference documentRef =
        await _firestore.collection(collectionPath).doc(docId);
    await documentRef.update({fieldName: FieldValue.delete()});
  }

  Future<void> deleteABorrow({required Book book, required int borrowIndex, required String collectionPath}) async {
    // Dökümanı çek
    final docRef = _firestore.collection(collectionPath).doc(book.id);
    final document = await docRef.get();

    // Dökümandan veriyi al
    final data = document.data() as Map<String, dynamic>;

    // 'borrows' anahtarını kontrol et
    if (data.containsKey('borrows')) {
      // Borrows listesini al
      final List<BorrowInfo> borrows = data['borrows'];

      // Belirtilen indisli öğeyi kaldır
      if (borrowIndex >= 0 && borrowIndex < borrows.length) {
        borrows.removeAt(borrowIndex);
      }

      // Veriyi güncelle ve Firestore'a geri yükle
      await docRef.update({'borrows': borrows});
    }
  }

}
