import 'package:app_tarefas/models/tarefa.dart';
import 'package:app_tarefas/models/categoria.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;

class DBUtil {
  static Future<sqlite.Database> _getDB() async {
    final databasePath = await sqlite.getDatabasesPath();
    final arqBD = path.join(databasePath, 'tarefas.db');

    return sqlite.openDatabase(
      arqBD,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Tarefa(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descricao TEXT NOT NULL,
            dataPrevista TEXT NOT NULL,
            importante INTEGER NOT NULL,
            realizada INTEGER NOT NULL,
            categoria TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE Categoria(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL UNIQUE
          )
        ''');

        // Categorias pré-definidas
        final categoriasPadrao = [
          'Trabalho',
          'Pessoal',
          'Estudo',
          'Saúde',
          'Casa',
        ];
        for (final nome in categoriasPadrao) {
          await db.insert('Categoria', {'nome': nome});
        }
      },
    );
  }

  static Future<void> insertTarefa(Tarefa tarefa) async {
    final db = await _getDB();
    final map = tarefa.toMap()..remove('id');
    tarefa.id = await db.insert('Tarefa', map);
  }

  static Future<List<Tarefa>> listTarefas() async {
    final db = await _getDB();
    final result = await db.query('Tarefa');
    return result.map((m) => Tarefa.fromMap(m)).toList();
  }

  static Future<int> updateTarefa(Tarefa tarefa) async {
    final db = await _getDB();
    return await db.update(
      'Tarefa',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  static Future<int> deleteTarefa(int id) async {
    final db = await _getDB();
    return await db.delete('Tarefa', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Categoria>> listCategorias() async {
    final db = await _getDB();
    final result = await db.query('Categoria', orderBy: 'nome ASC');
    return result.map((m) => Categoria.fromMap(m)).toList();
  }

  static Future<void> insertCategoria(Categoria categoria) async {
    final db = await _getDB();
    final map = categoria.toMap()..remove('id');
    categoria.id = await db.insert('Categoria', map);
  }

  static Future<int> deleteCategoria(int id) async {
    final db = await _getDB();
    return await db.delete('Categoria', where: 'id = ?', whereArgs: [id]);
  }
}
