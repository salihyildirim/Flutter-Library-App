import 'package:firebase_firestore/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../models/borrow_model.dart';

class BarrowBookViewModel with ChangeNotifier {
  Database _database = Database();
  String collectionPath = 'books';

  Future<void> updateBook(
      {required List<BorrowInfo> borrowList, required Book book}) async {
    Book newBook = Book(
        id: book.id,
        bookName: book.bookName,
        authorName: book.authorName,
        publishDate: book.publishDate,
        borrows: borrowList);

    await _database.setBookData(
        collectionPath: collectionPath, book: newBook.toMap());
  }

  Future<void> deletePhoto(String photoUrl) async {
    Reference photoRef = FirebaseStorage.instance.refFromURL(photoUrl);
    await photoRef.delete();
  }

  Future<void> deleteABorrow(Book book, int deleteIndex) async {
    _database.deleteABorrow(
        collectionPath: collectionPath,
        docId: book.id,
        borrowList: book.borrows,
        deleteIndex: deleteIndex);
  }
}
