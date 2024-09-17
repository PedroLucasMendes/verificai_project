import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ModelCamera {
  final imagePicker = ImagePicker();
  File? imageFile;

  final Function(File) onImagePicked;

  ModelCamera({required this.onImagePicked});

  // Função para salvar a imagem no diretório lib/imgs/fotos/
  Future<String?> salveImage(String imagePath) async {
    try {
      // Obtém o diretório do aplicativo
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Cria o caminho completo para o diretório onde queremos salvar a imagem
      final Directory saveDir = Directory('${appDir.path}/lib/imgs/fotos');
      
      // Cria o diretório, caso não exista
      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }

      // Define o caminho completo da imagem
      final String imageName = imagePath.split('/').last; // Obtém o nome da imagem
      final String savePath = '${saveDir.path}/$imageName';

      // Salva a imagem no diretório especificado
      await File(imagePath).copy(savePath);

      print('Imagem salva em: $savePath');
      return savePath;
    } catch (e) {
      print('Erro ao salvar a imagem: $e');
      return "erro:30"; // Você pode decidir como lidar com esse erro
    }
  }

  // Função para pegar apenas o nome do arquivo
  String getFileName(String filePath) {
    return filePath.split('/').last;
  }

  // Função para selecionar uma imagem e salvar no diretório lib/imgs/fotos/
  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);

      // Salva a imagem no diretório lib/imgs/fotos/ e obtém o caminho salvo
      String? savedImagePath = await salveImage(imageFile!.path);

      if (savedImagePath != null && savedImagePath != "erro:30") {
        // Atualiza a referência do File com o caminho salvo
        imageFile = File(savedImagePath);

        // Chama a função passada pelo construtor com o arquivo salvo
        onImagePicked(imageFile!);
      } else {
        print('Falha ao salvar a imagem.');
      }
    }
  }
}
