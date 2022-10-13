import 'package:intl/intl.dart';

class Utils{


  static String calcStringToWon(String priceString){

    if(priceString == '무료나눔'){
      return priceString;
    }

    String price = NumberFormat('#,###', 'ko_KR').format(int.parse(priceString));
    return '$price원';
  }
}

