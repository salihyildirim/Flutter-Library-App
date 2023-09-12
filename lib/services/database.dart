import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBookListFromApi(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }

  Future<void> deleteDocument(
      {required String collectionPath, required String docId}) async {
    await _firestore.collection(collectionPath).doc(docId).delete();
  }

  Future<void> addDocument(
      String collectionPath, Map<String, dynamic> book) async {
    await _firestore
        .collection(collectionPath)
        .doc(Book.fromMap(book).id)
        .set(book);
  }
}
