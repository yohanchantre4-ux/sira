import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(36),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.inbox_outlined, size: 38, color: Colors.black38),
        const SizedBox(height: 10),
        Text(message, textAlign: TextAlign.center),
      ]),
    ),
  );
}
