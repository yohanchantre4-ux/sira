class Ciudad {
  const Ciudad({required this.id, required this.departamentoId, required this.nombre});
  final int id;
  final int departamentoId;
  final String nombre;

  factory Ciudad.fromMap(Map<String, dynamic> map) => Ciudad(
    id: (map['id'] as num).toInt(),
    departamentoId: (map['departamento_id'] as num).toInt(),
    nombre: map['nombre'] as String);
}
