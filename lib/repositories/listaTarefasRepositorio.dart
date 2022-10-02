import 'dart:convert';

import 'package:app_lista_tarefas/models/Tarefa.dart';
import 'package:shared_preferences/shared_preferences.dart';

const listaTarefasKey = "listaTarefas";

class listaTarefasRepositorio{
  late SharedPreferences sharedPreferences;

  Future<List<Tarefa>> getListaTarefas() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(listaTarefasKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Tarefa.fromJson(e)).toList();
  }

  void salvarListaTarefas(List<Tarefa> tarefas){
    final jsonString = jsonEncode(tarefas);
    sharedPreferences.setString("listaTarefas", jsonString);
    print(jsonString);
  }
}