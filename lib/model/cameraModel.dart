import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ModelCamera {
  final imagePicker = ImagePicker();
  File? imageFile;

  final Function(File) onImagePicked;

  ModelCamera({required this.onImagePicked});

  // Função para salvar a imagem no diretório apropriado do sistema
  Future<String?> saveImage(String imagePath) async {
    try {
      // Obtém o diretório de documentos do aplicativo
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Cria o caminho completo para o diretório onde queremos salvar a imagem
      final Directory saveDir = Directory('${appDir.path}/images');

      // Cria o diretório, caso não exista
      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }

      // Define o nome da imagem a partir do caminho original
      final String imageName = imagePath.split('/').last; 
      final String savePath = '${saveDir.path}/$imageName';

      // Salva a imagem no diretório especificado
      await File(imagePath).copy(savePath);

      print('Imagem salva em: $savePath');
      return savePath;
    } catch (e) {
      print('Erro ao salvar a imagem: $e');
      return null;
    }
  }

  // Função para selecionar uma imagem e salvar no diretório
  Future<void> pickImage(ImageSource source) async {
    try {
      // Seleciona a imagem usando o ImagePicker
      final pickedFile = await imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        imageFile = File(pickedFile.path);

        // Salva a imagem no diretório e obtém o caminho salvo
        String? savedImagePath = await saveImage(imageFile!.path);

        if (savedImagePath != null) {
          // Atualiza a referência do File com o caminho salvo
          imageFile = File(savedImagePath);

          // Chama a função passada pelo construtor com o arquivo salvo
          onImagePicked(imageFile!);
        } else {
          print('Falha ao salvar a imagem.');
        }
      }
    } catch (e) {
      print('Erro ao selecionar a imagem: $e');
    }
  }
}
