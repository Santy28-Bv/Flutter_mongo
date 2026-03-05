import 'dart:io';
import 'package:flutter_application_2/models/phone_model.dart';
import 'package:flutter_application_2/models/electrodomestico_model.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class MongoService {
  static final MongoService _instance = MongoService._internal();
  MongoService._internal();
  factory MongoService() => _instance;

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
          'Base de datos no inicializada, llama a connect() primero');
    }
    return _db;
  }

  // 🔹 MÉTODOS PARA CELULARES (EXISTENTES)
  Future<List<PhoneModel>> getPhones() async {
    final collection = _db.collection('celulares');
    var phones = await collection.find().toList();
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
    final collection = _db.collection('celulares');
    await collection.deleteOne(mongo.where.eq('_id', id));
  }

  // 🔹 NUEVOS MÉTODOS PARA ELECTRODOMÉSTICOS
  Future<List<ElectrodomesticoModel>> getElectrodomesticos() async {
    final collection = _db.collection('electrodomesticos');
    var electrodomesticos = await collection.find().toList();
    return electrodomesticos
        .map((electro) => ElectrodomesticoModel.fromJson(electro))
        .toList();
  }

  Future<void> insertElectrodomestico(
      ElectrodomesticoModel electrodomestico) async {
    final collection = _db.collection('electrodomesticos');
    await collection.insertOne(electrodomestico.toJson());
  }

  Future<void> updateElectrodomestico(
      ElectrodomesticoModel electrodomestico) async {
    final collection = _db.collection('electrodomesticos');
    await collection.updateOne(
        mongo.where.eq('_id', electrodomestico.id),
        mongo.modify
            .set('nombre', electrodomestico.nombre)
            .set('marca', electrodomestico.marca)
            .set('existencia', electrodomestico.existencia)
            .set('precio', electrodomestico.precio));
  }

  Future<void> deleteElectrodomestico(mongo.ObjectId id) async {
    final collection = _db.collection('electrodomesticos');
    await collection.deleteOne(mongo.where.eq('_id', id));
  }
}
