import 'package:flutter/material.dart';
import 'package:project_verificai/model/database.dart';

class Pageproductview extends StatelessWidget {

  final String textProduct;
  final String imagem;
  final String validade;
  final String store;
  final String itens;
  var onSaved;

  

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
                image: DecorationImage(image: AssetImage(imagem), fit: BoxFit.cover)
              ),
            ),

            Column(
              children: [
                Container(
                  child: Text(
                    "Nome do Produto: "+textProduct,
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ),
                Container(
                  child: Text(
                    "Loja: "+store,
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ),
                Container(
                  child: Text(
                    "Quantidade de Itens: "+itens.toString(),
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ),

                Container(
                  child: Text(
                    "Data de Validade: "+validade,
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      ),

      
      floatingActionButton: Row(
        children: [
              FloatingActionButton(
                onPressed: (){
                  String rmv_product = textProduct;
                  db.loadData();
                  for(int i = 0; i < db.productList.length;i++){
                    if(db.productList[i][1] == rmv_product){
                      db.productList.removeAt(i);
                      break;
                    }
                  }
                  db.updateDataBase();
                  onSaved();
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
                foregroundColor: Colors.red[900],
          ),
              FloatingActionButton(
            onPressed: (){
              String rmv_product = textProduct;
              db.loadData();
              for(int i = 0; i < db.productList.length;i++){
                if(db.productList[i][1] == rmv_product){
                  db.productList.removeAt(i);
                  break;
                }
              }
              db.updateDataBase();
              onSaved();
              Navigator.of(context).pop();
            },
            child: Icon(Icons.change_circle),
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.yellow[900],
          ),
        ],
      ),




    );
  }
}


/**FloatingActionButton(
        onPressed: (){
          String rmv_product = textProduct;
          db.loadData();
          for(int i = 0; i < db.productList.length;i++){
            if(db.productList[i][1] == rmv_product){
              db.productList.removeAt(i);
              break;
            }
          }
          db.updateDataBase();
          onSaved();
          Navigator.of(context).pop();
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.red,
        foregroundColor: Colors.red[900],
      ), */