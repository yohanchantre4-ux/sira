class Aprendiz {
  const Aprendiz({required this.id, required this.primerNombre,
    this.segundoNombre, required this.primerApellido, this.segundoApellido,
    required this.genero, required this.fechaNacimiento,
    required this.departamentoId, required this.ciudadId,
    this.departamentoNombre, this.ciudadNombre, this.createdAt, this.updatedAt});
  final String id, primerNombre, primerApellido, genero;
  final String? segundoNombre, segundoApellido;
  final DateTime fechaNacimiento;
  final int departamentoId, ciudadId;
  final String? departamentoNombre, ciudadNombre;
  final DateTime? createdAt, updatedAt;

  String get nombreCompleto => [primerNombre, segundoNombre, primerApellido, segundoApellido]
      .whereType<String>().where((s) => s.trim().isNotEmpty).join(' ');

  factory Aprendiz.fromMap(Map<String, dynamic> m) => Aprendiz(
    id: m['id'] as String, primerNombre: m['primer_nombre'] as String,
    segundoNombre: m['segundo_nombre'] as String?,
    primerApellido: m['primer_apellido'] as String,
    segundoApellido: m['segundo_apellido'] as String?, genero: m['genero'] as String,
    fechaNacimiento: DateTime.parse(m['fecha_nacimiento'] as String),
    departamentoId: (m['departamento_id'] as num).toInt(),
    ciudadId: (m['ciudad_id'] as num).toInt(),
    departamentoNombre: m['departamento'] is Map ? m['departamento']['nombre'] as String? : null,
    ciudadNombre: m['ciudad'] is Map ? m['ciudad']['nombre'] as String? : null,
    createdAt: m['created_at'] == null ? null : DateTime.parse(m['created_at'] as String),
    updatedAt: m['updated_at'] == null ? null : DateTime.parse(m['updated_at'] as String));

  Map<String, dynamic> toMap() => {
    'id': id.trim(), 'primer_nombre': primerNombre.trim(),
    'segundo_nombre': _nullable(segundoNombre), 'primer_apellido': primerApellido.trim(),
    'segundo_apellido': _nullable(segundoApellido), 'genero': genero,
    'fecha_nacimiento': fechaNacimiento.toIso8601String().split('T').first,
    'departamento_id': departamentoId, 'ciudad_id': ciudadId};

  static String? _nullable(String? value) => value == null || value.trim().isEmpty ? null : value.trim();
}
