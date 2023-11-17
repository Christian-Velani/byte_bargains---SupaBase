// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:byte_bargains/meus_widgets.dart';
import 'package:byte_bargains/styles.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PesquisaPage extends StatefulWidget {
  const PesquisaPage({super.key});

  @override
  State<PesquisaPage> createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  final supabase = Supabase.instance.client;
  TextEditingController textoPesquisa = TextEditingController();
  var resultados;
  var valorPesquisado;
  void pesquisar(String pesquisa) async {
    resultados = true;
    valorPesquisado = pesquisa;
  }

  @override
  Widget build(BuildContext context) {
    final User user = supabase.auth.currentUser!;
    Future<List<dynamic>> pegarListaDesejos() async {
      final listaDesejos = await supabase
          .from("Listas de Desejos")
          .select("jogoId")
          .eq("idUsuario", user.id);
      return listaDesejos;
    }

    Future<Map<String, Jogo>> buscarJogosPrincipal(String pesquisa) async {
      Map<String, Jogo> jogosFinais = {};
      final informacoesJogo = await supabase
          .from("Jogos")
          .select('''nomeJogo, imagem, descricao''')
          .ilike("nomeJogo", "$pesquisa%")
          .order("nomeJogo", ascending: true);
      informacoesJogo.forEach((infoJogo) {
        jogosFinais[infoJogo["nomeJogo"]] = Jogo("", "", "", [], []);
      });
      informacoesJogo.forEach((infoJogo) {
        jogosFinais[infoJogo["nomeJogo"]]!.nome = infoJogo["nomeJogo"];
        jogosFinais[infoJogo["nomeJogo"]]!.descricao = infoJogo["descricao"];
        jogosFinais[infoJogo["nomeJogo"]]!.imagem = infoJogo["imagem"];
      });
      return jogosFinais;
    }

    return ConditionalBuilder(
        condition: resultados != null,
        builder: (context) => FutureBuilder(
            future: buscarJogosPrincipal(valorPesquisado),
            builder: ((context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var data2 = snapshot.data;
              return FutureBuilder(
                  future: pegarListaDesejos(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    var data = snapshot.data;
                    List<String> listaJogosDesejados = [];
                    for (var info in data!) {
                      listaJogosDesejados.add(info["jogoId"]);
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: textoPesquisa,
                              onEditingComplete: () {
                                pesquisar(textoPesquisa.text);
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
                          Text("Resultados da Pesquisa",
                              style: textoNotoSansBold),
                          SizedBox(
                            height: 531,
                            width: 500,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: data2!.length,
                              itemBuilder: (context, index) {
                                Jogo jogo = data2.values.elementAt(index);
                                return JogoPequenoHorizontal(
                                    imagem: jogo.imagem,
                                    nome: jogo.nome,
                                    listaDesejos: listaJogosDesejados);
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  }));
            })),
        fallback: (context) => SingleChildScrollView(
                child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: textoPesquisa,
                  onEditingComplete: () {
                    pesquisar(textoPesquisa.text);
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
