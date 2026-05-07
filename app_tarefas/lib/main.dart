import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tarefas/providers/tarefa_provider.dart';
import 'package:app_tarefas/telas/tela_bem_vindo.dart';
import 'package:app_tarefas/telas/tela_categorias.dart';
import 'package:app_tarefas/telas/tela_detalhes.dart';
import 'package:app_tarefas/telas/tela_form_tarefa.dart';
import 'package:app_tarefas/telas/tela_listagem.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TarefaProvider(),
      child: MaterialApp(
        home: TelaBemVindo(),
      ),
    ),
  );
}