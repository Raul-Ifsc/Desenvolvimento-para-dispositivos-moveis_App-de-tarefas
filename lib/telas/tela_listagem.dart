import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tarefas/providers/tarefa_provider.dart';
import 'package:app_tarefas/models/tarefa.dart';
import 'package:app_tarefas/componentes/tarefa_card.dart';

class TelaListagem extends StatelessWidget {
  const TelaListagem({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.label_outline),
              tooltip: 'Categorias',
              onPressed: () =>
                  Navigator.pushNamed(context, '/categorias'),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Importantes'),
              Tab(text: 'Não imp.'),
              Tab(text: 'Realizadas'),
              Tab(text: 'Atrasadas'),
            ],
          ),
        ),
        body: Consumer<TarefaProvider>(
          builder: (context, provider, _) {
            final todas = provider.tarefas;
            final hoje = DateTime.now();
            final hojeData = DateTime(hoje.year, hoje.month, hoje.day);

            final importantes =
                todas.where((t) => t.importante && !t.realizada).toList();
            final naoImportantes =
                todas.where((t) => !t.importante && !t.realizada).toList();
            final realizadas =
                todas.where((t) => t.realizada).toList();
            final atrasadas = todas.where((t) {
              final d = DateTime.tryParse(t.dataPrevista);
              return d != null && !t.realizada && d.isBefore(hojeData);
            }).toList();

            return TabBarView(
              children: [
                _Lista(tarefas: todas, provider: provider),
                _Lista(tarefas: importantes, provider: provider),
                _Lista(tarefas: naoImportantes, provider: provider),
                _Lista(tarefas: realizadas, provider: provider),
                _Lista(tarefas: atrasadas, provider: provider),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/inserir'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  final List<Tarefa> tarefas;
  final TarefaProvider provider;

  const _Lista({required this.tarefas, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (tarefas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma tarefa aqui.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Agrupa por categoria
    final Map<String, List<Tarefa>> porCategoria = {};
    for (final t in tarefas) {
      porCategoria.putIfAbsent(t.categoria, () => []).add(t);
    }

    return ListView(
      children: [
        const SizedBox(height: 8),
        ...porCategoria.entries.expand((entry) => [
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  entry.key.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...entry.value.map(
                (tarefa) => TarefaCard(
                  tarefa: tarefa,
                  onTap: () => Navigator.pushNamed(
                      context, '/detalhes',
                      arguments: tarefa),
                  onDelete: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Excluir tarefa'),
                        content:
                            const Text('Deseja excluir esta tarefa?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(ctx, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(ctx, true),
                            child: const Text('Excluir',
                                style:
                                    TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await provider.deletarTarefa(tarefa.id!);
                    }
                  },
                ),
              ),
            ]),
        const SizedBox(height: 80),
      ],
    );
  }
}
