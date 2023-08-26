import 'package:flutter/material.dart';

class MyMellazinePage extends StatefulWidget {
  const MyMellazinePage({Key? key}) : super(key: key);

  @override
  State<MyMellazinePage> createState() => _MyMellazinePageState();
}

class _MyMellazinePageState extends State<MyMellazinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('My Mellaxine'),),);
  }
}
