import 'package:flutter/material.dart';
import 'package:app_tarefas/models/tarefa.dart';
import 'package:intl/intl.dart';

class TarefaCard extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TarefaCard({
    super.key,
    required this.tarefa,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hoje = DateTime.now();
    final dataP = DateTime.tryParse(tarefa.dataPrevista);
    final atrasada = dataP != null &&
        !tarefa.realizada &&
        dataP.isBefore(DateTime(hoje.year, hoje.month, hoje.day));

    final dataFormatada = dataP != null
        ? DateFormat('dd/MM/yyyy').format(dataP)
        : tarefa.dataPrevista;

    // Cor da borda lateral esquerda — só para indicar estado
    Color corIndicador = Colors.transparent;
    if (tarefa.realizada) {
      corIndicador = Colors.green;
    } else if (atrasada) {
      corIndicador = Colors.red;
    } else if (tarefa.importante) {
      corIndicador = Colors.amber;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: corIndicador, width: 3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tarefa.titulo,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: tarefa.realizada
                            ? TextDecoration.lineThrough
                            : null,
                        color: tarefa.realizada ? Colors.grey : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          tarefa.categoria,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                        const Text('  ·  ',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey)),
                        Text(
                          dataFormatada,
                          style: TextStyle(
                            fontSize: 12,
                            color: atrasada ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (tarefa.importante && !tarefa.realizada)
                const Icon(Icons.star, color: Colors.amber, size: 18),
              if (tarefa.realizada)
                const Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 18),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 18, color: Colors.grey),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
