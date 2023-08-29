import 'package:objectbox/objectbox.dart';

@Entity()
class PaymentCardModel {
  int id;
   String cardNumber;
   String expirationDate;
   String cvv;
  String? cardHolder;

  PaymentCardModel({
    this.id = 0,
    required this.cardNumber,
    required this.expirationDate,
    this.cardHolder,
    required this.cvv,
  });
}
