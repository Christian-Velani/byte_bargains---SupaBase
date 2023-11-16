// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:byte_bargains/meus_widgets.dart';
import 'package:byte_bargains/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListaDesejosPage extends StatelessWidget {
  Map<String, List<Jogo>> generosJogos = {};
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
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db
                  .collection("Jogos")
                  .where(
                    "Nome do Jogo",
                    whereIn: (jogosDesejados.map((jogo) => jogo).toList()),
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var data = snapshot.data!.docs;
                for (var doc in data) {
                  doc["Gêneros"].forEach((genero) {
                    if (generosJogos[genero] == null) {
                      generosJogos[genero] = [
                        Jogo(
                          Image.network(
                            doc['Imagem'],
                            fit: BoxFit.fill,
                          ),
                          doc['Nome do Jogo'],
                        ),
                      ];
                    } else {
                      generosJogos[genero]!.add(
                        Jogo(
                          Image.network(
                            doc['Imagem'],
                            fit: BoxFit.fill,
                          ),
                          doc['Nome do Jogo'],
                        ),
                      );
                    }
                  });
                }
                return Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lista de Desejos",
                        style: textoNotoSansBoldGrande,
                      ),
                    ),
                    SizedBox(
                      height: 580,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: generosJogos.keys
                            .map(
                              (genero) => GeneroContainer(
                                genero,
                                generosJogos[genero],
                              ),
                            )
                            .toList(),
                      ),
                    )
                  ],
                );
              });
        });
  }
}
