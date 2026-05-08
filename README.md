# App de Tarefas

## Como rodar

```bash
flutter pub get
flutter run
```

## Estrutura

```
lib/
  main.dart
  models/     tarefa.dart, categoria.dart
  db/         db_util.dart
  providers/  tarefa_provider.dart
  telas/      tela_bem_vindo, listagem, detalhes, form_tarefa, categorias
  componentes/ tarefa_card, botao_estilizado
```

## Commits

1. Projeto base Flutter
2. pubspec + models (Tarefa, Categoria) + db_util
3. TarefaProvider
4. Telas: bem-vindo e listagem
5. Telas: detalhes e formulário
6. Tela: categorias
7. Componentes: TarefaCard e BotaoEstilizado
8. main.dart: rotas, tema minimalista, localização PT-BR
