// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:byte_bargains/meus_widgets.dart';
import 'package:byte_bargains/styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListaDesejosPage extends StatelessWidget {
  Map<String, List<Jogo>> generosJogos = {};
  final supabase = Supabase.instance.client;

  ListaDesejosPage({super.key});

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

    Future<Map<String, Jogo>> buscarJogosPrincipal(List<String> jogos) async {
      Map<String, Jogo> jogosFinais = {};
      final informacoesJogo = await supabase
          .from("Jogos")
          .select('''nomeJogo, imagem, descricao''').in_("nomeJogo", jogos);
      final generosJogo = await supabase
          .from("GenerosJogos")
          .select('''idGenero, idJogo''').in_("idJogo", jogos);
      final lojasJogo = await supabase
          .from("LojasPreços")
          .select('''nomeLoja, precoInicial, desconto, precoFinal, idJogo''').in_(
              "idJogo", jogos);
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
                "loja": loja["nomeloja"],
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

    return FutureBuilder(
        future: pegarListaDesejos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var data = snapshot.data;
          List<String> listaJogosDesejados = [];
          for (var info in data!) {
            listaJogosDesejados.add(info["jogoId"]);
          }
          return FutureBuilder(
              future: buscarJogosPrincipal(listaJogosDesejados),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var data2 = snapshot.data;
                var keys = data2!.keys;
                for (var chave in keys) {
                  for (var genero in data2[chave]!.generos) {
                    if (generosJogos[genero] == null) {
                      generosJogos[genero] = [data2[chave]!];
                    } else {
                      generosJogos[genero]!.add(data2[chave]!);
                    }
                  }
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
              }));
          // );
        });
  }
}
