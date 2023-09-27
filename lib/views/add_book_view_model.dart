import 'package:firebase_firestore/services/calculator.dart';
import 'package:firebase_firestore/services/database.dart';
import 'package:flutter/cupertino.dart';

import '../models/book_model.dart';

class AddBookViewModel extends ChangeNotifier {
  String collectionPath='books';
  Database _database = Database();

  Future<void> addNewBook(
      {required String bookName,
      required String authorName,
      required DateTime publishDate}) async {
    /// Form alanındaki verilerle yeni bir book objesi olustur.
    Book newBook = Book(
        id: DateTime.now().toIso8601String(),
        authorName: authorName,
        bookName: bookName,
        publishDate: Calculator.dateTimeToTimeStamp(publishDate), borrows: []);

    /// Bu kitap bilgisini database servisi üzerinden Firestore'a yazacak.
    await _database.setBookData(collectionPath, newBook.toMap());
  }
}
