import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../widgets/my_colored_container_divider.dart';
import '../widgets/security_sustainability_widget.dart';

class CreditCardPaymentPage extends StatefulWidget {
  const CreditCardPaymentPage({Key? key}) : super(key: key);

  @override
  State<CreditCardPaymentPage> createState() => _CreditCardPaymentPageState();
}

class _CreditCardPaymentPageState extends State<CreditCardPaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool rememberThisCard = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Payment'),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _creditCardWidget(),
              _creditCardForm(),
              const SizedBox(height: 10),
              _myPaddedWidget(child: _rememberCard()),
              const SizedBox(height: 10),
              myColoredContainerDivider(),
              const SizedBox(height: 10),
              _myPaddedWidget(
                child: Column(
                  children: [
                    _orderInfo(title: 'Item(s) total:', cost: '\$10.42'),
                    _orderInfo(
                      title: '30% off coupon applied:',
                      cost: '\$10.42',
                      color: Colors.red,
                    ),
                    _orderInfo(title: 'Subtotal:', cost: '\$10.42'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _myPaddedWidget(
                child: Column(
                  children: [
                    _orderInfo(title: 'Shipping:', cost: 'FREE'),
                    _orderInfo(title: 'Sales tax:', cost: '\$0.60'),
                    _orderInfo(title: 'Order total:', cost: '\$7.90'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildShoppingSecurity(context: context),
              const SizedBox(height: 20),
              _myPaddedWidget(
                child: FilledButton.icon(
                  onPressed: _onValidate,
                  icon: const Icon(Icons.lock_outline_rounded),
                  label: const Text('Submit order'),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState!.validate()) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Widget _rememberCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Remember this card for future use',
        ),
        SizedBox(
          height: 30,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Switch(
              value: rememberThisCard,
              activeTrackColor: Colors.deepOrange,
              onChanged: (bool value) => setState(() {
                rememberThisCard = value;
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _creditCardWidget() {
    return CreditCardWidget(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      // bankName: 'Axis Bank',
      bankName: '.',
      // don't delete, it helps with vertical padding
      showBackView: isCvvFocused,
      obscureCardNumber: false,
      obscureCardCvv: false,
      isHolderNameVisible: true,
      cardBgColor: Theme.of(context).colorScheme.primary,
      isSwipeGestureEnabled: true,
      onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
    );
  }

  _creditCardForm() {
    Color themeColor = Colors.black54;
    OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 1.0,
    ));
    return CreditCardForm(
      formKey: formKey,
      // obscureCvv: true,
      // obscureNumber: true,
      cardNumber: cardNumber,
      cvvCode: cvvCode,
      isHolderNameVisible: true,
      isCardNumberVisible: true,
      isExpiryDateVisible: true,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
      themeColor: themeColor,
      // textColor: Colors.white,
      cardNumberDecoration: InputDecoration(
        labelText: '*Number',
        hintText: 'XXXX XXXX XXXX XXXX',
        hintStyle: TextStyle(color: themeColor),
        labelStyle: TextStyle(color: themeColor),
        focusedBorder: border,
        enabledBorder: border,
        border: border,
      ),
      expiryDateDecoration: InputDecoration(
        hintStyle: TextStyle(color: themeColor),
        labelStyle: TextStyle(color: themeColor),
        focusedBorder: border,
        enabledBorder: border,
        border: border,
        labelText: '*Expiration Date',
        hintText: 'XX/XX',
      ),
      cvvCodeDecoration: InputDecoration(
        suffixIcon: const Icon(Icons.lock_outline_rounded),
        hintStyle: TextStyle(color: themeColor),
        labelStyle: TextStyle(color: themeColor),
        focusedBorder: border,
        enabledBorder: border,
        border: border,
        labelText: '*CVV',
        hintText: 'XXX',
      ),
      cardHolderDecoration: InputDecoration(

        hintStyle: TextStyle(color: themeColor),
        labelStyle: TextStyle(color: themeColor),
        focusedBorder: border,
        enabledBorder: border,
        border: border,
        labelText: 'Card Holder (optional)',
      ),
      onCreditCardModelChange: onCreditCardModelChange,
    );
  }

  Widget _myPaddedWidget({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }

  Widget _orderInfo({
    Color? color,
    required String title,
    required String cost,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          cost,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
