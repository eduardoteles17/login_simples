import 'package:flutter/material.dart';

class GenericScreen extends StatelessWidget {
  final String title;
  final Widget content;

  const GenericScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: content,
      ),
    );
  }
}
