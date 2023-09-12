import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
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
              TextFormField(
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
                  onPressed: () {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {

                    }
                  },
                  child: Text("Kaydet"))
            ],
          ),
        ),
      ),
    );
  }
}
