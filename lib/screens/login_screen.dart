import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false, _hidePassword = true;
  String? _error;

  Future<void> _signIn() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(), password: _password.text,
      );
    } on AuthException catch (e) {
      setState(() => _error = e.message.toLowerCase().contains('invalid login credentials')
        ? 'El correo o la contraseña no son correctos.' : e.message);
    } catch (_) {
      setState(() => _error = 'No se pudo conectar. Revisa tu conexión e inténtalo de nuevo.');
    } finally { if (mounted) setState(() => _busy = false); }
  }

  Future<void> _resetPassword() async {
    if (_email.text.trim().isEmpty || !_email.text.contains('@')) {
      setState(() => _error = 'Escribe tu correo para enviarte el enlace de recuperación.');
      return;
    }
    setState(() { _busy = true; _error = null; });
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(_email.text.trim());
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Si el correo está registrado, recibirás un enlace para cambiar tu contraseña.')));
    } on AuthException catch (e) { if (mounted) setState(() => _error = e.message); }
    finally { if (mounted) setState(() => _busy = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Card(
            color: Colors.white, elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(key: _form, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(width: 52, height: 52, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xff087e68), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.school, color: Colors.white, size: 28)),
        const SizedBox(height: 22), const Text('Bienvenido a SIRA', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6), const Text('Ingresa con tu correo y contraseña para continuar.', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 26), TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, autofillHints: const [AutofillHints.username, AutofillHints.email], decoration: const InputDecoration(labelText: 'Correo electrónico', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()), validator: (v) => v == null || !v.contains('@') ? 'Escribe un correo válido.' : null),
        const SizedBox(height: 15), TextFormField(controller: _password, obscureText: _hidePassword, autofillHints: const [AutofillHints.password], onFieldSubmitted: (_) => _signIn(), decoration: InputDecoration(labelText: 'Contraseña', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(), suffixIcon: IconButton(onPressed: () => setState(() => _hidePassword = !_hidePassword), icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined))), validator: (v) => v == null || v.isEmpty ? 'Escribe tu contraseña.' : null),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 14), child: Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center)),
        const SizedBox(height: 20), FilledButton(onPressed: _busy ? null : _signIn, style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48), backgroundColor: const Color(0xff087e68)), child: _busy ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Iniciar sesión')),
        TextButton(onPressed: _busy ? null : _resetPassword, child: const Text('¿Olvidaste tu contraseña?')),
              ])),
            ),
          ),
        ),
      ),
    ),
  );
}
