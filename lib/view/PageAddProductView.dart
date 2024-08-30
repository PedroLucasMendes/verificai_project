// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_verificai/model/database.dart';

List<String> listStore = <String>['Baratão', "Açai"];

class Pageaddproductview extends StatefulWidget {

  var onSaved;

  Pageaddproductview({
    super.key,
    required this.onSaved,
  });

  @override
  State<Pageaddproductview> createState() => _PageaddproductviewState();
}

class _PageaddproductviewState extends State<Pageaddproductview> {

  _PageaddproductviewState();

  VerificaiDataBase db = VerificaiDataBase();

  String dropdownValue = listStore.first;

  void dropDownCallback(String? selectecValue){
    if(selectecValue is String){
      setState(() {
        dropdownValue = selectecValue;
      });
    }
  }

  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameProductController = TextEditingController();
  TextEditingController _storeController = TextEditingController();
  TextEditingController _quantController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Adicionar Produto"),
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 12, top: 12),
        child: Column(
          children: [
            //Input Nome do Produto
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 300,
                    height: 50,
                    child: TextField(
                      controller: _nameProductController,
                      decoration: InputDecoration(
                        labelText: "Nome do Produto",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900]
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: IconButton(
                      icon: Image.asset('lib/imgs/leitura-de-codigo-de-barras.png'),
                      
                      iconSize: 10,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            
        
            //Input Loja
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    child: DropdownMenu<String>(
                      controller: _storeController,
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )
                      ),
                      initialSelection: dropdownValue,
                      onSelected: dropDownCallback,
                      dropdownMenuEntries: listStore.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                      width: 300,
                      textStyle: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      
                      iconSize: 20,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            //Input Date Valid
            Row(
              children: [Container(
                padding: const EdgeInsets.only(top: 12),
                width: 300,
                child: TextField(
                  controller: _dateController,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.green[900]
                  ),

                  decoration: InputDecoration(
                    labelText: "Data de Validade",
                    labelStyle: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold
                    ),
                    
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.green[900],),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    )
                  ),
                  readOnly: true,
                  onTap: (){
                    _selectDate();
                  },
                ),
              ),]
            ),


            //Input Quantidade
            Row(
              children: [
                Container(
                  width: 300,
                  padding: EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: _quantController,
                    decoration: InputDecoration(
                      labelText: "Quantidade do produto",
                      labelStyle: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      )
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  )
                )
              ],
            ),


            Container(
              height: 200,
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                color: Colors.white
              ),
              child: IconButton(
                onPressed: (){},
                icon: Image.asset("lib/imgs/logo_upload_img.jpg"),
              ),
            ),

            Text("Clique na imagem para alterar")


          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          List<String> lst_products = ["lib/imgs/Logo_Instagram.png",_nameProductController.text, _dateController.text, _storeController.text, _quantController.text];
          db.loadData();
          db.productList.add(lst_products);
          db.updateDataBase();
          widget.onSaved();
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
        foregroundColor: Colors.green[900],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100),
      builder: (context, child){
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, 
              onPrimary: Colors.black, 
              onSurface: Colors.green)
          ), 
          child: child!
        );
      }
    );

    if(_picked != null){
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}