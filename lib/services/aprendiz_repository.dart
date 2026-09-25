import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/aprendiz.dart';

class AprendizRepository {
  final _db = Supabase.instance.client;
  static const _select = '*, departamento:departamentos(nombre), ciudad:ciudades(nombre)';

  Future<List<Aprendiz>> listar() async {
    final rows = await _db.from('aprendiz').select(_select).order('primer_apellido');
    return rows.map((e) => Aprendiz.fromMap(e)).toList();
  }
  Future<Aprendiz?> buscarPorId(String id) async {
    final row = await _db.from('aprendiz').select(_select).eq('id', id.trim()).maybeSingle();
    return row == null ? null : Aprendiz.fromMap(row);
  }
  Future<void> crear(Aprendiz a) async => _db.from('aprendiz').insert(a.toMap());
  Future<void> actualizar(Aprendiz a) async => _db.from('aprendiz').update(a.toMap()..remove('id')).eq('id', a.id);
  Future<void> eliminar(String id) async => _db.from('aprendiz').delete().eq('id', id);
}
