import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> deleteABorrow({required String collectionPath, required String docId,required List<BorrowInfo> borrowList, required int deleteIndex}) async {
    List<BorrowInfo> newBorrowList = borrowList.removeAt(deleteIndex) as List<BorrowInfo>;
    await _firestore.collection(collectionPath).doc(docId).update({'borrows': borrowList});

  }
}
