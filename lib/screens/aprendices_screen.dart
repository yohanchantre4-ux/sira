import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/aprendiz.dart';
import '../models/ciudad.dart';
import '../models/departamento.dart';
import '../services/aprendiz_repository.dart';
import '../services/ciudad_repository.dart';
import '../services/departamento_repository.dart';
import '../services/perfil_repository.dart';
import 'usuarios_screen.dart';
import 'ubicaciones_screen.dart';
import '../widgets/empty_state.dart';

const _green = Color(0xff087e68);
class AprendicesScreen extends StatefulWidget {
  const AprendicesScreen({super.key});
  @override
  State<AprendicesScreen> createState() => _AprendicesScreenState();
}

class _AprendicesScreenState extends State<AprendicesScreen> {
  final _aprendizRepo = AprendizRepository();
  final _departamentoRepo = DepartamentoRepository();
  final _ciudadRepo = CiudadRepository();
  final _perfilRepo = PerfilRepository();
  final _search = TextEditingController();
  List<Aprendiz> _rows = [];
  List<Departamento> _departamentos = [];
  List<Ciudad> _ciudades = [];
  bool _loading = true;
  bool _isAdmin = false;
  String? _error;
  String _query = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final role = await _perfilRepo.miRol();
      final values = await Future.wait([_aprendizRepo.listar(), _departamentoRepo.listar(), _ciudadRepo.listar()]);
      if (!mounted) return;
      setState(() { _isAdmin = role == 'admin'; _rows = values[0] as List<Aprendiz>; _departamentos = values[1] as List<Departamento>; _ciudades = values[2] as List<Ciudad>; _loading = false; });
    } catch (e) { if (mounted) setState(() { _error = _errorText(e); _loading = false; }); }
  }

  List<Aprendiz> get _filtered => _rows.where((a) => '${a.id} ${a.nombreCompleto} ${a.departamentoNombre} ${a.ciudadNombre}'.toLowerCase().contains(_query.toLowerCase())).toList();

  Future<void> _form({Aprendiz? item}) async {
    final result = await showDialog<Aprendiz>(context: context, barrierDismissible: false, builder: (_) => AprendizForm(item: item, departamentos: _departamentos, ciudades: _ciudades));
    if (result == null) return;
    try {
      if (item == null) { await _aprendizRepo.crear(result); }
      else { await _aprendizRepo.actualizar(result); }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(item == null ? 'Aprendiz registrado correctamente.' : 'Cambios guardados correctamente.')));
      await _load();
    } catch (e) { if (mounted) _showError(e); }
  }

  Future<void> _delete(Aprendiz a) async {
    if (!_isAdmin) { _showError(Exception('No tienes permisos para eliminar aprendices.')); return; }
    final ok = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Eliminar aprendiz'), content: Text('¿Deseas eliminar a ${a.nombreCompleto} (${a.id})? Esta acción no se puede deshacer.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar'))]));
    if (ok != true) return;
    try { await _aprendizRepo.eliminar(a.id); await _load(); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro eliminado.'))); }
    catch (e) { if (mounted) _showError(e); }
  }

  Future<void> _openLocations() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => UbicacionesScreen(isAdmin: _isAdmin)));
    if (mounted) _load();
  }

  void _showError(Object e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red.shade800, content: Text(_errorText(e))));

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, surfaceTintColor: Colors.white, titleSpacing: 24, title: Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(11)), child: const Icon(Icons.school, color: Colors.white, size: 22)), const SizedBox(width: 12), const Text('SIRA', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)), const SizedBox(width: 9), const Text('Registro de aprendices', style: TextStyle(color: Color(0xff66736f), fontSize: 14))]), actions: [IconButton(tooltip: 'Departamentos y ciudades', onPressed: _openLocations, icon: const Icon(Icons.location_city_outlined)), IconButton(tooltip: 'Actualizar', onPressed: _load, icon: const Icon(Icons.refresh)), if (_isAdmin) IconButton(tooltip: 'Gestionar usuarios', onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const UsuariosScreen())); if (mounted) _load(); }, icon: const Icon(Icons.manage_accounts_outlined)), IconButton(tooltip: 'Cerrar sesión', onPressed: () => Supabase.instance.client.auth.signOut(), icon: const Icon(Icons.logout)), const SizedBox(width: 10)]),
      body: Row(children: [if (!compact) Container(width: 220, color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.only(left: 12, bottom: 14), child: Text('MENÚ PRINCIPAL', style: TextStyle(fontSize: 11, letterSpacing: 1, color: Colors.black45, fontWeight: FontWeight.bold))), _nav(Icons.people_alt_outlined, 'Aprendices', true), _nav(Icons.location_city_outlined, 'Departamentos y ciudades', false, onTap: _openLocations), const Spacer(), const Divider(), const ListTile(leading: Icon(Icons.help_outline), title: Text('SIRA · versión 1.0'))])), Expanded(child: _content(compact))]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _form(), backgroundColor: _green, foregroundColor: Colors.white, icon: const Icon(Icons.person_add_alt_1), label: const Text('Nuevo aprendiz')));
  }

  Widget _nav(IconData icon, String title, bool selected, {VoidCallback? onTap}) => ListTile(leading: Icon(icon, color: selected ? _green : Colors.black54), title: Text(title, style: TextStyle(color: selected ? _green : Colors.black87, fontWeight: selected ? FontWeight.bold : FontWeight.normal)), selected: selected, selectedTileColor: const Color(0xffe9f5f1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), onTap: selected ? null : onTap);

  Widget _content(bool compact) => RefreshIndicator(onRefresh: _load, child: ListView(padding: EdgeInsets.all(compact ? 16 : 32), children: [Text('Gestión académica', style: TextStyle(color: _green, fontSize: 13, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text('Aprendices', style: TextStyle(fontSize: compact ? 27 : 34, fontWeight: FontWeight.w800, color: const Color(0xff172b26))), const SizedBox(height: 5), const Text('Registra, consulta y mantén actualizada la información.', style: TextStyle(color: Color(0xff66736f))), const SizedBox(height: 24), _summary(compact), const SizedBox(height: 22), _table(compact)]));

  Widget _summary(bool compact) {
    final cards = [_stat('Total aprendices', '${_rows.length}', Icons.groups_2_outlined, const Color(0xffe6f3ef)), _stat('Mujeres', '${_rows.where((a) => a.genero == 'F').length}', Icons.female, const Color(0xffffedf1)), _stat('Hombres', '${_rows.where((a) => a.genero == 'M').length}', Icons.male, const Color(0xffedf1ff))];
    return compact ? Column(children: cards.map((w) => Padding(padding: const EdgeInsets.only(bottom: 10), child: w)).toList()) : Row(children: cards.map((w) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 14), child: w))).toList());
  }
  Widget _stat(String label, String count, IconData icon, Color bg) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xffe9eeec))), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: _green)), const SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(count, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 23)), Text(label, style: const TextStyle(color: Colors.black54))])]));

  Widget _table(bool compact) => Container(
    padding: EdgeInsets.all(compact ? 14 : 22),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xffe9eeec))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Expanded(child: Text('Directorio de aprendices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        SizedBox(width: compact ? 150 : 280, child: TextField(controller: _search, onChanged: (v) => setState(() => _query = v), decoration: InputDecoration(hintText: 'Buscar aprendiz...', prefixIcon: const Icon(Icons.search, size: 20), contentPadding: EdgeInsets.zero, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), isDense: true))),
      ]),
      const SizedBox(height: 17),
      if (_loading) const Center(child: Padding(padding: EdgeInsets.all(36), child: CircularProgressIndicator()))
      else if (_error != null) _errorPanel()
      else if (_filtered.isEmpty) EmptyState(message: _rows.isEmpty ? 'Aún no hay aprendices registrados.' : 'No se encontraron resultados.')
      else if (compact) ..._filtered.map(_mobileCard)
      else SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
        columnSpacing: 28,
        headingRowColor: WidgetStateProperty.all(const Color(0xfff6f8f7)),
        columns: const [DataColumn(label: Text('IDENTIFICACIÓN')), DataColumn(label: Text('APRENDIZ')), DataColumn(label: Text('GÉNERO')), DataColumn(label: Text('FECHA NACIMIENTO')), DataColumn(label: Text('UBICACIÓN')), DataColumn(label: Text('ACCIONES'))],
        rows: _filtered.map((a) => DataRow(cells: [
          DataCell(Text(a.id, style: const TextStyle(fontWeight: FontWeight.w700))),
          DataCell(Text(a.nombreCompleto)), DataCell(_gender(a.genero)),
          DataCell(Text(_date(a.fechaNacimiento))),
          DataCell(Text('${a.ciudadNombre ?? '—'}, ${a.departamentoNombre ?? '—'}')),
          DataCell(Row(children: [
            IconButton(tooltip: 'Editar', onPressed: () => _form(item: a), icon: const Icon(Icons.edit_outlined, size: 19)),
            if (_isAdmin) IconButton(tooltip: 'Eliminar', onPressed: () => _delete(a), icon: const Icon(Icons.delete_outline, size: 19, color: Colors.red)),
          ])),
        ])).toList(),
      )),
    ]),
  );
  Widget _gender(String g) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), decoration: BoxDecoration(color: g == 'F' ? const Color(0xffffedf1) : const Color(0xffedf1ff), borderRadius: BorderRadius.circular(20)), child: Text(g == 'F' ? 'Femenino' : 'Masculino', style: const TextStyle(fontSize: 12)));
  Widget _mobileCard(Aprendiz a) => Card(color: Colors.white, child: ListTile(isThreeLine: true, title: Text(a.nombreCompleto, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${a.id} · ${a.genero}\n${a.ciudadNombre ?? '—'}, ${a.departamentoNombre ?? '—'}'), trailing: PopupMenuButton<String>(onSelected: (v) => v == 'editar' ? _form(item: a) : _delete(a), itemBuilder: (_) => [const PopupMenuItem(value: 'editar', child: Text('Editar')), if (_isAdmin) const PopupMenuItem(value: 'eliminar', child: Text('Eliminar'))])));
  Widget _errorPanel() => Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Icon(Icons.cloud_off_outlined, size: 38, color: Colors.red), const SizedBox(height: 10), Text(_error!, textAlign: TextAlign.center), TextButton(onPressed: _load, child: const Text('Reintentar'))]));
}

