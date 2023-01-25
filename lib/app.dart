import 'package:blueprint/pages/home.dart';
import 'package:flutter/material.dart';

class BlueprintApp extends StatelessWidget {
  const BlueprintApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
