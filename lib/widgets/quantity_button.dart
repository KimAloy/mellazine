import 'package:flutter/material.dart';

Widget changeQuantity({
  required double padding,
  double? iconSize,
  required BuildContext context,
  required int quantity,
  int? objectBoxId,
  required Function()? reduce,
  required Function()? increase,
}) {
  final myColorTheme = Theme.of(context).colorScheme;

  return Material(
    elevation: 1,
    borderRadius: BorderRadius.circular(5),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: myColorTheme.inversePrimary.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _quantityButton(
            padding: padding,
            iconSize: iconSize,
            context: context,
            onPressed: reduce,
            icon: Icons.remove,
          ),
          const SizedBox(width: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 6),
          _quantityButton(
            padding: padding,
            iconSize: iconSize,
            onPressed: increase,
            icon: Icons.add,
            context: context,
          ),
        ],
      ),
    ),
  );
}

Widget _quantityButton({
  double padding = 8.0,
  double? iconSize,
  required Function()? onPressed,
  required IconData icon,
  required BuildContext context,
}) {
  final myColorTheme = Theme.of(context).colorScheme;
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
        color: myColorTheme.inversePrimary.withOpacity(0.4),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Center(
          child: Icon(
            icon,
            color: myColorTheme.primary,
            size: iconSize,
          ),
        ),
      ),
    ),
  );
}
