// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_constructors_in_immutables, non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:byte_bargains/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final txtNameCtrl = TextEditingController();

  final txtSenhaCtrl = TextEditingController();
  IconData iconeSenha = Icons.visibility;
  bool escondido = true;

  void Logar(BuildContext context) async {
    if (txtNameCtrl.text.isNotEmpty && txtSenhaCtrl.text.isNotEmpty) {
      try {
        Navigator.of(context).pushNamed("/Principal");
      } on FirebaseAuthException catch (e) {
        if (e.code == "invalid-email") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Erro ao logar"),
                content: Text("Insira um E-mail válido"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
        } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Erro ao logar"),
                content: Text("Email ou senha incorretos"),
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
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    text: "Esqueceu a senha?",
                    style: textoOpenSansRegular,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (txtNameCtrl.text.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Email Enviado"),
                                content: Text(
                                    "Se o ${txtNameCtrl.text} for um email cadastro, foi enviado um email para recuperação da senha"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text("Ok"),
                                  ),
                                ],
                              );
                            },
                          );
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: txtNameCtrl.text);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Recuperar Senha"),
                                content: Text(
                                    "Para Recuperar a senha insira um email no campo Email"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text("Ok"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
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
