import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentSuccessfulPage extends StatelessWidget {
  const PaymentSuccessfulPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Successful'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Payment successful!',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Confirmation and shipment updates will be sent to:',
                style: TextStyle(fontSize: 13.5),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                Icon(Icons.phone_android, color: Colors.blue.shade900),
                const Text(
                  // todo: replace email address with correct address
                  ' WhatsApp / SMS: +256789456258',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email_outlined, color: Colors.red),
                Text(
                  // todo: replace email address with correct address
                  ' Email: aloysiuskimbowa@gmail.com ',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Row(
              children: [
                Icon(Icons.room_outlined),
                // todo replace name with correct name
                Text(
                  ' Ship to:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                // todo: FutureTodo: uncomment and implement
                // const Spacer(),
                // GestureDetector(
                //   onTap: (){
                //     // todo: navigate to address page
                //     print('payment_successful_page: change address');
                //   },
                //   child: const Row(
                //     children: [
                //
                //   Text(
                //     'Change address',
                //     style: TextStyle(color: Colors.deepOrange),
                //   ),
                //   Icon(
                //     Icons.keyboard_arrow_right_rounded,
                //     color: Colors.deepOrange,
                //   ),
                //     ],
                //   ),
                // )
              ],
            ),
            const SizedBox(height: 10),
            const Text(
                ' Kimbowa Aloysius add shipping address from previous page'),
          ],
        ),
      ),
    );
  }
}
