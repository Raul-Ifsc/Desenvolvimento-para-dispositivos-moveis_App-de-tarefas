import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tarefas/models/tarefa.dart';
import 'package:app_tarefas/providers/tarefa_provider.dart';
import 'package:intl/intl.dart';

class TelaFormTarefa extends StatefulWidget {
  const TelaFormTarefa({super.key});

  @override
  State<TelaFormTarefa> createState() => _TelaFormTarefaState();
}

class _TelaFormTarefaState extends State<TelaFormTarefa> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();

  DateTime? _dataSelecionada;
  bool _importante = false;
  String? _categoriaSelecionada;

  bool _modoEdicao = false;
  Tarefa? _tarefaOriginal;
  bool _inicializado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inicializado) return;
    _inicializado = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Tarefa) {
      _modoEdicao = true;
      _tarefaOriginal = args;
      _tituloCtrl.text = args.titulo;
      _descricaoCtrl.text = args.descricao;
      _importante = args.importante;
      _categoriaSelecionada = args.categoria;
      _dataSelecionada = DateTime.tryParse(args.dataPrevista);
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final hoje = DateTime.now();
    final minData = DateTime(hoje.year, hoje.month, hoje.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? minData,
      firstDate: minData, // impede data anterior a hoje
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) setState(() => _dataSelecionada = picked);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a data prevista.')),
      );
      return;
    }
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma categoria.')),
      );
      return;
    }

    final provider = context.read<TarefaProvider>();
    final dataStr = DateFormat('yyyy-MM-dd').format(_dataSelecionada!);

    if (_modoEdicao && _tarefaOriginal != null) {
      final editada = Tarefa(
        id: _tarefaOriginal!.id,
        titulo: _tituloCtrl.text.trim(),
        descricao: _descricaoCtrl.text.trim(),
        dataPrevista: dataStr,
        importante: _importante,
        realizada: _tarefaOriginal!.realizada,
        categoria: _categoriaSelecionada!,
      );
      await provider.editarTarefa(editada);
    } else {
      final nova = Tarefa(
        titulo: _tituloCtrl.text.trim(),
        descricao: _descricaoCtrl.text.trim(),
        dataPrevista: dataStr,
        importante: _importante,
        categoria: _categoriaSelecionada!,
      );
      await provider.adicionarTarefa(nova);
    }

    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categorias = context.watch<TarefaProvider>().nomesCategorias;

    // Se a categoria salva não existe mais, limpa a seleção
    if (_categoriaSelecionada != null &&
        categorias.isNotEmpty &&
        !categorias.contains(_categoriaSelecionada)) {
      _categoriaSelecionada = null;
    }

    final dataFormatada = _dataSelecionada != null
        ? DateFormat('dd/MM/yyyy').format(_dataSelecionada!)
        : 'Selecionar data';

    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicao ? 'Editar tarefa' : 'Nova tarefa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe a descrição'
                    : null,
              ),
              const SizedBox(height: 16),
              // Dropdown de categorias pré-definidas
              DropdownButtonFormField<String>(
                value: _categoriaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categoriaSelecionada = v),
                validator: (v) =>
                    v == null ? 'Selecione uma categoria' : null,
                hint: const Text('Selecione'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/categorias'),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Gerenciar categorias',
                      style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(height: 8),
              // Seletor de data
              OutlinedButton.icon(
                onPressed: _selecionarData,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(dataFormatada),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  alignment: Alignment.centerLeft,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Não é possível selecionar uma data anterior a hoje.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Importante'),
                value: _importante,
                onChanged: (v) => setState(() => _importante = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _salvar,
                  child:
                      Text(_modoEdicao ? 'Salvar alterações' : 'Adicionar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
