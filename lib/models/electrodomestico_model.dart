import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ElectrodomesticoModel {
  final mongo.ObjectId id;
  String nombre;
  String categoria;
  int stock;
  double precio;

  ElectrodomesticoModel({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.stock,
    required this.precio,
  });

  // Convertir un objeto a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'categoria': categoria,
      'stock': stock,
      'precio': precio,
    };
  }

  // Crear un objeto desde un JSON
  factory ElectrodomesticoModel.fromJson(Map<String, dynamic> json) {
    var id = json['_id'];
    if (id is String) {
      try {
        id = mongo.ObjectId.fromHexString(id);
      } catch (e) {
        id = mongo.ObjectId();
      }
    } else if (id is! mongo.ObjectId) {
      id = mongo.ObjectId();
    }

    return ElectrodomesticoModel(
      id: id as mongo.ObjectId,
      nombre: json['nombre'] as String? ?? 'Desconocido',
      categoria: json['categoria'] as String? ?? 'General',
      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse(json['stock'].toString()) ?? 0,
      precio: json['precio'] is double
          ? json['precio']
          : double.tryParse(json['precio'].toString()) ?? 0.0,
    );
  }
}
