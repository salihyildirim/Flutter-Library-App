import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  Map<String, dynamic> bookToAdd = {
    'ad': 'Denemeler',
    'yazar': 'Montaigne',
    'sene': 1580
  };

  @override
  Widget build(BuildContext context) {
    final CollectionReference kitaplarRef = _database.collection('kitaplar');
    // final DocumentReference hobbitRef = kitaplarRef.doc('Hobbit');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // DocumentReference addedBook= await kitaplarRef.add(bookToAdd); // eklenirken ID auto olarak belirler.
          // print(addedBook.id);
          // print(addedBook.path);
          _database
              .collection('Kayip Kitaplar')
              .doc('Harry Potter')
              .set({'ad': 'Harry Potter', 'yazar': 'Rowling', 'sene': 1997});
          await kitaplarRef.doc(bookToAdd['ad']).set(
              bookToAdd); //  eklerken id'yi doc içerisinde belirtebilirsin.
          //kitap ismini id olarak verdik.
          //////
          await kitaplarRef.doc(bookToAdd['ad']).update({'sene': 2020});
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("Crud Islemleri"), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            /*ElevatedButton(onPressed: () async{
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
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: kitaplarRef.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> async) {
                  if (async.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (async.hasError) {
                    return Text('Veri yüklenirken bir hata oluştu.');
                  }

                  if (!async.hasData || async.data == null) {
                    return Text('Veri bulunamadı veya belge yok.');
                  }

                  var querySnap = async.data?.docs;

                  return ListView.builder(
                    itemCount: querySnap?.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> docData =
                          querySnap?[index].data() as Map<String, dynamic>;

                      return Dismissible(
                        // confirmDismiss: (direction)async {
                        //   return false; // showalertDialog yapabilirsin.
                        // },
                        key: UniqueKey(),
                        direction: DismissDirection.horizontal,
                        background: Container(
                          child: Icon(Icons.delete),
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                        ),
                        onDismissed: (_) {
                          querySnap![index].reference.delete(); //deleted
                          // querySnap[index].reference.update({'sene': FieldValue.delete()}); // dökümanın sadece bir alanini siler(sene).
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(docData['ad'].toString()),
                            subtitle: Text(docData['yazar'].toString()),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
