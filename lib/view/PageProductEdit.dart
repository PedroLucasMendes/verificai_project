import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_verificai/model/barcode.dart';
import 'package:project_verificai/model/database.dart';
import 'package:project_verificai/model/cameraModel.dart';
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  final String product;
  final String imagePath;
  final String validade;
  final String store;
  final String itens;
  final Function onSaved;
  final Function onAtt;

  EditProductPage({
    required this.product,
    required this.imagePath,
    required this.validade,
    required this.store,
    required this.itens,
    required this.onSaved,
    required this.onAtt,
  });

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _productController;
  late TextEditingController _storeController;
  late TextEditingController _validadeController;
  late TextEditingController _itensController;
  late VerificaiDataBase db;
  File? _imageFile;
  late ModelCamera _modelCamera;

  @override
  void initState() {
    super.initState();
    _productController = TextEditingController(text: widget.product);
    _storeController = TextEditingController(text: widget.store);
    _validadeController = TextEditingController(text: widget.validade);
    _itensController = TextEditingController(text: widget.itens);
    db = VerificaiDataBase();

    _imageFile = File(widget.imagePath);

    _modelCamera = ModelCamera(onImagePicked: (File file) {
      setState(() {
        _imageFile = file;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Nome do Produto
            _buildProductNameInput(),
            // Input Loja
            _buildStoreInput(),
            // Input Data de Validade
            _buildDateInput(),
            // Input Quantidade de Itens
            _buildQuantityInput(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text("Salvar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para salvar o produto editado
  void _saveProduct() {
    db.loadData();
    for (int i = 0; i < db.productList.length; i++) {
      if (db.productList[i][1] == widget.product) {
        db.productList[i][0] = _imageFile?.path ?? widget.imagePath;  // Caminho da imagem
        db.productList[i][1] = _productController.text;  // Nome do produto
        db.productList[i][2] = _validadeController.text;  // Data de validade
        db.productList[i][3] = _storeController.text;  // Loja
        db.productList[i][4] = _itensController.text;  // Quantidade de itens
        break;
      }
    }
    db.updateDataBase();
    widget.onSaved();
    widget.onAtt(
      _productController.text,
      _storeController.text,
      _validadeController.text,
      _itensController.text,
    );
    Navigator.of(context).pop();
  }

  // Widget para o campo de nome do produto
  Widget _buildProductNameInput() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _productController,
        decoration: InputDecoration(
          labelText: "Nome do Produto",
          labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
      ),
    );
  }

  // Widget para o campo de loja
  Widget _buildStoreInput() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _storeController,
        decoration: InputDecoration(
          labelText: "Loja",
          labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
      ),
    );
  }

  // Widget para o campo de data de validade
  Widget _buildDateInput() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _validadeController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Data de Validade",
          labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
          prefixIcon: Icon(Icons.calendar_today, color: Colors.green[900]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
        onTap: _selectDate,
      ),
    );
  }

  // Widget para o campo de quantidade de itens
  Widget _buildQuantityInput() {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _itensController,
        decoration: InputDecoration(
          labelText: "Quantidade de Itens",
          labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  // Widget para o container de imagem
  Widget _buildImageContainer() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(border: Border.all(width: 1), color: Colors.white),
      child: IconButton(
        onPressed: () => _modelCamera.pickImage(ImageSource.camera),
        icon: _imageFile != null
            ? Image.file(_imageFile!)
            : Image.asset(widget.imagePath),
      ),
    );
  }

  // Método para selecionar uma data
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.black,
              onSurface: Colors.green,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _validadeController.text = pickedDate.toString().split(" ")[0]; // Formato da data: yyyy-mm-dd
      });
    }
  }
}
