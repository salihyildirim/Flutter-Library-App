import 'package:firebase_firestore/services/database.dart';
import 'package:firebase_firestore/views/books_view_model.dart';
import 'package:flutter/cupertino.dart';

import '../models/book_model.dart';
import '../services/calculator.dart';

class UpdateBookViewModel extends ChangeNotifier {
  Database _database = Database();
  BooksViewModel _booksViewModel = BooksViewModel();
  String collectionPath = 'books';

  Stream<List<Book>> getBookList() {
    return _booksViewModel.getBookList();
  }

  Future<void> updateBook(
      {required String bookName,
      required String authorName,
      required DateTime publishDate,
      required Book book}) async {
    /// Form alanındaki verilerle yeni bir book objesi olustur.
    Book newBook = Book(
      id: book.id,
      authorName: authorName,
      bookName: bookName,
      publishDate: Calculator.dateTimeToTimeStamp(publishDate),
      borrows: book.borrows,
    );

    /// Bu kitap bilgisini database servisi üzerinden Firestore'a yazacak.
    await _database.setBookData(collectionPath, newBook.toMap());
  }
}
