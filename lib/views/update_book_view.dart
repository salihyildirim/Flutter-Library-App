import 'package:firebase_firestore/services/calculator.dart';
import 'package:firebase_firestore/views/update_book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';

class UpdateBookView extends StatefulWidget {
  final Book book;

  UpdateBookView({required this.book});

  @override
  State<UpdateBookView> createState() => _UpdateBookViewState();
}

class _UpdateBookViewState extends State<UpdateBookView> {
  TextEditingController bookController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController publishController = TextEditingController();
  var _selectedDate;

  void dispose() {
    // TODO: implement dispose
    bookController.dispose();
    authorController.dispose();
    publishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bookController.text = widget.book.bookName;
    authorController.text = widget.book.authorName;
    publishController.text = Calculator.dateTimeToString(
        Calculator.dateTimeFromTimeStamp(widget.book.publishDate));
    return ChangeNotifierProvider<UpdateBookViewModel>(
      create: (BuildContext context) {
        return UpdateBookViewModel();
      },
      builder: (context, child) => Scaffold(
        appBar: AppBar(title: Text("Kitap Güncelle"), centerTitle: true),
        body: Container(
          margin: EdgeInsets.all(20),
          child: StreamBuilder<List<Book>>(
            stream: Provider.of<UpdateBookViewModel>(context, listen: false)
                .getBookList(),
            builder: (BuildContext context, AsyncSnapshot<List<Book>> async) {
              if (async.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (async.hasError) {
                return Text('Veri yüklenirken bir hata oluştu.');
              }

              if (!async.hasData || async.data == null) {
                return Text('Veri bulunamadı veya belge yok.');
              }
              return ListView(children: [
                Column(
                  children: [
                    TextFormField(
                      controller: bookController,
                      decoration: InputDecoration(hintText: '$bookController'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: authorController,
                      decoration:
                          InputDecoration(hintText: '$authorController'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onTap: () async {
                        _selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(-1000),
                            lastDate: DateTime.now());
                        if (_selectedDate != null) {
                          publishController.text =
                              Calculator.dateTimeToString(_selectedDate);
                        }
                      },
                      controller: publishController,
                      decoration:
                          InputDecoration(hintText: '$publishController'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UpdateBookViewModel>().updateBook(
                            bookName: bookController.text,
                            authorName: authorController.text,
                            publishDate: _selectedDate,
                            book: widget.book);
                        Navigator.pop(context);
                      },
                      child: Text("Güncelle"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                )
              ]);
            },
          ),
        ),
      ),
    );
  }
}
