// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_verificai/model/database.dart';
import 'package:project_verificai/utilsView/productView.dart';
import 'package:project_verificai/utilsView/searchView.dart';
import 'package:project_verificai/view/PageAddProductView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}


class _HomeViewState extends State<HomeView> {

  final _myBox = Hive.box('mybox');
  VerificaiDataBase db = VerificaiDataBase();

  @override
  void initState(){

    if(_myBox.get("listProduct") == null){
      db.createInitialData();
    }else{
      db.loadData();
    }

    super.initState();
  }

  void saveProduct(){
    setState(() {
      db.loadData();
    });
  }

  List productList = [
    ["lib/imgs/Logo_Instagram.png","banana", "13/04/2001", "baratao","31"],
  ];

  @override
  Widget build(BuildContext context) {
    
    print("List Home:");
    print(db.productList);
    return Scaffold(

      appBar: AppBar(
        title: const Text("Verificaí")
      ),

      body: Column(
        children: [
          Searchview(),
          Expanded(
            child: ListView.builder(
              itemCount: db.productList.length,
              itemBuilder: (context,index){
                

                return Productview(
                  urlImg: db.productList[index][0],
                  textProduct: db.productList[index][1],
                  dataValidade: db.productList[index][2],
                  nameStore: db.productList[index][3],
                  quantItens: db.productList[index][4],
                  functionSaved: saveProduct,
                );
              }
            )
          )
        ],
      ),
      


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Pageaddproductview(onSaved: saveProduct)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.green[900],
      ),



    );
  }
}