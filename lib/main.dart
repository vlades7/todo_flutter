import 'package:flutter/material.dart';
import 'package:todo_flutter/ListTasks.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter - список задач',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: ListTasks(),
    );
  }
}