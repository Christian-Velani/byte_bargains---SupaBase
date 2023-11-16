// ignore_for_file: prefer_const_constructors, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'styles.dart';

class EditarPage extends StatefulWidget {
  EditarPage({super.key});

  @override
  State<EditarPage> createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {
  XFile? image;
  final supabase = Supabase.instance.client;
  final senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconeSenha = Icons.visibility;
  bool escondido = true;

  void subirImagem() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final usuarioController = TextEditingController(
        text: supabase.auth.currentUser!.userMetadata!["Usuário"]);

    void AtualizarCadastro() async {
      final imagem;
      if (image != null) {
        await supabase.storage.from('Avatares').upload(
              image!.name,
              File(image!.path),
            );
        imagem = image!.name;
      } else {
        imagem = supabase.auth.currentUser!.userMetadata!["Imagem"];
      }

      if (senhaController.text.isNotEmpty) {
        await supabase.auth.updateUser(UserAttributes(
          password: senhaController.text,
        ));
      }

      await supabase.auth.updateUser(UserAttributes(
          data: {"Usuário": usuarioController.text, "Imagem": imagem}));

      Navigator.of(context).pop();
    }

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
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image.network(
                              supabase.storage.from("Avatares").getPublicUrl(
                                  supabase.auth.currentUser!
                                      .userMetadata!["Imagem"]),
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
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
                    alignment: Alignment.center,
                    child: Text(
                      "Caso queira manter a senha atual, deixe em branco os campos de senha",
                      style: textoNotoSansBold,
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  width: 300,
                  child: TextFormField(
                    controller: senhaController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
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
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      return value != senhaController.text
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
                      if (_formKey.currentState!.validate()) {
                        AtualizarCadastro();
                      }
                    },
                    child: Text(
                      "Atualizar",
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
