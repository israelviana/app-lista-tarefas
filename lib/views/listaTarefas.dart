import 'package:app_lista_tarefas/models/Tarefa.dart';
import 'package:app_lista_tarefas/repositories/listaTarefasRepositorio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/TarefaItens.dart';

enum TypeModalDeletarTarefas {deletarTodasTarefas}

class ListaTarefas extends StatefulWidget {
  ListaTarefas({Key? key}) : super(key: key);

  @override
  State<ListaTarefas> createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  List<Tarefa> tarefas = [];

  final TextEditingController tarefasController = TextEditingController();
  final listaTarefasRepositorio tarefasRepositorio = listaTarefasRepositorio();

  Tarefa? tarefaDeletada;
  int? posicaoDaTarefa;

  String? erroText;

  @override
  void initState() {
    super.initState();

    listaTarefasRepositorio().getListaTarefas().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            errorText: erroText,
                            labelText: "Adicione uma Tarefa",
                            hintText: "Estude uma tarefa",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xffC8B05F),
                                width: 2
                              )
                            ),
                          labelStyle: TextStyle(
                            color: Color(0xffC8B05F)
                          )
                        ),
                            controller: tarefasController,
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String tarefa = tarefasController.text;
                        if(tarefa.isEmpty){
                           setState((){
                             erroText = "Nenhuma tarefa inserida!";
                           });
                           return;
                        }

                        setState((){
                          Tarefa newTarefa = Tarefa(
                              title: tarefa,
                              dateTime: DateTime.now(),
                          );
                          tarefas.add(newTarefa);
                          erroText = null;
                        });
                        tarefasController.clear();
                        tarefasRepositorio.salvarListaTarefas(tarefas);
                      },
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xffC8B05F),
                          padding: EdgeInsets.all(14)),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for(Tarefa tarefa in tarefas)
                        TarefaItens(
                          tarefa: tarefa,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Voce possui ${tarefas.length} tarefa pendentes",
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                          _modalDeleteTarefas(TypeModalDeletarTarefas.deletarTodasTarefas);
                      },
                      child: Text("Limpar tudo"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffC8B05F),
                        padding: EdgeInsets.all(14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Callback
  void onDelete(Tarefa tarefa){
    tarefaDeletada = tarefa;
    posicaoDaTarefa = tarefas.indexOf(tarefa);

    setState((){
      tarefas.remove(tarefa);
    });
    tarefasRepositorio.salvarListaTarefas(tarefas);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
          Text("Tarefa ${tarefa.title} foi removida com sucesso!"),
          elevation: 5,
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: "Desfazer",
              textColor: Colors.white,
              onPressed: (){
                setState((){
                  tarefas.insert(posicaoDaTarefa!, tarefaDeletada!);
                });
                tarefasRepositorio.salvarListaTarefas(tarefas);
              }
          ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  _modalDeleteTarefas(TypeModalDeletarTarefas modal) {
    double heightModal = 150;
    double wightModal = 300;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                backgroundColor: Colors.white,
                insetPadding: EdgeInsets.all(8),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                        height: heightModal,
                        width: wightModal,
                        child: Column(
                          children: [
                            Row(
                              children: [
                               Column(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text(
                                       "Deseja deletar todas as tarefas?",
                                       style: TextStyle(
                                           fontSize: 18,
                                           fontFamily: "Roboto",
                                           fontWeight: FontWeight.w500
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                              ],
                            ),
                            SizedBox(height: 65),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF222225),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                TextButton(
                                  onPressed: () {
                                      Navigator.of(context).pop();
                                      apagarTarefas();
                                  },
                                  child: const Text(
                                    'Confirmar',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF222225),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ));
          },
        );
      },
    );
  }

  void apagarTarefas(){
    setState((){
      tarefas.clear();
    });
    tarefasRepositorio.salvarListaTarefas(tarefas);
  }

}
