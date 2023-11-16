// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:byte_bargains/login.dart';
import 'package:byte_bargains/styles.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  // final db = FirebaseFirestore.instance;

  // void Logout() async {
  //   await FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 70, 0, 30),
            child: Center(
              child: Text(
                "Perfil do Usuário",
                style: textoNotoSansBoldGrande,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 100),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 50),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 100,
                    width: 100,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Text("Teste")
                        // Image.network(
                        //   FirebaseAuth.instance.currentUser!.photoURL!,
                        //   fit: BoxFit.fill,
                        // ),
                        ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "Teste",
                      // FirebaseAuth.instance.currentUser!.displayName!,
                      style: textoOpenSansBold,
                    ),
                    Text(
                      "Teste",
                      // FirebaseAuth.instance.currentUser!.email!,
                      style: textoOpenSansRegularPequeno,
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 20),
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: Colors.blue,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: RichText(
                      text: TextSpan(
                          text: "Alterar Perfil",
                          style: TextStyle(color: Colors.white),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                Navigator.of(context).pushNamed("/Editar"))),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    // Logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(children: [
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Icon(Icons.logout_outlined)),
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                        "Desconectar",
                        style: textoOpenSansRegularBranco,
                      ),
                    )
                  ]),
                ),
              ))
        ],
      ),
    );
  }
}
