import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_firestore/views/books_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {


  @override
  Widget build(BuildContext context) {
    // final DocumentReference hobbitRef = kitaplarRef.doc('Hobbit');

    return ChangeNotifierProvider<BooksViewModel>(
      create: (BuildContext context) { return BooksViewModel(); },
      builder:(context,child)=> Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {

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
      ),
    );
  }
}
