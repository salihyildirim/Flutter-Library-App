import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  
  @override
  Widget build(BuildContext context) {
    final kitaplarRef=_database.collection('kitaplar');

    return Scaffold(
      appBar: AppBar(title: Text("Crud Islemleri Page"),centerTitle: true),
      body: Center(
        child: Text("Veriler"),
      ),
    );
  }
}
