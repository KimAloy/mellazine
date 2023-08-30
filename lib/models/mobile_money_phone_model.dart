import 'package:objectbox/objectbox.dart';

@Entity()
class MobileMoneyPhoneModel {
  int id;
  String phoneNumber;

  MobileMoneyPhoneModel({this.id = 0, required this.phoneNumber});
}
