import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/electrodomestico_model.dart';
import 'package:flutter_application_2/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class InsertElectrodomesticoScreen extends StatefulWidget {
  const InsertElectrodomesticoScreen({super.key});

  @override
  State<InsertElectrodomesticoScreen> createState() =>
      _InsertElectrodomesticoScreenState();
}

class _InsertElectrodomesticoScreenState
    extends State<InsertElectrodomesticoScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _marcaController;
  late TextEditingController _existenciaController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _marcaController = TextEditingController();
    _existenciaController = TextEditingController();
    _precioController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _marcaController.dispose();
    _existenciaController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _insertElectrodomestico() async {
    var electrodomestico = ElectrodomesticoModel(
      id: mongo.ObjectId(),
      nombre: _nombreController.text,
      marca: _marcaController.text,
      existencia: int.parse(_existenciaController.text),
      precio: double.parse(_precioController.text),
    );

    await MongoService().insertElectrodomestico(electrodomestico);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insertar Electrodoméstico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _marcaController,
              decoration: const InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              controller: _existenciaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Existencia'),
            ),
            TextField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _insertElectrodomestico,
              child: const Text('Insertar'),
            ),
          ],
        ),
      ),
    );
  }
}
