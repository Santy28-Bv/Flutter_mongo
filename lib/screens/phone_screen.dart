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

  ListTile oneTitle(PhoneModel phone) {
    return ListTile(
        title: Text(phone.marca),
        subtitle: Text(phone.modelo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.edit),
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
