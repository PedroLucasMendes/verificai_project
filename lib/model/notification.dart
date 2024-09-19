import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_verificai/model/database.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Chave para a tarefa agendada
const String checkExpirationTask = "checkExpirationTask";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa notificações
  await initNotifications();
  
  // Inicializa o WorkManager
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // Altere para false em produção
  );

  // Agenda a tarefa diária
  Workmanager().registerPeriodicTask(
    "1", // ID da tarefa
    checkExpirationTask,
    frequency: Duration(days: 1), // Verifica diariamente
  );

  runApp(MyApp());
}

// Função para inicializar as notificações
Future<void> initNotifications() async {
  final AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('app_icon');
  final DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      // Lida com a notificação quando o app está em background
    },
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: darwinInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Função chamada em background pelo WorkManager
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    VerificaiDataBase db = VerificaiDataBase();
    db.loadData(); // Carrega os dados do banco de dados

    DateTime today = DateTime.now();
    for (var product in db.productList) {
      DateTime expirationDate = DateTime.parse(product[2]); // Data de validade
      if (expirationDate.isBefore(today.add(Duration(days: 7))) && expirationDate.isAfter(today)) {
        await showNotification(product[1], expirationDate); // Notifica se o produto estiver próximo de vencer
      }
    }

    return Future.value(true); // Indica que a tarefa foi completada
  });
}

// Função para exibir a notificação
Future<void> showNotification(String productName, DateTime expirationDate) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'validade_produto_id',
    'Notificações de Validade de Produto',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Produto próximo da validade!',
    'O produto $productName está com a validade próxima (${expirationDate.toString().split(" ")[0]})',
    platformChannelSpecifics,
    payload: productName,
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VerificaiDataBase db = VerificaiDataBase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Product Expiration Tracker')),
        body: Center(
          child: ElevatedButton(
            onPressed: checkExpirationDates, // Para testar manualmente
            child: Text('Check Expirations'),
          ),
        ),
      ),
    );
  }

  // Função que verifica se algum produto está próximo da validade (para testes manuais)
  void checkExpirationDates() {
    DateTime today = DateTime.now();
    for (var product in db.productList) {
      DateTime expirationDate = DateTime.parse(product[2]); // Data de validade
      if (expirationDate.isBefore(today.add(Duration(days: 7))) && expirationDate.isAfter(today)) {
        showNotification(product[1], expirationDate); // Notifica se o produto estiver próximo de vencer
      }
    }
  }
}
