// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:byte_bargains/styles.dart';
import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JogoGrande extends StatelessWidget {
  Image imagem;
  String nome;
  String minitexto;

  JogoGrande(this.imagem, this.nome, this.minitexto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            height: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            width: 350,
            child: GestureDetector(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50), child: imagem),
              onTap: () => Navigator.of(context)
                  .pushNamed('/Jogo', arguments: {"nomeJogo": nome}),
            ),
          ),
        ),
        Positioned(
          left: 40,
          bottom: 50,
          child: BlurryContainer(
            blur: 5,
            width: 310,
            elevation: 0,
            color: Colors.transparent,
            padding: const EdgeInsets.all(8),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Column(
              children: [
                Text(
                  nome,
                  style: textoOpenSansSemiBold,
                ),
                Text(
                  minitexto,
                  style: textoOpenSansRegularMini,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class JogoPequeno extends StatelessWidget {
  String imagem;
  String nome;

  JogoPequeno(this.imagem, this.nome, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.all(5),
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            width: 100,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  imagem,
                  fit: BoxFit.fill,
                )),
          ),
          onTap: () => Navigator.of(context)
              .pushNamed('/Jogo', arguments: {"nomeJogo": nome}),
        ),
        SizedBox(
            width: 100, child: Text(nome, style: textoOpenSansRegularPequeno))
      ],
    );
  }
}

class JogoPequenoHorizontal extends StatefulWidget {
  final String imagem;
  final String nome;
  final List<String> listaDesejos;

  const JogoPequenoHorizontal(
      {super.key,
      required this.imagem,
      required this.nome,
      required this.listaDesejos});

  @override
  State<JogoPequenoHorizontal> createState() => _JogoPequenoHorizontalState();
}

class _JogoPequenoHorizontalState extends State<JogoPequenoHorizontal> {
  final supabase = Supabase.instance.client;
  IconData icone = Icons.favorite_outline;
  Color cor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    if (widget.listaDesejos.contains(widget.nome)) {
      icone = Icons.favorite;
      cor = Colors.blue;
    }

    final User user = supabase.auth.currentUser!;

    Future<void> atualizarListaDesejos(String tipo, String jogo) async {
      if (tipo == "adicionar") {
        final response = await supabase
            .from("Listas de Desejos")
            .insert({"idUsuario": user.id, "jogoId": jogo});
        Future.delayed(const Duration(seconds: 5));
        return response;
      } else if (tipo == "remover") {
        final response = await supabase
            .from("Listas de Desejos")
            .delete()
            .match({"idUsuario": user.id, "jogoId": jogo});
        Future.delayed(const Duration(seconds: 5));
        return response;
      }
    }

    return SizedBox(
      width: 500,
      child: Row(
        children: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.all(5),
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              width: 70,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.imagem,
                    fit: BoxFit.fill,
                  )),
            ),
            onTap: () => Navigator.of(context)
                .pushNamed('/Jogo', arguments: {"nomeJogo": widget.nome}),
          ),
          SizedBox(
              width: 250,
              child: Text(
                widget.nome,
                style: textoOpenSansSemiBold,
              )),
          const Spacer(),
          IconButton(
            alignment: Alignment.centerRight,
            onPressed: () {
              if (icone == Icons.favorite_outline) {
                icone = Icons.favorite;
                cor = Colors.blue;
                widget.listaDesejos.add(widget.nome);
                atualizarListaDesejos("adicionar", widget.nome);
              } else {
                icone = Icons.favorite_outline;
                cor = Colors.grey;
                widget.listaDesejos.remove(widget.nome);
                atualizarListaDesejos("remover", widget.nome);
              }
              setState(() {});
            },
            icon: Icon(
              icone,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneroContainer extends StatelessWidget {
  String genero;
  List<Jogo>? jogos;

  GeneroContainer(this.genero, this.jogos, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(5, 10, 0, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            genero,
            style: textoOpenSansSemiBold,
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: jogos!
                .map((jogo) => JogoPequeno(jogo.imagem, jogo.nome))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class LojaPreco extends StatelessWidget {
  String nomeLoja;
  String preco;
  Estado estado;
  String precoDesconto;

  LojaPreco(this.nomeLoja, this.preco, this.estado,
      {this.precoDesconto = "0.00"});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      width: 321,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 41, 41, 41),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              nomeLoja,
              style: textoOpenSansRegularPequenoBranco,
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.monetization_on_outlined,
              color: Colors.blue,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: estado == Estado.normal
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child:
                        Text("R\$$preco", style: textoOpenSansRegularPequeno))
                : estado == Estado.desconto
                    ? Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Text(
                              "R\$$precoDesconto",
                              style: textoPrecoDesconto,
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child:
                                  Text("R\$$preco", style: textoPrecoOriginal))
                        ],
                      )
                    : Container(
                        margin: const EdgeInsets.all(10),
                        child: const Text(
                          "Indisponivel",
                          style: textoOpenSansRegularPequeno,
                        ),
                      ),
          )
        ],
      ),
    );
  }
}

class Jogo {
  String imagem;
  String nome;
  String descricao;
  List<String> generos;
  List<Map<String, dynamic>> lojas;

  Jogo(this.imagem, this.nome, this.descricao, this.lojas, this.generos);
}

enum Estado { normal, desconto, indisponivel }
