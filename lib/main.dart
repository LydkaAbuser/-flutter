import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа - Прокопенко Илья Андреевич'),
          backgroundColor: const Color.fromARGB(255, 98, 139, 173),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 16.0,
        runSpacing: 16.0,
        children: [
          // Контейнер 1
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(8.0),
            color: Colors.red,
            child: Icon(
              Icons.star,
              color: Colors.white,
              size: 40,
            ),
          ),
          // Контейнер 2
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(8.0),
            color: Colors.green,
            child: Icon(
              Icons.favorite,
              color: Colors.white,
              size: 40,
            ),
          ),
          // Контейнер 3
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(8.0),
            color: Colors.blue,
            child: Icon(
              Icons.home,
              color: Colors.white,
              size: 40,
            ),
          ),
          // Контейнер 4
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(8.0),
            color: Colors.orange,
            child: Icon(
              Icons.email,
              color: Colors.white,
              size: 40,
            ),
          ),
          // Контейнер 5
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(8.0),
            color: Colors.purple,
            child: Icon(
              Icons.phone,
              color: Colors.white,
              size: 40,
            ),
          ),
          // Контейнер 6
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.all(8.0),
            color: Colors.teal,
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}