import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordUpdateScreen extends StatefulWidget {
  const PasswordUpdateScreen({super.key});
  @override
  State<PasswordUpdateScreen> createState() => _PasswordUpdateScreenState();
}

class _PasswordUpdateScreenState extends State<PasswordUpdateScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  String? _error;
  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      await Supabase.instance.client.auth.updateUser(UserAttributes(password: _password.text));
      if (mounted) await Supabase.instance.client.auth.signOut();
    } on AuthException catch (e) { if (mounted) setState(() => _error = e.message); }
    finally { if (mounted) setState(() => _busy = false); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Card(
        color: Colors.white,
        child: SizedBox(
          width: 420,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _form,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('Crear nueva contraseña', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                const SizedBox(height: 18),
                TextFormField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Nueva contraseña', border: OutlineInputBorder()), validator: (v) => v == null || v.length < 8 ? 'Usa al menos 8 caracteres.' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar contraseña', border: OutlineInputBorder()), validator: (v) => v != _password.text ? 'Las contraseñas no coinciden.' : null),
                if (_error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: const TextStyle(color: Colors.red))),
                const SizedBox(height: 18),
                FilledButton(onPressed: _busy ? null : _save, child: Text(_busy ? 'Guardando...' : 'Actualizar contraseña')),
              ]),
            ),
          ),
        ),
      ),
    ),
  );
}