class AprendizForm extends StatefulWidget {
  const AprendizForm({super.key, this.item, required this.departamentos, required this.ciudades});
  final Aprendiz? item;
  final List<Departamento> departamentos;
  final List<Ciudad> ciudades;
  @override
  State<AprendizForm> createState() => _AprendizFormState();
}

class _AprendizFormState extends State<AprendizForm> {
  final _key = GlobalKey<FormState>();
  late final _id = TextEditingController(text: widget.item?.id);
  late final _first = TextEditingController(text: widget.item?.primerNombre);
  late final _middle = TextEditingController(text: widget.item?.segundoNombre);
  late final _last = TextEditingController(text: widget.item?.primerApellido);
  late final _last2 = TextEditingController(text: widget.item?.segundoApellido);
  String? _gender;
  int? _department, _city;
  DateTime? _dob;
  bool _saving = false;
  @override
  void initState() { super.initState(); final a = widget.item; _gender = a?.genero; _department = a?.departamentoId; _city = a?.ciudadId; _dob = a?.fechaNacimiento; }
  List<Ciudad> get _availableCities => widget.ciudades.where((c) => c.departamentoId == _department).toList();
  @override
  Widget build(BuildContext context) => AlertDialog(title: Text(widget.item == null ? 'Registrar aprendiz' : 'Editar aprendiz'), content: SizedBox(width: 540, child: Form(key: _key, child: SingleChildScrollView(child: Wrap(spacing: 14, runSpacing: 8, children: [ _field(_id, 'Identificación', required: true, enabled: widget.item == null), _field(_first, 'Primer nombre', required: true), _field(_middle, 'Segundo nombre'), _field(_last, 'Primer apellido', required: true), _field(_last2, 'Segundo apellido'), SizedBox(width: 245, child: DropdownButtonFormField<String>(initialValue: _gender, decoration: const InputDecoration(labelText: 'Género', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'F', child: Text('Femenino')), DropdownMenuItem(value: 'M', child: Text('Masculino'))], onChanged: (v) => setState(() => _gender = v), validator: (v) => v == null ? 'Selecciona el género' : null)), SizedBox(width: 245, child: InkWell(onTap: _pickDate, child: InputDecorator(decoration: const InputDecoration(labelText: 'Fecha de nacimiento', border: OutlineInputBorder()), child: Text(_dob == null ? 'Seleccionar fecha' : _date(_dob!))))), SizedBox(width: 245, child: DropdownButtonFormField<int>(initialValue: _department, decoration: const InputDecoration(labelText: 'Departamento', border: OutlineInputBorder()), items: widget.departamentos.map((d) => DropdownMenuItem(value: d.id, child: Text(d.nombre, overflow: TextOverflow.ellipsis))).toList(), onChanged: (v) => setState(() { _department = v; _city = null; }), validator: (v) => v == null ? 'Selecciona departamento' : null)), SizedBox(width: 245, child: DropdownButtonFormField<int>(initialValue: _availableCities.any((c) => c.id == _city) ? _city : null, decoration: const InputDecoration(labelText: 'Ciudad', border: OutlineInputBorder()), items: _availableCities.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(), onChanged: (v) => setState(() => _city = v), validator: (v) => v == null ? 'Selecciona ciudad' : null))])))), actions: [TextButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Guardando...' : 'Guardar'))]);
  Widget _field(TextEditingController c, String label, {bool required = false, bool enabled = true}) => SizedBox(width: 245, child: TextFormField(controller: c, enabled: enabled, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()), validator: required ? (v) => v == null || v.trim().isEmpty ? 'Campo obligatorio' : null : null));
  Future<void> _pickDate() async { final d = await showDatePicker(context: context, initialDate: _dob ?? DateTime(2005), firstDate: DateTime(1900), lastDate: DateTime.now(), locale: const Locale('es')); if (d != null) setState(() => _dob = d); }
  void _save() { if (!_key.currentState!.validate()) return; if (_dob == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona la fecha de nacimiento.'))); return; } setState(() => _saving = true); Navigator.pop(context, Aprendiz(id: _id.text.trim(), primerNombre: _first.text, segundoNombre: _middle.text, primerApellido: _last.text, segundoApellido: _last2.text, genero: _gender!, fechaNacimiento: _dob!, departamentoId: _department!, ciudadId: _city!)); }
}

String _date(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
String _errorText(Object e) {
  final s = e.toString();
  final lower = s.toLowerCase();
  if (s.contains('42P01') || s.contains('PGRST205') || lower.contains('could not find the table') && lower.contains('profiles')) {
    return 'Falta la tabla public.profiles. En Supabase SQL Editor ejecuta docs/supabase_auth_setup.sql para instalar los perfiles y roles; luego vuelve a cargar esta pantalla.';
  }
  if (s.contains('42501') || lower.contains('permission denied')) {
    return 'Supabase rechazó el acceso. Ejecuta docs/supabase_auth_setup.sql para habilitar el acceso autenticado con políticas RLS.';
  }
  if (s.contains('23505') || lower.contains('duplicate')) return 'Ya existe un aprendiz con esa identificación.';
  if (s.contains('Failed host lookup') || s.contains('SocketException')) return 'No se pudo conectar con Supabase. Revisa la conexión.';
  return 'No fue posible completar la operación. $s';
}
