class Tarefa {
  int? id;
  String titulo;
  String descricao;
  String dataPrevista; // TEXT no SQLite: formato yyyy-MM-dd
  bool importante;
  bool realizada;
  String categoria;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.dataPrevista,
    this.importante = false,
    this.realizada = false,
    required this.categoria,
  });

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      dataPrevista: map['dataPrevista'] as String,
      importante: (map['importante'] as int) == 1,
      realizada: (map['realizada'] as int) == 1,
      categoria: map['categoria'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'dataPrevista': dataPrevista,
      'importante': importante ? 1 : 0,
      'realizada': realizada ? 1 : 0,
      'categoria': categoria,
    };
  }
}
