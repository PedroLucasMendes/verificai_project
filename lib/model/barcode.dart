import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class BarCodeModel{

  final Function(String) onBarCode;

  BarCodeModel({required this.onBarCode});


  readBarCode() async{
    String code = await  FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF", 
      "Cancelar", 
      false, 
      ScanMode.BARCODE
    );

    if(code == "-1"){
      onBarCode(code);
    }else{
      onBarCode("Não validado");
    }


  }

}