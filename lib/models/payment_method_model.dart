import 'package:mellazine/constants/constants.dart';

class PaymentMethodModel {
  final String name;
  final String image;
  String? subTitle;
  final String type;

  PaymentMethodModel({
    required this.name,
    required this.image,
    required this.type,
    this.subTitle,
  });
}

List<PaymentMethodModel> paymentMethodsList = [
  // todo: flip airtel and mtn to bottom in the near future
  PaymentMethodModel(
    name: 'Airtel',
    image: 'assets/payment_methods/airtel.png',
    type: kMobileMoney,
  ),
  PaymentMethodModel(
    name: 'MTN',
    image: 'assets/payment_methods/mtn.png',
    type: kMobileMoney,
  ),
  PaymentMethodModel(
    name: 'VISA',
    image: 'assets/payment_methods/visa.png',
    type: kCard,
  ),
  PaymentMethodModel(
    name: 'Mastercard',
    image: 'assets/payment_methods/mastercard.png',
    subTitle: 'Testing one two', // todo: delete
    type: kCard,
  ),
];
