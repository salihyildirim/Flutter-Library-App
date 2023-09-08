import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book_model.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBookListFromApi(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }

  deleteBook(String collectionPath,String docId){
    _firestore.collection(collectionPath).doc(docId).delete();
  }

  addBook(String collectionPath, Book book){
    _firestore.collection(collectionPath).add(book as Map<String, dynamic>);
  }
}
