import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/electrodomestico_model.dart';
import 'package:flutter_application_2/services/mongo_service.dart';
import 'package:flutter_application_2/screens/insert_electrodomestico.dart'; // Asegúrate de importar InsertElectrodomesticoScreen
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ElectrodomesticoScreen extends StatefulWidget {
  const ElectrodomesticoScreen({super.key});

  @override
  State<ElectrodomesticoScreen> createState() => _ElectrodomesticoScreenState();
}

class _ElectrodomesticoScreenState extends State<ElectrodomesticoScreen> {
  List<ElectrodomesticoModel> electrodomesticos = [];
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
    _fetchElectrodomesticos();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _marcaController.dispose();
    _existenciaController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Electrodomésticos'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () async {
                // Navegar a la pantalla de inserción de electrodoméstico
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InsertElectrodomesticoScreen(),
                  ),
                );
                // Actualizar la lista de electrodomésticos después de regresar de la pantalla de inserción
                _fetchElectrodomesticos();
              },
              child: const Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: electrodomesticos.length,
        itemBuilder: (context, index) {
          var electrodomestico = electrodomesticos[index];
          return oneTitle(electrodomestico);
        },
      ),
    );
  }

  void _fetchElectrodomesticos() async {
    electrodomesticos = await MongoService().getElectrodomesticos();
    print('En fetch $electrodomesticos');
    setState(() {});
  }

  void _deleteElectrodomestico(mongo.ObjectId id) async {
    await MongoService().deleteElectrodomestico(id);
    _fetchElectrodomesticos();
  }

  void _updateElectrodomestico(ElectrodomesticoModel electrodomestico) async {
    await MongoService().updateElectrodomestico(electrodomestico);
    _fetchElectrodomesticos();
  }

  void _showEditDialog(ElectrodomesticoModel electrodomestico) {
    _nombreController.text = electrodomestico.nombre;
    _marcaController.text = electrodomestico.marca;
    _existenciaController.text = electrodomestico.existencia.toString();
    _precioController.text = electrodomestico.precio.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Electrodoméstico'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                decoration: const InputDecoration(labelText: 'Existencia'),
              ),
              TextField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                electrodomestico.nombre = _nombreController.text;
                electrodomestico.marca = _marcaController.text;
                electrodomestico.existencia =
                    int.parse(_existenciaController.text);
                electrodomestico.precio = double.parse(_precioController.text);
                _updateElectrodomestico(electrodomestico);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  ListTile oneTitle(ElectrodomesticoModel electrodomestico) {
    return ListTile(
      leading: const Icon(Icons.kitchen),
      title: Text(
        electrodomestico.nombre,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(electrodomestico.marca),
          Text('Existencia: ${electrodomestico.existencia}'),
          Text('Precio: ${electrodomestico.precio}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showEditDialog(electrodomestico),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _deleteElectrodomestico(electrodomestico.id);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
