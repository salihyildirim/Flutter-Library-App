import 'package:flutter/material.dart';

import '../models/book_model.dart';

class BarrowBookView extends StatefulWidget {
  final Book book;
  const BarrowBookView(this.book);

  @override
  State<BarrowBookView> createState() => _BarrowBookViewState();
}

class _BarrowBookViewState extends State<BarrowBookView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kitaplar"), centerTitle: true),
      body: Column(children: []),
    );
  }
}
