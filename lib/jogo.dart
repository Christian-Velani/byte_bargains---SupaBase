// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, use_key_in_widget_constructors

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:byte_bargains/meus_widgets.dart';
import 'package:byte_bargains/styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JogoPage extends StatefulWidget {
  @override
  State<JogoPage> createState() => _JogoPageState();
}

class _JogoPageState extends State<JogoPage> {
  IconData icone = Icons.favorite_outline;
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    late String nomeJogo;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (args.containsKey('nomeJogo')) {
      nomeJogo = args['nomeJogo'] as String;
    }
    final User user = supabase.auth.currentUser!;
    Future<List<dynamic>> pegarListaDesejos() async {
      final listaDesejos = await supabase
          .from("Listas de Desejos")
          .select("jogoId")
          .eq("idUsuario", user.id);
      return listaDesejos;
    }

    Future<Map<String, Jogo>> buscarJogosPrincipal(String jogo) async {
      Map<String, Jogo> jogosFinais = {};
      final informacoesJogo = await supabase
          .from("Jogos")
          .select('''nomeJogo, imagem, descricao''').eq("nomeJogo", jogo);
      final generosJogo = await supabase
          .from("GenerosJogos")
          .select('''idGenero, idJogo''').eq("idJogo", jogo);
      final lojasJogo = await supabase
          .from("LojasPreços")
          .select('''nomeLoja, precoInicial, desconto, precoFinal, idJogo''').eq(
              "idJogo", jogo);
      informacoesJogo.forEach((infoJogo) {
        jogosFinais[infoJogo["nomeJogo"]] = Jogo("", "", "", [], []);
      });
      informacoesJogo.forEach((infoJogo) {
        jogosFinais[infoJogo["nomeJogo"]]!.nome = infoJogo["nomeJogo"];
        jogosFinais[infoJogo["nomeJogo"]]!.descricao = infoJogo["descricao"];
        jogosFinais[infoJogo["nomeJogo"]]!.imagem = infoJogo["imagem"];
      });
      lojasJogo.forEach(
        (loja) {
          jogosFinais[loja["idJogo"]]!.lojas.add(
            {
              "loja": {
                "nomeLoja": loja["nomeLoja"],
                "precoInicial": loja["precoInicial"],
                "desconto": loja["desconto"],
                "precoFinal": loja["precoFinal"]
              }
            },
          );
        },
      );
      generosJogo.forEach((genero) {
        jogosFinais[genero["idJogo"]]!.generos.add(genero['idGenero']);
      });
      return jogosFinais;
    }

    Future<void> atualizarListaDesejos(String tipo, String jogo) async {
      if (tipo == "adicionar") {
        final response = await supabase
            .from("Listas de Desejos")
            .insert({"idUsuario": user.id, "jogoId": jogo});
        return response;
      } else if (tipo == "remover") {
        final response = await supabase
            .from("Listas de Desejos")
            .delete()
            .match({"idUsuario": user.id, "jogoId": jogo});
        return response;
      }
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true,
          child: FutureBuilder(
              future: buscarJogosPrincipal(nomeJogo),
              builder: ((context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                var data2 = snapshot.data;
                return FutureBuilder(
                    future: pegarListaDesejos(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      var data = snapshot.data;
                      List<String> listaJogosDesejados = [];
                      for (var info in data!) {
                        listaJogosDesejados.add(info["jogoId"]);
                      }
                      if (listaJogosDesejados.contains(nomeJogo)) {
                        icone = Icons.favorite;
                      }
                      return Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 350,
                                child: Image.network(
                                  data2!.values.elementAt(0).imagem,
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
                                        data2.values.elementAt(0).nome,
                                        style: textoOpenSansRegularPequeno,
                                      ),
                                      Text(
                                        data2.values.elementAt(0).descricao,
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
                                  atualizarListaDesejos("adicionar", nomeJogo);
                                } else {
                                  icone = Icons.favorite_outline;
                                  atualizarListaDesejos("remover", nomeJogo);
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
                              itemCount: data2.values.elementAt(0).lojas.length,
                              itemBuilder: (context, index) {
                                return LojaPreco(
                                  data2.values.elementAt(0).lojas[index]["loja"]
                                      ["nomeLoja"],
                                  data2.values.elementAt(0).lojas[index]["loja"]
                                              ["precoInicial"] !=
                                          "Indisponível"
                                      ? data2.values.elementAt(0).lojas[index]
                                          ["loja"]["precoInicial"]
                                      : "0.0",
                                  data2.values.elementAt(0).lojas[index]["loja"]
                                              ["desconto"] ==
                                          "0.0"
                                      ? Estado.normal
                                      : data2.values.elementAt(0).lojas[index]
                                                  ["loja"]["desconto"] !=
                                              "Indisponível"
                                          ? Estado.desconto
                                          : Estado.indisponivel,
                                  precoDesconto: (data2.values
                                                      .elementAt(0)
                                                      .lojas[index]["loja"]
                                                  ["desconto"] ==
                                              "0.0" ||
                                          data2.values.elementAt(0).lojas[index]
                                                  ["loja"]["desconto"] ==
                                              "Indisponível")
                                      ? "0.0"
                                      : data2.values.elementAt(0).lojas[index]
                                          ["loja"]["precoFinal"],
                                );
                              },
                            ),
                          )
                        ],
                      );
                    });
              })),
        ));
  }
}
