import 'package:byte_bargains/cadastro.dart';
import 'package:byte_bargains/editar.dart';
import 'package:byte_bargains/jogo.dart';
import 'package:byte_bargains/login.dart';
import 'package:byte_bargains/perfil.dart';
import 'package:byte_bargains/navigation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://piienbbhsvnkpvzdslum.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBpaWVuYmJoc3Zua3B2emRzbHVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDAxNDE5NTksImV4cCI6MjAxNTcxNzk1OX0.MKdVwtmEt2aOwNU7ScwsjgpvukxdJmquIH9hfWyUvVU",
      authFlowType: AuthFlowType.pkce);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/Cadastro": (context) => const CadastroPage(),
          "/Login": (context) => LoginPage(),
          "/Perfil": (context) => PerfilPage(),
          "/Principal": (context) => const NavigationPage(),
          "/Editar": (context) => const EditarPage(),
          "/Jogo": (context) => JogoPage(),
        },
        initialRoute: '/Login');
  }
}
