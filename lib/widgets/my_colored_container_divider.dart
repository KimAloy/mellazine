import 'package:flutter/material.dart';

Widget myColoredContainerDivider({Color? color,double? height}) {
  return Container(
    height: height??5,
    width: double.infinity,
    color: color?? Colors.grey.shade200,
  );
}
