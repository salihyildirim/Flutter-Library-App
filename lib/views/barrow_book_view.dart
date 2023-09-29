import 'package:flutter/material.dart';
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
    return ChangeNotifierProvider<BarrowBookViewModel>( create: (context)=> BarrowBookViewModel(),
      builder: (context,_)=> Scaffold(
          appBar: AppBar(
              title: Text('${widget.book.bookName.toUpperCase()} Ödünç Listesi'),
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
                          //backgroundImage: NetworkImage(''),
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
                        backgroundImage: NetworkImage(
                            'https://i.hizliresim.com/p61ovs2.jpg'),
                      ),
                      Positioned(
                          bottom: -5,
                          right: -10,
                          child: IconButton(
                            icon: Icon(Icons.photo_camera_rounded),
                            onPressed: () {},
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
                        Calculator.dateTimeToTimeStamp(_selectedReturnDate));
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
