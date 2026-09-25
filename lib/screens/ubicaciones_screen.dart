import 'package:flutter/material.dart';
import '../models/ciudad.dart';
import '../models/departamento.dart';
import '../services/ciudad_repository.dart';
import '../services/departamento_repository.dart';

class UbicacionesScreen extends StatefulWidget {
  const UbicacionesScreen({super.key, required this.isAdmin});
  final bool isAdmin;
  @override
  State<UbicacionesScreen> createState() => _UbicacionesScreenState();
}

class _UbicacionesScreenState extends State<UbicacionesScreen> {
  final _departamentoRepo = DepartamentoRepository();
  final _ciudadRepo = CiudadRepository();
  List<Departamento> _departamentos = [];
  List<Ciudad> _ciudades = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await Future.wait([_departamentoRepo.listar(), _ciudadRepo.listar()]);
      if (mounted) setState(() { _departamentos = result[0] as List<Departamento>; _ciudades = result[1] as List<Ciudad>; _loading = false; });
    } catch (e) { if (mounted) setState(() { _error = _errorMessage(e); _loading = false; }); }
  }

  Future<void> _departmentForm({Departamento? item}) async {
    final form = GlobalKey<FormState>();
    final name = TextEditingController(text: item?.nombre);
    final value = await showDialog<String>(context: context, builder: (context) => AlertDialog(
      title: Text(item == null ? 'Nuevo departamento' : 'Editar departamento'),
      content: SizedBox(width: 420, child: Form(key: form, child: TextFormField(controller: name, autofocus: true, maxLength: 100, decoration: const InputDecoration(labelText: 'Nombre del departamento', border: OutlineInputBorder()), validator: _validateName, onFieldSubmitted: (_) { if (form.currentState!.validate()) Navigator.pop(context, name.text.trim()); }))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { if (form.currentState!.validate()) Navigator.pop(context, name.text.trim()); }, child: const Text('Guardar'))],
    ));
    if (value == null) return;
    try { if (item == null) { await _departamentoRepo.crear(value); } else { await _departamentoRepo.actualizar(item.id, value); } await _load(); _toast(item == null ? 'Departamento agregado.' : 'Departamento actualizado.'); }
    catch (e) { _toast(_errorMessage(e), error: true); }
  }

  Future<void> _cityForm({Ciudad? item}) async {
    if (_departamentos.isEmpty) { _toast('Primero agrega un departamento.', error: true); return; }
    final form = GlobalKey<FormState>();
    final name = TextEditingController(text: item?.nombre);
    var departmentId = item?.departamentoId ?? _departamentos.first.id;
    final value = await showDialog<(String, int)>(context: context, builder: (context) => StatefulBuilder(builder: (context, setDialog) => AlertDialog(
      title: Text(item == null ? 'Nueva ciudad o municipio' : 'Editar ciudad o municipio'),
      content: SizedBox(width: 430, child: Form(key: form, child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: name, autofocus: true, maxLength: 100, decoration: const InputDecoration(labelText: 'Nombre de ciudad o municipio', border: OutlineInputBorder()), validator: _validateName),
        const SizedBox(height: 14),
        DropdownButtonFormField<int>(initialValue: departmentId, isExpanded: true, decoration: const InputDecoration(labelText: 'Departamento', border: OutlineInputBorder()), items: _departamentos.map((d) => DropdownMenuItem(value: d.id, child: Text(d.nombre, overflow: TextOverflow.ellipsis))).toList(), onChanged: (value) { if (value != null) setDialog(() => departmentId = value); }),
      ]))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () { if (form.currentState!.validate()) Navigator.pop(context, (name.text.trim(), departmentId)); }, child: const Text('Guardar'))],
    )));
    if (value == null) return;
    try {
      if (item == null) { await _ciudadRepo.crear(nombre: value.$1, departamentoId: value.$2); }
      else { await _ciudadRepo.actualizar(id: item.id, nombre: value.$1, departamentoId: value.$2); }
      await _load(); _toast(item == null ? 'Ciudad agregada.' : 'Ciudad actualizada.');
    } catch (e) { _toast(_errorMessage(e), error: true); }
  }

  Future<void> _deleteDepartment(Departamento item) async {
    final ok = await _confirm('Eliminar departamento', '¿Eliminar “${item.nombre}”? Solo se podrá borrar si no tiene aprendices asociados. Sus ciudades relacionadas también se eliminarán.');
    if (!ok) return;
    try { await _departamentoRepo.eliminar(item.id); await _load(); _toast('Departamento eliminado.'); }
    catch (e) { _toast(_errorMessage(e), error: true); }
  }
  Future<void> _deleteCity(Ciudad item) async {
    final ok = await _confirm('Eliminar ciudad', '¿Eliminar “${item.nombre}”? No se podrá borrar si tiene aprendices asociados.');
    if (!ok) return;
    try { await _ciudadRepo.eliminar(item.id); await _load(); _toast('Ciudad eliminada.'); }
    catch (e) { _toast(_errorMessage(e), error: true); }
  }
  Future<bool> _confirm(String title, String message) async => await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar'))])) ?? false;
  void _toast(String message, {bool error = false}) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: error ? Colors.red.shade800 : null, content: Text(message))); }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 720;
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(title: const Text('Departamentos y ciudades'), actions: [IconButton(tooltip: 'Actualizar', onPressed: _load, icon: const Icon(Icons.refresh)), const SizedBox(width: 8)], bottom: const TabBar(tabs: [Tab(text: 'Departamentos', icon: Icon(Icons.map_outlined)), Tab(text: 'Ciudades', icon: Icon(Icons.location_city_outlined))])),
      body: _loading ? const Center(child: CircularProgressIndicator()) : _error != null ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(_error!, textAlign: TextAlign.center), TextButton(onPressed: _load, child: const Text('Reintentar'))]))) : TabBarView(children: [_departmentTab(compact), _cityTab(compact)]),
    ));
  }

  Widget _departmentTab(bool compact) => _catalogPage(
    title: 'Departamentos', subtitle: '${_departamentos.length} registrados',
    onAdd: widget.isAdmin ? () => _departmentForm() : null,
    empty: 'Todavía no hay departamentos registrados.',
    children: _departamentos.map((d) => _locationTile(title: d.nombre, subtitle: 'Código ${d.id}', onEdit: widget.isAdmin ? () => _departmentForm(item: d) : null, onDelete: widget.isAdmin ? () => _deleteDepartment(d) : null)).toList(), compact: compact,
  );

  Widget _cityTab(bool compact) => _catalogPage(
    title: 'Ciudades y municipios', subtitle: '${_ciudades.length} registrados',
    onAdd: widget.isAdmin ? () => _cityForm() : null,
    empty: 'Todavía no hay ciudades registradas.',
    children: _ciudades.map((c) { final dep = _departamentos.where((d) => d.id == c.departamentoId).firstOrNull; return _locationTile(title: c.nombre, subtitle: '${dep?.nombre ?? 'Departamento ${c.departamentoId}'} · Código ${c.id}', onEdit: widget.isAdmin ? () => _cityForm(item: c) : null, onDelete: widget.isAdmin ? () => _deleteCity(c) : null); }).toList(), compact: compact,
  );

  Widget _catalogPage({required String title, required String subtitle, required String empty, required List<Widget> children, required bool compact, VoidCallback? onAdd}) => ListView(padding: EdgeInsets.all(compact ? 16 : 32), children: [
    Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Colors.black54))])), if (onAdd != null) FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: Text(compact ? 'Agregar' : 'Agregar'))]),
    const SizedBox(height: 16),
    if (children.isEmpty) Card(color: Colors.white, child: Padding(padding: const EdgeInsets.all(32), child: Center(child: Text(empty)))) else ...children,
  ]);

  Widget _locationTile({required String title, required String subtitle, VoidCallback? onEdit, VoidCallback? onDelete}) => Card(color: Colors.white, child: ListTile(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(subtitle), trailing: onEdit == null ? null : Wrap(children: [IconButton(tooltip: 'Editar', onPressed: onEdit, icon: const Icon(Icons.edit_outlined)), IconButton(tooltip: 'Eliminar', onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Colors.red))])));
}

String? _validateName(String? value) => value == null || value.trim().isEmpty ? 'Escribe un nombre.' : null;
String _errorMessage(Object error) {
  final text = error.toString();
  if (text.contains('23505') || text.toLowerCase().contains('duplicate')) return 'Ya existe un registro con ese nombre.';
  if (text.contains('23503') || text.toLowerCase().contains('foreign key')) return 'No se puede eliminar: hay aprendices asociados a esta ubicación.';
  if (text.contains('42501') || text.toLowerCase().contains('permission denied')) return 'Solo un administrador puede modificar este catálogo. Ejecuta la actualización RLS incluida en docs/supabase_auth_setup.sql.';
  return 'No se pudo guardar el cambio. $text';
}
