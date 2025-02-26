import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/phone_model.dart';
import 'package:flutter_application_2/services/mongo_service.dart';
import 'package:flutter_application_2/screens/insert_phone_screen.dart'; // Asegúrate de importar InsertPhoneScreen
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  List<PhoneModel> phones = [];
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _existenciaController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController();
    _modeloController = TextEditingController();
    _existenciaController = TextEditingController();
    _precioController = TextEditingController();
    _fetchPhones();
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _existenciaController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de telefonos'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () async {
                // Navegar a la pantalla de inserción de teléfono
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InsertPhoneScreen(),
                  ),
                );
                // Actualizar la lista de teléfonos después de regresar de la pantalla de inserción
                _fetchPhones();
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
        itemCount: phones.length,
        itemBuilder: (context, index) {
          var phone = phones[index];
          return oneTitle(phone);
        },
      ),
    );
  }

  void _fetchPhones() async {
    phones = await MongoService().getPhones();
    print('En fetch $phones');
    setState(() {});
  }

  void _deletePhone(mongo.ObjectId id) async {
    await MongoService().deletePhone(id);
    _fetchPhones();
  }

  void _updatePhone(PhoneModel phone) async {
    await MongoService().updatePhone(phone);
    _fetchPhones();
  }

  void _showEditDialog(PhoneModel phone) {
    _marcaController.text = phone.marca;
    _modeloController.text = phone.modelo;
    _existenciaController.text = phone.existencia.toString();
    _precioController.text = phone.precio.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar telefono'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
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
                phone.marca = _marcaController.text;
                phone.modelo = _modeloController.text;
                phone.existencia = int.parse(_existenciaController.text);
                phone.precio = double.parse(_precioController.text);
                _updatePhone(phone);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  ListTile oneTitle(PhoneModel phone) {
    return ListTile(
      leading: const Icon(Icons.phone_android),
      title: Text(
        phone.marca,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(phone.modelo),
          Text('existencia: ${phone.existencia}'),
          Text('precio: ${phone.precio}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _showEditDialog(phone),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _deletePhone(phone.id);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
