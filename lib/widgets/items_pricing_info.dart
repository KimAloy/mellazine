import 'package:flutter/material.dart';

Widget itemsPricingInfo() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        // todo: replace values with data from riverpod
        _orderInfo(title: 'Item(s) total:', cost: '\$10.42'),
        _orderInfo(
          title: '30% off coupon applied:',
          cost: '\$10.42',
          color: Colors.red,
        ),
        _orderInfo(title: 'Subtotal:', cost: '\$10.42'),
        const SizedBox(height: 10),
        Column(
          children: [
            _orderInfo(title: 'Shipping:', cost: 'FREE'),
            _orderInfo(title: 'Sales tax:', cost: '\$0.60'),
            _orderInfo(title: 'Order total:', cost: '\$7.90'),
          ],
        ),
      ],
    ),
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
