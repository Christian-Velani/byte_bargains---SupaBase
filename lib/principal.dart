// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'dart:math';

import 'package:byte_bargains/meus_widgets.dart';
import 'package:byte_bargains/styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrincipalPage extends StatelessWidget {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    Future<Map<String, Jogo>> buscarJogosPrincipal() async {
      Map<String, Jogo> jogosFinais = {};
      List<String> listaJogosPromocao = [];
      String caracteresPossiveis =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      while (listaJogosPromocao.length != 5) {
        var random = Random();
        var caracter =
            caracteresPossiveis[random.nextInt(caracteresPossiveis.length)];
        final lista = await supabase
            .from("LojasPreços")
            .select("idJogo")
            .in_("desconto", ["0.5", "0.6", "0.7", "0.8", "0.9"])
            .not("idJogo", "in", listaJogosPromocao)
            .ilike("idJogo", "$caracter%")
            .limit(1);
        if (lista.length != 0) {
          listaJogosPromocao.add(lista[0]["idJogo"]);
        }
      }
      final informacoesJogo = await supabase
          .from("Jogos")
          .select('''nomeJogo, imagem, descricao''').in_(
              "nomeJogo", listaJogosPromocao);
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

    return FutureBuilder(
        future: buscarJogosPrincipal(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var data2 = snapshot.data;
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
                child: ListView.builder(
                  itemCount: data2!.length,
                  padding: EdgeInsets.all(20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Jogo jogo = data2.values.elementAt(index);
                    return JogoGrande(
                        Image.network(
                          jogo.imagem,
                          fit: BoxFit.fill,
                        ),
                        jogo.nome,
                        "Em grande promoção no momento");
                  },
                ),
              )
            ],
          );
        }));
  }
}
