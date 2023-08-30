import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mellazine/pages/payment_successful_page.dart';
import 'package:mellazine/widgets/items_pricing_info.dart';

import '../models/mobile_money_phone_model.dart';
import '../models/payment_method_model.dart';
import '../widgets/google_text_field.dart';
import '../widgets/my_colored_container_divider.dart';
import '../widgets/security_sustainability_widget.dart';

import '../main.dart';

class MobileMoneyPaymentPage extends StatefulWidget {
  const MobileMoneyPaymentPage({Key? key, required this.paymentMethod})
      : super(key: key);
  final PaymentMethodModel paymentMethod;

  @override
  State<MobileMoneyPaymentPage> createState() => _MobileMoneyPaymentPageState();
}

class _MobileMoneyPaymentPageState extends State<MobileMoneyPaymentPage> {
  bool rememberThisCard = true;
  bool _objectBoxPaymentCardExists = false;
  int _objectBoxCardId = 0;
  TextEditingController _phoneController = TextEditingController(text: '+256');

  @override
  void initState() {
    List<int> paymentCardIds = myObjectBox.momoExist();
    if (paymentCardIds.isNotEmpty) {
      _objectBoxPaymentCardExists = true;
      final MobileMoneyPhoneModel firstCard =
          myObjectBox.getMomoNumber(paymentCardIds[0])!;
      _objectBoxCardId = firstCard.id;
      _phoneController = TextEditingController(text: firstCard.phoneNumber);
    }
    super.initState();
  }

  String _errorMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 15),
                _buildPaymentMethodImage(),
                const SizedBox(height: 15),
                _buildPhoneTextField(),
                const SizedBox(height: 10),
                _myPaddedWidget(child: _rememberPhone()),
                const SizedBox(height: 10),
                myColoredContainerDivider(),
                const SizedBox(height: 10),
                itemsPricingInfo(),
                const SizedBox(height: 20),
                buildShoppingSecurity(context: context),
                const SizedBox(height: 20),
                _buildErrorMessage(),
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
      ),
    );
  }

  Widget _buildErrorMessage() {
    return _errorMessage.isEmpty
        ? const SizedBox.shrink()
        : Column(
            children: [
              const SizedBox(height: 4),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 4),
            ],
          );
  }

  Widget _rememberPhone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Remember this phone for future use',
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

  Widget _myPaddedWidget({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }

  void _onValidate() {
    setState(() => _errorMessage = '');
    if (_formKey.currentState!.validate()) {
      // print('valid');
      if (rememberThisCard == true) {
        final MobileMoneyPhoneModel phone =
            MobileMoneyPhoneModel(phoneNumber: _phoneController.text.trim());
        if (_objectBoxPaymentCardExists == true) {
          // update
          myObjectBox.updateMomoNumber(
            newCardInfo: phone,
            id: _objectBoxCardId,
          );
        } else {
          // create
          myObjectBox.createMomoNumber(phone);
        }
      }
      // todo: implement payment
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return const PaymentSuccessfulPage();
      }));
    } else {
      setState(() {
        _errorMessage = 'Please enter the field above';
      });
      // print('invalid!');
    }
  }

  Widget _buildPhoneTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GoogleTextField(
        autofocus: true,
        keyboardType: TextInputType.phone,
        hintText: 'Enter phone number here..',
        controller: _phoneController,
        prefixIcon: Icon(
          Icons.phone_android_outlined,
          color: Colors.blue.shade900,
        ),
        validator: (value) =>
            value.toString().length < 11 ? 'Please enter a vaild phone' : null,
      ),
    );
  }

  Widget _buildPaymentMethodImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(widget.paymentMethod.image),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.paymentMethod.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
