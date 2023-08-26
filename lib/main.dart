import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../repository/my_object_box.dart';
late MyObjectBox myObjectBox;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  myObjectBox = await MyObjectBox.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mellazine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      // home: const HomePage(),
      home: const BottomNavBar(),
    );
  }
}

