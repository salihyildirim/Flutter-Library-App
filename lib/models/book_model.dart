import 'package:cloud_firestore/cloud_firestore.dart';

import 'borrow_model.dart';

class Book {
  final String id;
  final String bookName;
  final String authorName;
  final Timestamp publishDate;
  final List<BorrowInfo> borrows;

  Book({
    required this.id,
    required this.bookName,
    required this.authorName,
    required this.publishDate,
    required this.borrows,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> borrows =
    this.borrows.map((borrowInfo) => borrowInfo.toMap()).toList();

    return {
      'id': id,
      'bookName': bookName,
      'authorName': authorName,
      'publishDate': publishDate,
      'borrows': borrows
    };
  }

  factory Book.fromMap(Map map) {
    List<BorrowInfo> borrows = (map['borrows'] as List)
        .map((borrowAsMap) => BorrowInfo.fromMap(borrowAsMap))
        .toList();
    return Book(
      //named constructor icin factory kullanırsın.
        id: map['id'],
        bookName: map['bookName'],
        authorName: map['authorName'],
        publishDate: map['publishDate'],
        borrows: borrows
    );
  }
}
