import 'package:firebase_firestore/services/calculator.dart';
import 'package:firebase_firestore/views/add_book_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookView extends StatefulWidget {
  const AddBookView({super.key});

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  TextEditingController bookCtr = TextEditingController();
  TextEditingController authorCtr = TextEditingController();
  TextEditingController publishCtr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _selectedDate;

  @override
  void dispose() {
    // TODO: implement dispose
    bookCtr.dispose();
    authorCtr.dispose();
    publishCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookViewModel>(
      create: (_) => AddBookViewModel(),
      builder:(context,_)=> Scaffold(
        appBar: AppBar(centerTitle: true,
          title: Text('Yeni Kitap Ekle'),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                    controller: bookCtr,
                    decoration: InputDecoration(
                        hintText: 'Kitap Adı', icon: Icon(Icons.book)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kitap Adı Boş Olamaz!';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: authorCtr,
                    decoration: InputDecoration(
                        hintText: 'Yazar Adı', icon: Icon(Icons.edit)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bu alan Boş Olamaz!';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(onTap: () async{
                     _selectedDate =await showDatePicker(context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(-1000),
                      lastDate: DateTime.now());
                  if(_selectedDate!=null) {
                    publishCtr.text=Calculator.dateTimeToString(_selectedDate);
                  }
                },
                    controller: publishCtr,
                    decoration: InputDecoration(
                        hintText: 'Basım Yılı', icon: Icon(Icons.date_range)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen Tarih Seçiniz!';
                      } else {
                        return null;
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async{
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        await context.read<AddBookViewModel>().addNewBook(bookName: bookCtr.text, authorName: authorCtr.text, publishDate: _selectedDate);
                        Navigator.pop(context);

                      }
                    },
                    child: Text("Kaydet"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
