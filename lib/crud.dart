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
    final CollectionReference kitaplarRef = _database.collection('kitaplar');
    final DocumentReference hobbitRef = kitaplarRef.doc('Hobbit');

    return Scaffold(
      appBar: AppBar(title: Text("Crud Islemleri Page"), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            Text("Veriler"), Divider(), Text("${hobbitRef.id}"), /*ElevatedButton(onPressed: () async{
              var documentSnapshot= await hobbitRef.get();
              Object? data =documentSnapshot.data();
              print(data);
              ////
              QuerySnapshot collectionSnap= await kitaplarRef.get();
              List docs =collectionSnap.docs;
              print(docs.length);
              print(docs[0].data());
              docs.forEach((element) {print(element.data()['yazar']);});


            }, child: Text("GET DATA"))*/
            Divider(),
            StreamBuilder(stream: hobbitRef.snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> async)
              {
              print('streamden veri geldi.');return Text('StreamBuilder');},)
          ],

        ),
      ),
    );
  }
}
