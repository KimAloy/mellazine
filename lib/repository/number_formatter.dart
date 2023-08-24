
import 'package:intl/intl.dart';

String numFormat({required double num}){
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  return myFormat.format(num);

}
