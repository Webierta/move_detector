import 'package:flutter/material.dart';
import 'ajustes.dart';
import 'radar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      //home: Radar(),
      routes: {
        '/': (context) => Radar(),
        '/ajustes': (context) => Ajustes(),
      },
    );
  }
}
