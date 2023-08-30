import 'package:flutter/material.dart';
import 'package:mellazine/constants/constants.dart';
import 'package:mellazine/pages/credit_card_payment_page.dart';
import '../models/payment_method_model.dart';
import '../widgets/google_text_field.dart';
import 'mobile_money_payment_page.dart';

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({Key? key}) : super(key: key);

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  List<PaymentMethodModel> allPaymentMethods = paymentMethodsList;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Order confirmation'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                _infoTitle('Payment methods'),
                const SizedBox(height: 10),
                _searchWidget(),
                const SizedBox(height: 20),
                _buildPaymentMethodsListView(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchWidget() {
    return Row(
      children: [
        Expanded(
          child: GoogleTextField(
            hintText: 'Search payment method here..',
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            onChanged: (query) {
              final suggestions = paymentMethodsList.where((e) {
                final pMethod = e.name.toLowerCase();
                final input = query.toLowerCase();
                return pMethod.contains(input);
              }).toList();
              setState(() => allPaymentMethods = suggestions);
            },
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsListView() {
    return ListView.separated(
      itemCount: allPaymentMethods.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        PaymentMethodModel method = allPaymentMethods[index];
        return _buildPaymentMethod(method);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }

  Widget _buildPaymentMethod(PaymentMethodModel method) {
    return GestureDetector(
      onTap: () {
        //   print('method.name: ${method.name}');
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return method.type == kCard
              ? const CreditCardPaymentPage()
              :  MobileMoneyPaymentPage(paymentMethod: method);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
          child: Row(
            children: [
              _buildImage(method.image),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  method.subTitle == null
                      ? const SizedBox.shrink()
                      : Text(
                          method.subTitle!,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.black45,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.5),
        border: Border.all(width: 0.5, color: Colors.black12),
      ),
      child: SizedBox(
        width: 50,
        height: 30,
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }

  Widget _infoTitle(title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 3),
      ],
    );
  }
}
