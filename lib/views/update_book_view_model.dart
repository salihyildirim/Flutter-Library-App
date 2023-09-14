import 'package:firebase_firestore/services/database.dart';
import 'package:firebase_firestore/views/books_view_model.dart';
import 'package:flutter/cupertino.dart';

import '../models/book_model.dart';

class UpdateBookViewModel extends ChangeNotifier {
  Database _database = Database();
  BooksViewModel _booksViewModel = BooksViewModel();

  Stream<List<Book>> getBookList() {
    return _booksViewModel.getBookList();
  }

}
