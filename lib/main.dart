import 'package:edu_master_special_links/special_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SpecialLinksApp());
}

class SpecialLinksApp extends StatelessWidget {
  const SpecialLinksApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpecialLinks(),
    );
  }
}
