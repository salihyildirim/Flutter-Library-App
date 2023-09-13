import 'package:flutter/material.dart';

class UpdateBookView extends StatefulWidget {
  const UpdateBookView({super.key});

  @override
  State<UpdateBookView> createState() => _UpdateBookViewState();
}

class _UpdateBookViewState extends State<UpdateBookView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kitap Güncelle"), centerTitle: true),
      body: Container(margin: EdgeInsets.all(20),
          child: Form(
        child: Column(
          children: [
            TextFormField(),
            TextFormField(),
            TextFormField(),
            ElevatedButton(onPressed: () {}, child: Text("Güncelle"))
          ],
        ),
      )),
    );
  }
}
