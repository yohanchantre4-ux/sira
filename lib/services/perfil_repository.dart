import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/perfil_usuario.dart';

class PerfilRepository {
  final _db = Supabase.instance.client;
  Future<String> miRol() async {
    final user = _db.auth.currentUser;
    if (user == null) return 'operativo';
    final row = await _db.from('profiles').select('role').eq('id', user.id).maybeSingle();
    return row?['role'] as String? ?? 'operativo';
  }
  Future<List<PerfilUsuario>> listar() async {
    final rows = await _db.from('profiles').select('id,email,role').order('email');
    return rows.map((e) => PerfilUsuario.fromMap(e)).toList();
  }
  Future<void> cambiarRol(String id, String role) async => _db.from('profiles').update({'role': role}).eq('id', id);
  Future<void> crearUsuario({required String email, required String password, required String role}) async {
    await _db.functions.invoke('admin-users', body: {'action': 'create', 'email': email, 'password': password, 'role': role});
  }
}
