// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:byte_bargains/meus_widgets.dart';
import 'package:byte_bargains/styles.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrincipalPage extends StatelessWidget {
  final supabase = Supabase.instance.client;

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
      jogos.forEach((jogo) {
        jogosFinais[jogo] = Jogo("", "", "", [], []);
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
          data!.forEach((info) => listaJogosDesejados.add(info["jogoId"]));
          return FutureBuilder(
              future: buscarJogosPrincipal(listaJogosDesejados),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
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
                              "Da sua lista de Desejos");
                        },
                      ),
                    )
                  ],
                );
              }));
          // ,
          // );
        });
// ,
// );
// }
// }
  }
}
