import 'package:flutter/material.dart';
import 'package:app_lista_tarefas/views/listaTarefas.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListaTarefas(),
    );
  }
}


