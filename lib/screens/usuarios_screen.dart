import 'package:flutter/material.dart';
import '../models/perfil_usuario.dart';
import '../services/perfil_repository.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final _repo = PerfilRepository();
  List<PerfilUsuario> _users = [];
  bool _loading = true;
  String? _error;
  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try { final users = await _repo.listar(); if (mounted) setState(() { _users = users; _loading = false; }); }
    catch (e) { if (mounted) setState(() { _error = e.toString(); _loading = false; }); }
  }
  Future<void> _newUser() async {
    final form = GlobalKey<FormState>(); final email = TextEditingController(); final password = TextEditingController(); var role = 'operativo';
    final result = await showDialog<(String, String, String)>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialog) => AlertDialog(
        title: const Text('Crear usuario'),
        content: SizedBox(width: 420, child: Form(key: form, child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: email, decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()), validator: (v) => v == null || !v.contains('@') ? 'Correo no válido' : null),
          const SizedBox(height: 12),
          TextFormField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña temporal', border: OutlineInputBorder()), validator: (v) => v == null || v.length < 8 ? 'Usa al menos 8 caracteres' : null),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(initialValue: role, decoration: const InputDecoration(labelText: 'Rol'), items: const [DropdownMenuItem(value: 'operativo', child: Text('Usuario operativo')), DropdownMenuItem(value: 'admin', child: Text('Administrador'))], onChanged: (v) => setDialog(() => role = v ?? 'operativo')),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(onPressed: () { if (form.currentState!.validate()) Navigator.pop(context, (email.text.trim(), password.text, role)); }, child: const Text('Crear usuario')),
        ],
      )),
    );
    if (result == null) return;
    try { await _repo.crearUsuario(email: result.$1, password: result.$2, role: result.$3); await _load(); if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario creado.'))); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo crear el usuario: $e'))); }
  }
  Future<void> _changeRole(PerfilUsuario user, String role) async {
    try { await _repo.cambiarRol(user.id, role); await _load(); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo actualizar el rol: $e'))); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Gestión de usuarios'), actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))]),
    body: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: _loading ? const Center(child: CircularProgressIndicator())
        : _error != null ? Center(child: SelectableText(_error!))
        : ListView(padding: const EdgeInsets.all(24), children: [
          Row(children: [const Expanded(child: Text('Usuarios de SIRA', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))), FilledButton.icon(onPressed: _newUser, icon: const Icon(Icons.person_add_alt_1), label: const Text('Nuevo usuario'))]),
          const SizedBox(height: 18),
          for (final user in _users) Card(color: Colors.white, child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text(user.email.isEmpty ? user.id : user.email),
            subtitle: Text(user.role == 'admin' ? 'Administrador' : 'Usuario operativo'),
            trailing: SizedBox(width: 190, child: DropdownButtonFormField<String>(
              initialValue: user.role, decoration: const InputDecoration(labelText: 'Rol'),
              items: const [DropdownMenuItem(value: 'operativo', child: Text('Operativo')), DropdownMenuItem(value: 'admin', child: Text('Administrador'))],
              onChanged: (v) { if (v != null && v != user.role) _changeRole(user, v); },
            )),
          )),
        ]),
    )),
  );
}
