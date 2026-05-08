import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tarefas/providers/tarefa_provider.dart';

class TelaCategorias extends StatelessWidget {
  const TelaCategorias({super.key});

  void _adicionarCategoria(BuildContext context) {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nova categoria'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration:
              const InputDecoration(hintText: 'Nome da categoria'),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final nome = ctrl.text.trim();
              if (nome.isEmpty) return;
              await context.read<TarefaProvider>().adicionarCategoria(nome);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categorias = context.watch<TarefaProvider>().categorias;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
      ),
      body: categorias.isEmpty
          ? const Center(
              child: Text('Nenhuma categoria cadastrada.',
                  style: TextStyle(color: Colors.grey)),
            )
          : ListView.separated(
              itemCount: categorias.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (context, i) {
                final cat = categorias[i];
                return ListTile(
                  title: Text(cat.nome),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.grey, size: 20),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Excluir categoria'),
                          content: Text(
                              'Excluir "${cat.nome}"? Tarefas com essa categoria não serão apagadas.'),
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
                      if (ok == true && cat.id != null) {
                        await context
                            .read<TarefaProvider>()
                            .deletarCategoria(cat.id!);
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarCategoria(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
