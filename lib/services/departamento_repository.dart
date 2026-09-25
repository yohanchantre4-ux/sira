import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/departamento.dart';

class DepartamentoRepository {
  final _db = Supabase.instance.client;
  Future<List<Departamento>> listar() async {
    final rows = await _db.from('departamentos').select().order('nombre');
    return rows.map((e) => Departamento.fromMap(e)).toList();
  }

  Future<void> crear(String nombre) async => _db.from('departamentos').insert({'nombre': nombre.trim()});
  Future<void> actualizar(int id, String nombre) async => _db.from('departamentos').update({'nombre': nombre.trim()}).eq('id', id);
  Future<void> eliminar(int id) async => _db.from('departamentos').delete().eq('id', id);
}
