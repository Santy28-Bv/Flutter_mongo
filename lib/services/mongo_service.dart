import 'dart:io';

import 'package:flutter_application_2/models/phone_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoService {
  //servicio para conectar con mongodb atlas
  //usando singleton
  static final MongoService _instance = MongoService._internal();

  MongoService._internal();

  factory MongoService() {
    return _instance;
  }

  late mongo.Db _db;

  Future<void> connect() async {
    try {
      _db = await mongo.Db.create(
          'mongodb+srv://Santiago:Santi281105.@cluster0.prnfs.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
      await _db.open();
      _db.databaseName = 'productos';
      print('Conectado a la base de datos');
    } on SocketException catch (e) {
      print('Error de conexión a la base de datos: $e');
      rethrow;
    }
  }

  mongo.Db get db {
    if (!db.isConnected) {
      throw StateError(
          'Base de datos no inicializa, llama a connect() primero');
    }
    return _db;
  }

  Future<List<PhoneModel>> getPhones() async {
    final collection = _db.collection('celulares');
    print('Colección obtenida: $collection');
    var phones = await collection.find().toList();
    print('En MongoService: $phones');
    if (phones.isEmpty) {
      print('No se encontraron datos en la colección.');
    }
    return phones.map((phone) => PhoneModel.fromJson(phone)).toList();
  }

  Future<void> insertPhone(PhoneModel phone) async {
    final collection = _db.collection('celulares');
    await collection.insertOne(phone.toJson());
  }

  Future<void> updatePhone(PhoneModel phone) async {
    final collection = _db.collection('celulares');
    await collection.updateOne(
        mongo.where.eq('_id', phone.id),
        mongo.modify
            .set('marca', phone.marca)
            .set('modelo', phone.modelo)
            .set('existencia', phone.existencia)
            .set('precio', phone.precio));
  }

  Future<void> deletePhone(mongo.ObjectId id) async {
    var collection = _db.collection('celulares');
    await collection.remove(mongo.where.eq('_id', id));
  }
}
