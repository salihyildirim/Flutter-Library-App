import 'package:firebase_firestore/views/add_book_view.dart';
import 'package:firebase_firestore/views/books_view_model.dart';
import 'package:firebase_firestore/views/update_book_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';

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
      create: (BuildContext context) {
        return BooksViewModel();
      },
      builder: (context, child) => Scaffold(backgroundColor: Colors.white70,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBookView()));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(title: const Text("Kitaplar"), centerTitle: true),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Kitap Ara',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
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
                child: StreamBuilder<List<Book>>(
                  stream: Provider.of<BooksViewModel>(context, listen: false)
                      .getBookList(),
                  builder: (context, AsyncSnapshot async) {
                    if (async.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (async.hasError) {
                      return const Text('Veri yüklenirken bir hata oluştu.');
                    }

                    if (!async.hasData || async.data == null) {
                      return const Text('Veri bulunamadı veya belge yok.');
                    }

                    List<Book> bookList = async.data;

                    return ListView.builder(
                      itemCount: bookList.length,
                      itemBuilder: (context, index) {
                        // Map<String, dynamic> docData =
                        //     querySnap?[index].data() as Map<String, dynamic>;

                        return Dismissible(
                          // dismissible yerine slidable yapılacak.
                          // confirmDismiss: (direction)async {
                          //   return false; // showalertDialog yapabilirsin.
                          // },
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            child: const Icon(Icons.delete),
                          ),
                          onDismissed: (_) {
                            // querySnap[index].reference.update({'sene': FieldValue.delete()}); // dökümanın sadece bir alanini siler(sene).
                            Provider.of<BooksViewModel>(context, listen: false)
                                .deleteBook(bookList[index]);
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(bookList[index].authorName),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateBookView(
                                              book: bookList[index])));
                                },
                              ),
                              subtitle: Text(bookList[index].bookName),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
