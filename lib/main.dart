import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/aprendices_screen.dart';
import 'screens/login_screen.dart';
import 'screens/password_update_screen.dart';

const _url = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://xpizbtncnkqnldwzdeph.supabase.co');
const _key = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'sb_publishable_EO0Eb11Gtmlw4stXcuNW0A_uul_nEak');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: _url, publishableKey: _key);
  runApp(const SiraApp());
}

class SiraApp extends StatelessWidget {
  const SiraApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SIRA | Registro de aprendices', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff087e68)), scaffoldBackgroundColor: const Color(0xfff5f7f7), useMaterial3: true, fontFamily: 'Arial'),
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('es'), Locale('en')],
    home: const AuthGate());
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<AuthState>(
    stream: Supabase.instance.client.auth.onAuthStateChange,
    builder: (context, snapshot) {
      final session = snapshot.data?.session ?? Supabase.instance.client.auth.currentSession;
      if (snapshot.data?.event == AuthChangeEvent.passwordRecovery) {
        return const PasswordUpdateScreen();
      }
      if (snapshot.connectionState == ConnectionState.waiting && session == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return session == null ? const LoginScreen() : const AprendicesScreen();
    },
  );
}

// Alias retained for the starter project's existing widget-test import.
class MyApp extends SiraApp {
  const MyApp({super.key});
}
