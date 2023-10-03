import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/book_model.dart';
import '../models/borrow_model.dart';
import '../services/calculator.dart';
import 'borrow_book_view_model.dart';

class BarrowBookView extends StatefulWidget {
  final Book book;

  const BarrowBookView(this.book);

  @override
  State<BarrowBookView> createState() => _BarrowBookViewState();
}

class _BarrowBookViewState extends State<BarrowBookView> {
  @override
  Widget build(BuildContext context) {
    List<BorrowInfo> borrowList = widget.book.borrows;
    return ChangeNotifierProvider<BarrowBookViewModel>(
      create: (context) => BarrowBookViewModel(),
      builder: (context, _) => Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Reference _refStorage = FirebaseStorage.instance.ref();
              Reference? refPhotos = _refStorage.child('photos');
              var photoUrl = await refPhotos.child('01.jpg').getDownloadURL();
              print(photoUrl);
            },
          ),
          appBar: AppBar(
              title:
                  Text('${widget.book.bookName.toUpperCase()} Ödünç Listesi'),
              centerTitle: true),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Flexible(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              borrowList[index].photoUrl ??
                                  'https://i.hizliresim.com/p61ovs2.jpg'),
                        ),
                        title: Text(
                            '${borrowList[index].name} ${borrowList[index].surname}'),
                      );
                    },
                    separatorBuilder: (context, _) => Divider(),
                    itemCount: borrowList.length),
              ),
              Flexible(
                  child: InkWell(
                      onTap: () async {
                        BorrowInfo? newBorrowInfo =
                            await showModalBottomSheet<BorrowInfo>(
                                builder: (BuildContext context) {
                                  return BorrowForm();
                                },
                                context: context);
                        if (newBorrowInfo != null) {
                          setState(() {
                            borrowList.add(newBorrowInfo);
                          });
                          context.read<BarrowBookViewModel>().updateBook(
                              book: widget.book, borrowList: borrowList);
                        }
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          color: Colors.blueAccent,
                          child: Text(
                            'YENİ ÖDÜNÇ',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ))))
            ],
          )),
    );
  }
}

class BorrowForm extends StatefulWidget {
  const BorrowForm({super.key});

  @override
  State<BorrowForm> createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController surnameCtr = TextEditingController();
  TextEditingController borrowDateCtr = TextEditingController();
  TextEditingController returnDateCtr = TextEditingController();
  BarrowBookViewModel barrowBookViewModel = BarrowBookViewModel();
  var _selectedBorrowDate;
  var _selectedReturnDate;

  XFile? _image;
  XFile? _pickedFile;
  final picker= ImagePicker();

  Future getImage() async {
    _pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(_pickedFile!=null){
        _image=XFile(_pickedFile!.path);
      }
      else{
        print('No Image Selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      child: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Stack(
                    children: [
                    CircleAvatar(
                    radius: 40,
                    // child: (_image == null)
                    //     ? Image(image: NetworkImage('https://i.hizliresim.com/p61ovs2.jpg'))
                    //     : Image.file(File(_image!.path)),
                        backgroundImage: (_image == null)
                            ? NetworkImage('https://i.hizliresim.com/p61ovs2.jpg')
                            : FileImage(File(_image!.path)) as ImageProvider<Object>?,
                      ),


                      Positioned(
                          bottom: -5,
                          right: -10,
                          child: IconButton(
                            icon: Icon(Icons.photo_camera_rounded),
                            onPressed: getImage,
                          ))
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameCtr,
                        decoration: InputDecoration(
                          hintText: 'Ad',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ad Giriniz';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: surnameCtr,
                        decoration: InputDecoration(
                          hintText: 'Soyad',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Soyad Giriniz';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // TextFormField(controller: nameCtr,decoration: InputDecoration(hintText: 'Ad',),validator: (value){
                //   if(value == null ||value.isEmpty){
                //     return 'Ad Giriniz';
                //   }
                //   else{
                //     return null;
                //   }
                // },),
                // TextFormField(controller: nameCtr,decoration: InputDecoration(hintText: 'Ad',),validator: (value){
                //   if(value == null ||value.isEmpty){
                //     return 'Ad Giriniz';
                //   }
                //   else{
                //     return null;
                //   }
                // },),
                // TextFormField(controller: nameCtr,decoration: InputDecoration(hintText: 'Ad',),validator: (value){
                //   if(value == null ||value.isEmpty){
                //     return 'Ad Giriniz';
                //   }
                //   else{
                //     return null;
                //   }
                // },)
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                      onTap: () async {
                        _selectedBorrowDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(-1000),
                            lastDate: DateTime.now());
                        if (_selectedBorrowDate != null) {
                          borrowDateCtr.text =
                              Calculator.dateTimeToString(_selectedBorrowDate);
                        }
                      },
                      controller: borrowDateCtr,
                      decoration: InputDecoration(
                        hintText: 'Ödünç Tarihi',
                        icon: Icon(Icons.date_range),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen Tarih Seçiniz!';
                        } else {
                          return null;
                        }
                      }),
                ),
                Flexible(
                  child: TextFormField(
                      onTap: () async {
                        _selectedReturnDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(-1000),
                            lastDate: DateTime.now().add(Duration(days: 365)));
                        if (_selectedReturnDate != null) {
                          returnDateCtr.text =
                              Calculator.dateTimeToString(_selectedReturnDate);
                        }
                      },
                      controller: returnDateCtr,
                      decoration: InputDecoration(
                          hintText: 'İade Tarihi',
                          icon: Icon(Icons.date_range)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen Tarih Seçiniz!';
                        } else {
                          return null;
                        }
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              child: Text('ÖDÜNÇ KAYIT EKLE'),
              onPressed: () {
                BorrowInfo newBorrowInfo = BorrowInfo(
                  name: nameCtr.text,
                  surname: surnameCtr.text,
                  photoUrl: null,
                  borrowDate:
                      Calculator.dateTimeToTimeStamp(_selectedBorrowDate),
                  returnDate:
                      Calculator.dateTimeToTimeStamp(_selectedReturnDate),
                );
                // widget.book.borrows.add(newBorrowInfo);
                // barrowBookViewModel.updateBook(
                //     borrowList: widget.book.borrows, book: widget.book);
                Navigator.pop(context, newBorrowInfo);
              },
            )
          ],
        ),
      ),
    );
  }
}
