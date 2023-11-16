import 'package:byte_bargains/cadastro.dart';
import 'package:byte_bargains/editar.dart';
import 'package:byte_bargains/jogo.dart';
import 'package:byte_bargains/login.dart';
import 'package:byte_bargains/perfil.dart';
import 'package:byte_bargains/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyAVUhx-6R_mnMISZN1-v97FEz_tfalj3L8",
    authDomain: "byte-bargains.firebaseapp.com",
    projectId: "byte-bargains",
    storageBucket: "byte-bargains.appspot.com",
    messagingSenderId: "926471454978",
    appId: "1:926471454978:web:ed7967f205796a4691421b",
    measurementId: "G-MBRJN76MCL");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
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
