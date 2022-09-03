import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/Tarefa.dart';

class TarefaItens extends StatelessWidget {
  const TarefaItens({Key? key, required this.tarefa, required this.onDelete})
      : super(key: key);

  final Tarefa tarefa;
  final Function(Tarefa) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(tarefa.dateTime),
                style: TextStyle(fontSize: 12),
              ),
              Text(
                tarefa.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        actionExtentRatio: 0.25,
        actionPane: const SlidableStrechActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: "Deletar",
            onTap: () {
              onDelete(tarefa);
            },
          ),
        ],
      ),
    );
  }
}
