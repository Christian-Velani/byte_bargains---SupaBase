// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, use_key_in_widget_constructors

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:byte_bargains/meus_widgets.dart';
import 'package:byte_bargains/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JogoPage extends StatefulWidget {
  @override
  State<JogoPage> createState() => _JogoPageState();
}

class _JogoPageState extends State<JogoPage> {
  final db = FirebaseFirestore.instance;
  IconData icone = Icons.favorite_outline;

  @override
  Widget build(BuildContext context) {
    late String nomeJogo;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (args.containsKey('nomeJogo')) {
      nomeJogo = args['nomeJogo'] as String;
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: db.collection("Jogos").doc(nomeJogo).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var data = snapshot.data!.data();
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: db
                        .collection("Listas de Desejos")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot2) {
                      if (!snapshot2.hasData)
                        return CircularProgressIndicator();
                      var data2 = snapshot2.data!.data();
                      List<dynamic> jogosDesejados = data2!["Jogos"];
                      if (jogosDesejados.contains(data!["Nome do Jogo"])) {
                        icone = Icons.favorite;
                      } else {
                        icone = Icons.favorite_outline;
                      }
                      return Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 350,
                                child: Image.network(
                                  data["Imagem"],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              FloatingActionButton(
                                onPressed: () => Navigator.pop(context),
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  size: 50,
                                  Icons.arrow_circle_left_outlined,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: BlurryContainer(
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(0),
                                  child: Column(
                                    children: [
                                      Text(
                                        data["Nome do Jogo"],
                                        style: textoNotoSansBoldGrande,
                                      ),
                                      Text(
                                        data["Descrição"],
                                        style: textoOpenSansRegularPequeno,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            height: 57,
                            width: 321,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                if (icone == Icons.favorite_outline) {
                                  icone = Icons.favorite;
                                  jogosDesejados.add(data["Nome do Jogo"]);
                                  db
                                      .collection("Listas de Desejos")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({"Jogos": jogosDesejados});
                                } else {
                                  icone = Icons.favorite_outline;
                                  jogosDesejados.remove(data["Nome do Jogo"]);
                                  db
                                      .collection("Listas de Desejos")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({"Jogos": jogosDesejados});
                                }
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child: Icon(icone),
                                  ),
                                  Text(
                                    "Lista de Desejos",
                                    style: textoNotoSansBold,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 330,
                            width: 321,
                            child: ListView.builder(
                              itemCount: data["Lojas"].length,
                              itemBuilder: (context, index) {
                                return LojaPreco(
                                  data["Lojas"][index]['shop'],
                                  data["Lojas"][index]['prices']
                                              ["initial_price"] !=
                                          "Indisponível"
                                      ? data["Lojas"][index]['prices']
                                          ["initial_price"]
                                      : 0.0,
                                  data["Lojas"][index]['prices']["discount"] ==
                                          0.0
                                      ? Estado.normal
                                      : data["Lojas"][index]['prices']
                                                  ["discount"] !=
                                              "Indisponível"
                                          ? Estado.desconto
                                          : Estado.indisponivel,
                                  precoDesconto: (data["Lojas"][index]['prices']
                                                  ["discount"] ==
                                              0.0 ||
                                          data["Lojas"][index]['prices']
                                                  ["discount"] ==
                                              "Indisponível")
                                      ? 0.0
                                      : data["Lojas"][index]['prices']
                                          ['final_price'],
                                );
                              },
                            ),
                          )
                        ],
                      );
                    });
              }),
        ));
  }
}
