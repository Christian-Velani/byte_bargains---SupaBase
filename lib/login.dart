// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_constructors_in_immutables, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:byte_bargains/styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;

  final txtNameCtrl = TextEditingController();

  final txtSenhaCtrl = TextEditingController();
  IconData iconeSenha = Icons.visibility;
  bool escondido = true;

  void Logar(BuildContext context) async {
    if (txtNameCtrl.text.isNotEmpty && txtSenhaCtrl.text.isNotEmpty) {
      try {
        await supabase.auth.signInWithPassword(
            email: txtNameCtrl.text, password: txtSenhaCtrl.text);
        Navigator.of(context).pushNamed("/Principal");
      } on AuthException {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Problema ao Logar"),
              content: Text("Email/Senha incorreto"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Problema ao Logar"),
            content: Text("Insira um Email/Senha válidos"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                alignment: Alignment.center,
                child: Image.asset("images/icon.png"),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: txtNameCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "E-mail",
                    labelStyle: textoNotoSansBold,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: txtSenhaCtrl,
                  obscureText: escondido,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(iconeSenha),
                      onPressed: () {
                        escondido == true
                            ? escondido = false
                            : escondido = true;
                        iconeSenha == Icons.visibility
                            ? iconeSenha = Icons.visibility_off
                            : iconeSenha = Icons.visibility;
                        setState(() {});
                      },
                    ),
                    border: OutlineInputBorder(),
                    labelText: "Senha",
                    labelStyle: textoNotoSansBold,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                width: double.infinity,
                child: ElevatedButton(
                    child: Text(
                      "Entrar",
                      style: textoOpenSansBold,
                    ),
                    onPressed: () {
                      Logar(context);
                    }),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/Cadastro'),
                  child: Text(
                    "Cadastrar",
                    style: textoOpenSansBold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
