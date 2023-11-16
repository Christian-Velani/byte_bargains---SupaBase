// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:byte_bargains/meus_widgets.dart';
import 'package:byte_bargains/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

class PesquisaPage extends StatefulWidget {
  const PesquisaPage({super.key});

  @override
  State<PesquisaPage> createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  final db = FirebaseFirestore.instance;
  TextEditingController textoPesquisa = TextEditingController();
  var resultados;
  var valorPesquisado;
  void pesquisar(String pesquisa) async {
    resultados = true;
    valorPesquisado = pesquisa;
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: resultados != null,
        builder: (context) =>
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db
                  .collection("Jogos")
                  .where("Nome do Jogo", isEqualTo: valorPesquisado)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                var data = snapshot.data!.docs;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: textoPesquisa,
                          onEditingComplete: () {
                            if (textoPesquisa.text.length >= 4) {
                              pesquisar(textoPesquisa.text);
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Pesquisar",
                            labelStyle: textoNotoSansBold,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text("Resultados da Pesquisa", style: textoNotoSansBold),
                      SizedBox(
                        height: 531,
                        child: ListView(
                            scrollDirection: Axis.vertical,
                            children: data
                                .map((doc) => JogoPequenoHorizontal(
                                    imagem: Image.network(
                                      doc["Imagem"],
                                      fit: BoxFit.fill,
                                    ),
                                    nome: doc['Nome do Jogo']))
                                .toList()),
                      )
                    ],
                  ),
                );
              },
            ),
        fallback: (context) => SingleChildScrollView(
                child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: textoPesquisa,
                  onEditingComplete: () {
                    if (textoPesquisa.text.length >= 4) {
                      pesquisar(textoPesquisa.text);
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Pesquisar",
                    labelStyle: textoNotoSansBold,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text("Resultados da Pesquisa", style: textoNotoSansBold),
            ])));
  }
}
