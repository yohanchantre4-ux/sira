class Departamento {
  const Departamento({required this.id, required this.nombre});
  final int id;
  final String nombre;

  factory Departamento.fromMap(Map<String, dynamic> map) => Departamento(
    id: (map['id'] as num).toInt(), nombre: map['nombre'] as String);
}
