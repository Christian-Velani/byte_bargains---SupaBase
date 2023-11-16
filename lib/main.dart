import 'package:byte_bargains/cadastro.dart';
import 'package:byte_bargains/editar.dart';
import 'package:byte_bargains/jogo.dart';
import 'package:byte_bargains/login.dart';
import 'package:byte_bargains/perfil.dart';
import 'package:byte_bargains/navigation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://mfkjoutdgcxorddtqqof.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ma2pvdXRkZ2N4b3JkZHRxcW9mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDAxMjc5MzksImV4cCI6MjAxNTcwMzkzOX0.9yKfKbAwOfUKNuAl7go8T1DPTxZ8QDkYnhFYmVlFl7A");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/Cadastro": (context) => CadastroPage(),
          "/Login": (context) => LoginPage(),
          "/Perfil": (context) => PerfilPage(),
          "/Principal": (context) => const NavigationPage(),
          "/Editar": (context) => EditarPage(),
          "/Jogo": (context) => JogoPage(),
        },
        initialRoute: '/Login');
  }
}
