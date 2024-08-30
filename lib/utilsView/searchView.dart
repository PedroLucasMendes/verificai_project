// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Searchview extends StatefulWidget {
  const Searchview({super.key});

  @override
  State<Searchview> createState() => _SearchviewState();
}

class _SearchviewState extends State<Searchview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: 300,
        child: TextField(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
          decoration: InputDecoration(
            labelText: "Pesquisar Produto",
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
            suffixIcon: Icon(Icons.search,color: Colors.green[900],),
          ),
        ),
      )
    );
  }
}