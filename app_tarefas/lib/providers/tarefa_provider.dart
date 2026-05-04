import 'package:flutter/material.dart';
import 'package:app_tarefas/models/tarefa.dart';
import 'package:app_tarefas/models/categoria.dart';
import 'package:app_tarefas/db/db_util.dart';

class TarefaProvider extends ChangeNotifier {
  List<Tarefa> _tarefas = [];
  List<Categoria> _categorias = [];

  List<Tarefa> get tarefas => _tarefas;
  List<Categoria> get categorias => _categorias;
  List<String> get nomesCategorias => _categorias.map((c) => c.nome).toList();

  Tarefa? get tarefaMaisProxima {
    final pendentes = _tarefas.where((t) => !t.realizada).toList();
    if (pendentes.isEmpty) return null;
    pendentes.sort((a, b) => a.dataPrevista.compareTo(b.dataPrevista));
    return pendentes.first;
  }

  Future<void> carregar() async {
    _tarefas = await DBUtil.listTarefas();
    _categorias = await DBUtil.listCategorias();
    notifyListeners();
  }

  Future<void> adicionarTarefa(Tarefa tarefa) async {
    await DBUtil.insertTarefa(tarefa);
    _tarefas.add(tarefa);
    notifyListeners();
  }

  Future<void> editarTarefa(Tarefa tarefa) async {
    await DBUtil.updateTarefa(tarefa);
    final idx = _tarefas.indexWhere((t) => t.id == tarefa.id);
    if (idx != -1) {
      _tarefas[idx] = tarefa;
      notifyListeners();
    }
  }

  Future<void> deletarTarefa(int id) async {
    await DBUtil.deleteTarefa(id);
    _tarefas.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> marcarRealizada(Tarefa tarefa) async {
    tarefa.realizada = true;
    await DBUtil.updateTarefa(tarefa);
    final idx = _tarefas.indexWhere((t) => t.id == tarefa.id);
    if (idx != -1) {
      _tarefas[idx] = tarefa;
      notifyListeners();
    }
  }

  Future<void> adicionarCategoria(String nome) async {
    final cat = Categoria(nome: nome);
    await DBUtil.insertCategoria(cat);
    _categorias.add(cat);
    _categorias.sort((a, b) => a.nome.compareTo(b.nome));
    notifyListeners();
  }

  Future<void> deletarCategoria(int id) async {
    await DBUtil.deleteCategoria(id);
    _categorias.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
