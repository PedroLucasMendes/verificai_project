import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_verificai/model/database.dart';
import 'package:project_verificai/view/PageProductEdit.dart';

class Pageproductview extends StatefulWidget {
  final String textProduct;
  final String imagem;
  final String validade;
  final String store;
  final String itens;
  final Function onSaved;

  Pageproductview({
    super.key,
    required this.textProduct,
    required this.imagem,
    required this.validade,
    required this.store,
    required this.itens,
    required this.onSaved,
  });

  @override
  _PageproductviewState createState() => _PageproductviewState();
}

class _PageproductviewState extends State<Pageproductview> {
  // Variáveis para armazenar os valores que podem ser atualizados
  late String textProduct;
  late String imagem;
  late String validade;
  late String store;
  late String itens;

  @override
  void initState() {
    super.initState();
    // Inicialize as variáveis com os valores do widget
    textProduct = widget.textProduct;
    imagem = widget.imagem;
    validade = widget.validade;
    store = widget.store;
    itens = widget.itens;
  }

  // Função para atualizar a view
  void attView(String newProduct, String newStore, String newDate, String newItens) {
    setState(() {
      textProduct = newProduct;
      store = newStore;
      validade = newDate;
      itens = newItens;
    });
  }

  @override
  Widget build(BuildContext context) {
    VerificaiDataBase db = VerificaiDataBase();

    return Scaffold(
      appBar: AppBar(
        title: Text(textProduct),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(width: 3),
                borderRadius: BorderRadius.circular(12),
                // Use FileImage se a imagem for do sistema de arquivos
                image: File(imagem).existsSync()
                    ? DecorationImage(image: FileImage(File(imagem)), fit: BoxFit.cover)
                    : DecorationImage(image: AssetImage(imagem), fit: BoxFit.cover),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nome do Produto: $textProduct",
                  style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Loja: $store",
                  style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Quantidade de Itens: $itens",
                  style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Data de Validade: $validade",
                  style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Botão de remover produto
          FloatingActionButton(
            onPressed: () {
              String rmv_product = textProduct;
              db.loadData();
              for (int i = 0; i < db.productList.length; i++) {
                if (db.productList[i][1] == rmv_product) {
                  db.productList.removeAt(i);
                  break;
                }
              }
              db.updateDataBase();
              widget.onSaved();
              Navigator.of(context).pop();
            },
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          // Botão de editar produto
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProductPage(
                    product: textProduct,
                    imagePath: imagem,
                    validade: validade,
                    store: store,
                    itens: itens,
                    onSaved: widget.onSaved,
                    onAtt: attView, // Passando a função attView
                  ),
                ),
              );
            },
            child: Icon(Icons.edit),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
