import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../models/borrow_model.dart';

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
    return Scaffold(
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
                          context: context,
                          builder: (BuildContext context) {
                            return BorrowForm();
                          });
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Yeni Ödünç',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  height: 80,
                  color: Colors.blueAccent,
                ),
              ),
            )
          ],
        ));
  }
}

class BorrowForm extends StatefulWidget {
  const BorrowForm({super.key});

  @override
  State<BorrowForm> createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  TextEditingController nameCtr= TextEditingController();
  TextEditingController surnameCtr= TextEditingController();
  TextEditingController borrowDateCtr= TextEditingController();
  TextEditingController returnDateCtr= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      child: Form(
        key: GlobalKey<FormState>(),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://i.hizliresim.com/p61ovs2.jpg'),
                    ),
                    Positioned(
                        bottom: -5,
                        right: -10,
                        child: IconButton(
                          icon: Icon(Icons.photo_camera_rounded),
                          onPressed: () {},
                        ))
                  ],
                ),TextFormField(controller: nameCtr,decoration: InputDecoration(hintText: 'Ad',),validator: (value){
                  if(value == null ||value.isEmpty){
                    return 'Ad Giriniz';
                  }
                  else{
                    return null;
                  }
                },),
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
            )

          ],
        ),
      ),
    );
  }
}
