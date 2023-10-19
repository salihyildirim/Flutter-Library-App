import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_firestore/services/database.dart';
import 'package:flutter/cupertino.dart';

import '../models/book_model.dart';

class BooksViewModel extends ChangeNotifier {
  Database _database = Database();
  static const String collectionPath = 'books';

  Stream<List<Book>> getBookList() {
    // //Stream<List<QuerySnapshot>>  --> Stream<List<DocumentSnapshot>>
    // Stream<List<DocumentSnapshot>> streamListDocument= _database.getBookListFromApi(collectionPath).map((querySnapshot) => querySnaps.docs);
    //
    // //Stream<List<DocumentSnapshot>>  --> Stream<List<Book>>
    // Stream<List<Book>> bookList= streamListDocument.map((listOfDocSnap) => listOfDocSnap.map((docSnap) => Book.fromMap(docSnap.data())));
    Stream<List<DocumentSnapshot>> streamListDocument = _database
        .getBookListFromApi(collectionPath)
        .map((querSnapshot) => querSnapshot.docs);

    Stream<List<Book>> streamListBook = streamListDocument.map((listOfDocSnap) {
      return listOfDocSnap.map((docSnap) {
        final data = docSnap.data() as Map<String, dynamic>;
        return Book.fromMap(data);
      }).toList();
    });
    return streamListBook;
  }

  Future<void> deleteBook(Book book) async {
    await _database.deleteDocument(
        collectionPath: collectionPath, docId: book.id);

  }
}
