import 'package:flutter/material.dart';

class BotaoEstilizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color? cor;
  final IconData? icone;

  const BotaoEstilizado({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cor,
    this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icone ?? Icons.check, size: 18),
      label: Text(texto),
      style: TextButton.styleFrom(
        foregroundColor: cor ?? Theme.of(context).colorScheme.primary,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
