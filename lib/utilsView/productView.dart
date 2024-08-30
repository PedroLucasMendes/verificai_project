// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:project_verificai/view/PageProductView.dart';
import 'package:intl/intl.dart';

class Productview extends StatelessWidget {

  final String urlImg;
  final String textProduct;
  final String dataValidade;
  final String nameStore;
  final String quantItens;
  var functionSaved;

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
    print(urlImg);
    return MaterialButton(
      onPressed: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => 
            Pageproductview(
              textProduct: textProduct,            
              imagem: urlImg, 
              validade: dataValidade,
              store: nameStore,
              itens: quantItens,
              onSaved: functionSaved,
            )
          )
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
                  child: Image.asset(urlImg),
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
                padding: const EdgeInsets.only(right:13, bottom: 4),
                child: Text(
                  "Validade: $dataValidade",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}
