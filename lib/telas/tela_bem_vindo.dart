import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tarefas/providers/tarefa_provider.dart';
import 'package:intl/intl.dart';

class TelaBemVindo extends StatefulWidget {
  const TelaBemVindo({super.key});

  @override
  State<TelaBemVindo> createState() => _TelaBemVindoState();
}

class _TelaBemVindoState extends State<TelaBemVindo> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TarefaProvider>().carregar());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TarefaProvider>();
    final proxima = provider.tarefaMaisProxima;

    String dataFormatada = '';
    if (proxima != null) {
      final dataP = DateTime.tryParse(proxima.dataPrevista);
      if (dataP != null) {
        dataFormatada = DateFormat('dd/MM/yyyy').format(dataP);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              const Text(
                'Tarefas',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Bem-vindo de volta.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              if (proxima != null) ...[
                const Text(
                  'PRÓXIMA A VENCER',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  proxima.titulo,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  dataFormatada,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ] else ...[
                const Text(
                  'Nenhuma tarefa pendente.',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pushNamed(context, '/lista'),
                  child: const Text('Ver tarefas'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
