class PaymentMethodModel {
  final String name;
  final String image;
  String? subTitle;

  PaymentMethodModel({
    required this.name,
    required this.image,
    this.subTitle,
  });
}

List<PaymentMethodModel> paymentMethodsList = [
  // todo: flip airtel and mtn to bottom in the near future
  PaymentMethodModel(
    name: 'Airtel',
    image: 'assets/payment_methods/airtel.png',
  ),
  PaymentMethodModel(
    name: 'MTN',
    image: 'assets/payment_methods/mtn.png',
  ),
  PaymentMethodModel(
    name: 'VISA',
    image: 'assets/payment_methods/visa.png',
  ),
  PaymentMethodModel(
    name: 'Mastercard',
    image: 'assets/payment_methods/mastercard.png',
    subTitle: 'Testing one two', // todo: delete
  ),
];
