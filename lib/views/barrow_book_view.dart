import 'package:flutter/material.dart';

class BarrowBookView extends StatefulWidget {
  const BarrowBookView({super.key});

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
