import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_firestore/views/add_book_view.dart';
import 'package:firebase_firestore/views/barrow_book_view.dart';
import 'package:firebase_firestore/views/books_view_model.dart';
import 'package:firebase_firestore/views/update_book_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/book_model.dart';

class BooksView extends StatefulWidget {
  const BooksView({super.key});

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternetOnStart();
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> checkInternetOnStart() async {
    if (!(await checkInternetConnection())) {
      // Kullanıcının interneti yoksa uyarı göster
      showNoInternetAlert();
    }
  }

  void showNoInternetAlert() {
    Fluttertoast.showToast(
      msg: "İnternet bağlantısı yok!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final DocumentReference hobbitRef = kitaplarRef.doc('Hobbit');

    return ChangeNotifierProvider<BooksViewModel>(
      create: (BuildContext context) {
        return BooksViewModel();
      },
      builder: (context, child) => Scaffold(
        backgroundColor: Colors.white,
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
              StreamBuilder<List<Book>>(
                stream: Provider.of<BooksViewModel>(context, listen: false)
                    .getBookList(),
                builder: (context, AsyncSnapshot async) {
                  if (async.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (async.hasError) {
                    return Text('${async.error.toString()}');
                  }

                  if (!async.hasData || async.data == null) {
                    return const Text('Veri bulunamadı veya belge yok.');
                  }

                  List<Book> bookList = async.data;

                  return BuildListView(bookList: bookList);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildListView extends StatefulWidget {
  const BuildListView({
    super.key,
    required this.bookList,
  });

  final List<Book> bookList;

  @override
  State<BuildListView> createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  bool isFiltering = false;
  late List<Book> filteredList;

  @override
  Widget build(BuildContext context) {
    print(widget.bookList.first.borrows.first.name);
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Kitap Ara',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  isFiltering = true;
                  setState(() {
                    filteredList = widget.bookList
                        .where((book) => book.bookName
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                } else {
                  WidgetsBinding.instance.focusManager.primaryFocus!
                      .unfocus(); //klavye kendiliginden kapanmasi icin
                  setState(() {
                    isFiltering = false;
                  });
                }
              },
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount:
                  isFiltering ? filteredList.length : widget.bookList.length,
              itemBuilder: (context, index) {
                // Map<String, dynamic> docData =
                //     querySnap?[index].data() as Map<String, dynamic>;

                var list = isFiltering ? filteredList : widget.bookList;
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
                        .deleteBook(widget.bookList[index]);
                  },
                  child: Card(
                    child: ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.person_add_alt_1,
                            semanticLabel: 'Ödünç Kayıt Ekle'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BarrowBookView(widget.bookList[index])));
                        },
                        color: Colors.black,
                        style: ButtonStyle(
                          iconSize: MaterialStateProperty.all(24),
                          // Arka plan rengini burada belirleyin
                        ),
                      ),
                      title: Text(list[index].bookName),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, size: 24),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateBookView(
                                      book: widget.bookList[index])));
                        },
                      ),
                      subtitle: Text(list[index].authorName),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
