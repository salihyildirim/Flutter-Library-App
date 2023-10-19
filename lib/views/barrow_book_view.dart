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
          appBar: AppBar(
              title:
                  Text('${widget.book.bookName.toUpperCase()} ÖDÜNÇ LİSTESİ'),
              centerTitle: true),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (_)async{
                         await Provider.of<BarrowBookViewModel>(context, listen: false)
                            .deleteABorrow(widget.book,index);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                borrowList[index].photoUrl ??
                                    'https://i.hizliresim.com/p61ovs2.jpg'),
                          ),
                          title: Text(
                              '${borrowList[index].name} ${borrowList[index].surname}'),
                        ),
                      );
                    },
                    separatorBuilder: (context, _) => Divider(),
                    itemCount: borrowList.length),
              ),
              Flexible(
                  child: InkWell(
                      //ALTTAKI MAVI YENI ODUNC BUTONU
                      onTap: () async {
                        BorrowInfo? newBorrowInfo = await showModalBottomSheet<
                                BorrowInfo>(
                            enableDrag: false,
                            isDismissible: false,
                            context: context,
                            // MODALBOTTOMSHEET EGER BEKLENMEDIK SEKILDE KAPATILIRSA
                            // BORROWINFO NULL DONECEK CUNKU BORROWINFO ATAMASINI ONPRESS DE YAPIYORUZ VE POP EDIYORUZ. BU ŞEKİLDE KT EDEBİLİRSİN.
                            builder: (BuildContext context) {
                              return WillPopScope(
                                  onWillPop: () async {
                                    return false;
                                  },
                                  child: BorrowForm());
                            });
                        print(
                            "modalBottomSheet Donen BorrowInfoDegeri : $newBorrowInfo");
                        if (newBorrowInfo != null) {
                          setState(() {
                            borrowList.add(newBorrowInfo);
                          });
                          context.read<BarrowBookViewModel>().updateBook(
                              book: widget.book, borrowList: borrowList);
                        } else if (newBorrowInfo == null) {
                          //store'dan fotoyu sil.
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
  String? photoUrl;

  XFile? _image;
  XFile? _pickedFile;
  final picker = ImagePicker();

  Future<void> getImage() async {
    _pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality:
            50); // image quality duserek storage icerisinde az yer kaplattik.

    setState(() {
      if (_pickedFile != null) {
        _image = XFile(_pickedFile!.path); //XFILE TO FILE
      } else {
        print('No Image Selected.');
      }
    });
    if (_pickedFile != null) {
      photoUrl = await uploadImageToStorage(
          _image!); //UPLOADING TO STORAGE PHOTO TAKEN
    }
  }

  Future<String> uploadImageToStorage(XFile imageFile) async {
    ///Storage üzerindeki dosya adını olustur.
    String photoPath = '${DateTime.now().microsecondsSinceEpoch}.jpg';

    ///dosyayı gonder
    final storageRef = FirebaseStorage.instance.ref();
    final photosRef = storageRef.child("photos");
    File file = File(imageFile.path); // XFile convert to File.
    TaskSnapshot uploadTask = await photosRef.child(photoPath).putFile(file);

    String uploadedImageUrl = await uploadTask.ref.getDownloadURL();
    return uploadedImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BarrowBookViewModel(),
      builder: (context, _) => Container(
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
                              ? NetworkImage(
                                  'https://i.hizliresim.com/p61ovs2.jpg')
                              : FileImage(File(_image!.path))
                                  as ImageProvider<Object>?,
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
                            borrowDateCtr.text = Calculator.dateTimeToString(
                                _selectedBorrowDate);
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
                              lastDate:
                                  DateTime.now().add(Duration(days: 365)));
                          if (_selectedReturnDate != null) {
                            returnDateCtr.text = Calculator.dateTimeToString(
                                _selectedReturnDate);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: Text('ÖDÜNÇ KAYIT EKLE'),
                    onPressed: () async {
                      BorrowInfo newBorrowInfo = BorrowInfo(
                        name: nameCtr.text,
                        surname: surnameCtr.text,
                        photoUrl:
                            photoUrl ?? 'https://i.hizliresim.com/p61ovs2.jpg',
                        borrowDate:
                            Calculator.dateTimeToTimeStamp(_selectedBorrowDate),
                        returnDate:
                            Calculator.dateTimeToTimeStamp(_selectedReturnDate),
                      );
                      // widget.book.borrows.add(newBorrowInfo);
                      // barrowBookViewModel.updateBook(
                      //     borrowList: widget.book.borrows, book: widget.book);
                      Navigator.pop(context, newBorrowInfo);
                      /* if (_pickedFile != null) {
                        photoUrl = await uploadImageToStorage(
                            _image!); //UPLOADING TO STORAGE PHOTO TAKEN. KAYIT EKLE BUTONUNA BASTIKTAN SONRA STORAGE'A KAYDETMEK BU ŞEKİLDE DAHA MANTIKLI.
                            //FAKAT FOTOĞRAFI ÇEKER ÇEKMEZ KAYDEDECEĞİM VE BOTTOMMODELSHEET KAPATILIRSA VEYA HATA VS. DURUMLARINDA STORAGE'DAN FOTOĞRAFI
                            //SİLME KONUSUNDA DA TECRÜBE KAZANACAĞIM.
                      }*/
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (photoUrl != null) {
                          context
                              .read<BarrowBookViewModel>()
                              .deletePhoto(photoUrl!);
                        }
                        Navigator.pop(context);
                      },
                      child: Text("IPTAL ET"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
