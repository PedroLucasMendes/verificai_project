import 'package:hive_flutter/hive_flutter.dart';

class VerificaiDataBase {

  List productList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData(){
    productList = [
      ["lib/imgs/banana.jpeg","banana", "13/04/2001", "baratao","31"],
    ];
    _myBox.put("listProduct", productList);
  }


  void loadData(){
    productList = _myBox.get("listProduct");
  }

  void updateDataBase(){
    _myBox.put("listProduct", productList);
  }

  void deleteDatabase(){
    _myBox.delete("listProduct");
  }
}