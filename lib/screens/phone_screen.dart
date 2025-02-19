import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/phone_model.dart';
import 'package:flutter_application_2/services/mongo_service.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  List<PhoneModel> phones = [];

  @override
  void initState() {
    super.initState();
    _fetchPhones();
  }

  @override
  void dispose() {
//Destruir está screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de telefonos'),
      ),
      body: ListView.builder(
          itemCount: phones.length,
          itemBuilder: (context, index) {
            var phone = phones[index];
            return oneTitle(phone);
          }),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar telefono'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: phone.marca),
                decoration: const InputDecoration(labelText: 'Marca'),
                onChanged: (value) {
                  phone.marca = value;
                },
              ),
              TextField(
                controller: TextEditingController(text: phone.modelo),
                decoration: const InputDecoration(labelText: 'Modelo'),
                onChanged: (value) {
                  phone.modelo = value;
                },
              ),
              TextField(
                controller:
                    TextEditingController(text: phone.existencia.toString()),
                decoration: const InputDecoration(labelText: 'Existencia'),
                onChanged: (value) {
                  phone.existencia = int.parse(value);
                },
              ),
              TextField(
                controller:
                    TextEditingController(text: phone.precio.toString()),
                decoration: const InputDecoration(labelText: 'Precio'),
                onChanged: (value) {
                  phone.precio = double.parse(value);
                },
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
        title: Text(phone.marca),
        subtitle: Text(phone.modelo),
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
        ));
  }
}
