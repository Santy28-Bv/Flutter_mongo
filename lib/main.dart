import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/phone_screen.dart';
import 'package:flutter_application_2/services/mongo_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoService().connect();
  print('Conexión a MongoDB establecida.');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhoneScreen(),
    );
  }
}
