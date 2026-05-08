import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tarefas/models/tarefa.dart';
import 'package:app_tarefas/providers/tarefa_provider.dart';
import 'package:intl/intl.dart';

class TelaDetalhes extends StatelessWidget {
  const TelaDetalhes({super.key});

  @override
  Widget build(BuildContext context) {
    final tarefa =
        ModalRoute.of(context)!.settings.arguments as Tarefa;
    final provider = context.read<TarefaProvider>();

    final dataP = DateTime.tryParse(tarefa.dataPrevista);
    final dataFormatada =
        dataP != null ? DateFormat('dd/MM/yyyy').format(dataP) : tarefa.dataPrevista;

    final hoje = DateTime.now();
    final atrasada = dataP != null &&
        !tarefa.realizada &&
        dataP.isBefore(DateTime(hoje.year, hoje.month, hoje.day));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, '/editar', arguments: tarefa),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID #${tarefa.id}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              tarefa.titulo,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Descrição',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(tarefa.descricao),
            const SizedBox(height: 20),
            _InfoRow(
              label: 'Categoria',
              value: tarefa.categoria,
            ),
            _InfoRow(
              label: 'Data prevista',
              value: dataFormatada,
              valueColor: atrasada ? Colors.red : null,
            ),
            _InfoRow(
              label: 'Importante',
              value: tarefa.importante ? 'Sim' : 'Não',
              valueColor: tarefa.importante ? Colors.amber : null,
            ),
            _InfoRow(
              label: 'Situação',
              value: tarefa.realizada
                  ? 'Realizada'
                  : atrasada
                      ? 'Atrasada'
                      : 'Pendente',
              valueColor: tarefa.realizada
                  ? Colors.green
                  : atrasada
                      ? Colors.red
                      : null,
            ),
            const Spacer(),
            if (!tarefa.realizada)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    await provider.marcarRealizada(tarefa);
                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Marcar como realizada'),
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.green),
                ),
              ),
            if (tarefa.realizada)
              const Center(
                child: Text('Tarefa concluída.',
                    style: TextStyle(color: Colors.green)),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.grey, fontSize: 13)),
          ),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                  fontSize: 13)),
        ],
      ),
    );
  }
}
