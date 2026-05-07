import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:app_tarefas/providers/tarefa_provider.dart';
import 'package:app_tarefas/telas/tela_bem_vindo.dart';
import 'package:app_tarefas/telas/tela_listagem.dart';
import 'package:app_tarefas/telas/tela_detalhes.dart';
import 'package:app_tarefas/telas/tela_form_tarefa.dart';
import 'package:app_tarefas/telas/tela_categorias.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TarefaProvider(),
      child: const AppTarefas(),
    ),
  );
}

class AppTarefas extends StatelessWidget {
  const AppTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      debugShowCheckedModeBanner: false,
      // Visual minimalista: tema claro com cores neutras
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          dividerColor: Colors.transparent,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFEEEEEE),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
      ),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaBemVindo(),
        '/lista': (context) => const TelaListagem(),
        '/detalhes': (context) => const TelaDetalhes(),
        '/inserir': (context) => const TelaFormTarefa(),
        '/editar': (context) => const TelaFormTarefa(),
        '/categorias': (context) => const TelaCategorias(),
      },
    );
  }
}
