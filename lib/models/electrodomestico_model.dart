import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ElectrodomesticoModel {
  final mongo.ObjectId id;
  String nombre;
  String marca;
  int existencia;
  double precio;

  ElectrodomesticoModel({
    required this.id,
    required this.nombre,
    required this.marca,
    required this.existencia,
    required this.precio,
  });

  // Convertir un objeto a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'marca': marca,
      'existencia': existencia,
      'precio': precio,
    };
  }

  // Crear un objeto desde un JSON
  factory ElectrodomesticoModel.fromJson(Map<String, dynamic> json) {
    return ElectrodomesticoModel(
      id: json['_id'] is mongo.ObjectId
          ? json['_id'] as mongo.ObjectId
          : mongo.ObjectId(),
      nombre: json['nombre'] as String? ?? 'Desconocido',
      marca: json['marca'] as String? ?? 'Sin marca',
      existencia: json['existencia'] is int
          ? json['existencia']
          : int.tryParse(json['existencia'].toString()) ?? 0,
      precio: json['precio'] is double
          ? json['precio']
          : double.tryParse(json['precio'].toString()) ?? 0.0,
    );
  }
}
