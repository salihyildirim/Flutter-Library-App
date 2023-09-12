import 'package:intl/intl.dart';

class Calculator{

//DateTime ---> String'e formatla
  static String dateTimeToString(DateTime dateTime){

    return DateFormat("dd-MM-yyyy").format(dateTime);
  }
}