// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_verificai/view/PageProductView.dart';
import 'package:intl/intl.dart';

class Productview extends StatelessWidget {
  final String urlImg;
  final String textProduct;
  final String dataValidade;
  final String nameStore;
  final String quantItens;
  final Function functionSaved;

  Productview({
    super.key,
    required this.urlImg,
    required this.textProduct,
    required this.dataValidade,
    required this.nameStore,
    required this.quantItens,
    required this.functionSaved,
  });

  @override
  Widget build(BuildContext context) {
    // Debugging the image path/url
    print(urlImg);

    // Parsing and formatting the date if necessary
    DateTime? validadeParsed;
    String validadeFormatada = dataValidade;

    try {
      validadeParsed = DateFormat('yyyy-MM-dd').parse(dataValidade);
      validadeFormatada = DateFormat('dd/MM/yyyy').format(validadeParsed);
    } catch (e) {
      print("Data de validade no formato incorreto: $dataValidade");
    }

    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pageproductview(
              textProduct: textProduct,
              imagem: urlImg,
              validade: validadeFormatada,
              store: nameStore,
              itens: quantItens,
              onSaved: functionSaved,
            ),
          ),
        );
      },
      hoverColor: Colors.green[200],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          margin: const EdgeInsets.only(bottom: 15, top: 15),
          color: Colors.green[100],
          width: 550,
          height: 100,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: _buildImage(urlImg),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    textProduct,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(right: 13, bottom: 4),
                child: Text(
                  "Validade: $validadeFormatada",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função auxiliar para exibir a imagem corretamente dependendo da origem (asset, url ou arquivo)
  Widget _buildImage(String path) {
    if (Uri.parse(path).isAbsolute) {
      // Caso seja uma URL (Internet)
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.broken_image, size: 80); // Exibe um ícone de erro caso a imagem falhe ao carregar
        },
      );
    } else if (File(path).existsSync()) {
      // Caso seja um arquivo local
      return Image.file(
        File(path),
        fit: BoxFit.cover,
      );
    } else {
      // Caso seja um asset local
      return Image.asset(
        path,
        fit: BoxFit.cover,
      );
    }
  }
}
