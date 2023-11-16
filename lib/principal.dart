// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:math';

import 'package:byte_bargains/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'meus_widgets.dart';

class PrincipalPage extends StatelessWidget {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: db
          .collection("Listas de Desejos")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot2) {
        if (!snapshot2.hasData) return CircularProgressIndicator();
        var data2 = snapshot2.data!.data();
        List<dynamic> jogosDesejados = data2!["Jogos"];
        List<int> numeros = [];
        if (jogosDesejados.length >= 5) {
          var rng = Random();
          for (var i = 0; i < 5; i++) {
            int numeroGerado = rng.nextInt(jogosDesejados.length);
            while (numeros.contains(numeroGerado)) {
              numeroGerado = rng.nextInt(jogosDesejados.length);
            }
            numeros.add(numeroGerado);
          }
        } else {
          var rng = Random();
          for (var i = 0; i < jogosDesejados.length; i++) {
            int numeroGerado = rng.nextInt(jogosDesejados.length);
            while (numeros.contains(numeroGerado)) {
              numeroGerado = rng.nextInt(jogosDesejados.length);
            }
            numeros.add(numeroGerado);
          }
        }
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db
              .collection("Jogos")
              .where("Nome do Jogo",
                  whereIn: (numeros
                      .map((numero) => jogosDesejados[numero])
                      .toList()))
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                  child: Text(
                    "Vamos explorar",
                    style: textoOpenSansRegularPequeno,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Jogos",
                    style: textoNotoSansBoldGrande,
                  ),
                ),
                SizedBox(
                  height: 500,
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    scrollDirection: Axis.horizontal,
                    children: data
                        .map(
                          (doc) => JogoGrande(
                              Image.network(
                                doc["Imagem"],
                                fit: BoxFit.fill,
                              ),
                              doc["Nome do Jogo"],
                              "Da sua lista de Desejos"),
                        )
                        .toList(),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
