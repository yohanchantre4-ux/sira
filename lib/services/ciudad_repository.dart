import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ciudad.dart';

class CiudadRepository {
  final _db = Supabase.instance.client;
  Future<List<Ciudad>> listar() async {
    final rows = await _db.from('ciudades').select().order('nombre');
    return rows.map((e) => Ciudad.fromMap(e)).toList();
  }

  Future<void> crear({required String nombre, required int departamentoId}) async =>
      _db.from('ciudades').insert({'nombre': nombre.trim(), 'departamento_id': departamentoId});
  Future<void> actualizar({required int id, required String nombre, required int departamentoId}) async =>
      _db.from('ciudades').update({'nombre': nombre.trim(), 'departamento_id': departamentoId}).eq('id', id);
  Future<void> eliminar(int id) async => _db.from('ciudades').delete().eq('id', id);
}
