// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'styles.dart';

class CadastroPage extends StatefulWidget {
  CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  XFile? image;
  final usuarioController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconeSenha = Icons.visibility;
  bool escondido = true;
  final supabase = Supabase.instance.client;

  void subirImagem() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void cadastrar() async {
    try {
      await supabase.auth
          .signUp(email: emailController.text, password: senhaController.text);

      await supabase.storage.from('Avatares').upload(
            image!.name,
            File(image!.path),
          );

      await supabase.auth.updateUser(
        UserAttributes(
          data: {'Usuário': usuarioController.text, "Imagem": image!.name},
        ),
      );

      Navigator.pop(context);
    } on AuthException catch (e) {
      if (e.statusCode == "400") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Cadastro Incompleto"),
              content: Text("Email já está em uso"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok"),
                ),
              ],
            );
          },
        );
      } else if (e.statusCode == "422") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Cadastro Incompleto"),
              content: Text("Email Inválido"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: true,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 50),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  alignment: Alignment.center,
                  height: 140,
                  width: 140,
                  child: GestureDetector(
                    onTap: subirImagem,
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.file(
                              File(image!.path),
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          )
                        : const Text(
                            "Nenhuma imagem selecionada",
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: 300,
                  child: TextFormField(
                    validator: (value) {
                      return ((value != null &&
                                  value.toString().length >= 6 &&
                                  value.toString().length <= 30) &&
                              (value.isNotEmpty))
                          ? null
                          : 'O nome de usuário tem que ser entre 6 e 30 caracteres';
                    },
                    controller: usuarioController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Usuário",
                      labelStyle: textoNotoSansBold,
                    ),
                    style: TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: 300,
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      return value != null &&
                              value.isNotEmpty &&
                              value.contains('@')
                          ? null
                          : "Insira um email válido";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      labelStyle: textoNotoSansBold,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: 300,
                  child: TextFormField(
                    controller: senhaController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "A senha deve ter de 7 a 30 caracteres";
                      } else if (value != null && value.isNotEmpty) {
                        if (value.length < 7 || value.length > 30) {
                          return "A senha deve ter de 7 a 30 caracteres";
                        } else if (!value.contains(RegExp(r'[0-9]'))) {
                          return "A senha precisa ter 1 número";
                        } else if (!value.contains(RegExp(r'[A-Z]'))) {
                          return "A senha tem que ter uma letra maíscula";
                        } else if (!value.contains(RegExp(r'[!@#$%&*]'))) {
                          return "A senha tem que ter um caracter especial [!@#\$%*&]";
                        }
                        return null;
                      }
                      return null;
                    },
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
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: 300,
                  child: TextFormField(
                    validator: (value) {
                      return (value != senhaController.text ||
                              (value != null && value.isEmpty))
                          ? "As senhas não coincidem"
                          : null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirmar Senha",
                      labelStyle: textoNotoSansBold,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (image != null) {
                        if (_formKey.currentState!.validate()) {
                          cadastrar();
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Imagem não selecionada'),
                              content: Text(
                                  'Por favor, selecione uma imagem antes de cadastrar-se.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
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
      ),
    );
  }
}
