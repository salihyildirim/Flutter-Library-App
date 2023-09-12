import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Calculator {
//DateTime ---> String'e formatla
  static String dateTimeToString(DateTime dateTime) {
    return DateFormat("dd-MM-yyyy").format(dateTime);
  }

//DateTime--> TimeStamp (FireBase timeStamp tanıyor.)
  static Timestamp dateTimeToTimeStamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
  //TimeStamp--> DateTime
  static DateTime dateTimeFromTimeStamp(Timestamp timestamp){
    return DateTime.fromMillisecondsSinceEpoch(timestamp.seconds*1000);
  }
}
