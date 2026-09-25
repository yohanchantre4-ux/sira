class PerfilUsuario {
  const PerfilUsuario({required this.id, required this.email, required this.role});
  final String id, email, role;
  factory PerfilUsuario.fromMap(Map<String, dynamic> m) => PerfilUsuario(
    id: m['id'] as String, email: (m['email'] as String?) ?? '', role: m['role'] as String);
}
