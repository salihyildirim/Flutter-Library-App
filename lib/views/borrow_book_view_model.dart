import 'package:firebase_firestore/services/database.dart';

import '../models/book_model.dart';
import '../models/borrow_model.dart';

class BarrowBookViewModel {
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
}
