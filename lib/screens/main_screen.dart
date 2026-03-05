import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/phone_screen.dart';
import 'package:flutter_application_2/screens/electrodomestico_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de productos'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PhoneScreen(),
                ),
              );
            },
            child: const Text('Celulares'),
          ),
          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ElectrodomesticoScreen(),
                ),
              );
            },
            child: const Text('Electrodomésticos'),
          ),
        ],
      ),
    );
  }
}
