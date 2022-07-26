import 'package:blueprint/widgets/folder_picker.dart';
import 'package:flutter/material.dart';

class BlueprintApp extends StatefulWidget {
  const BlueprintApp({Key? key}) : super(key: key);

  @override
  State<BlueprintApp> createState() => _BlueprintAppState();
}

class _BlueprintAppState extends State<BlueprintApp> {
  List<String> _paths = <String>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Blueprint')),
        body: const Center(
          child: FolderPicker(),
        ),
      ),
    );
  }
}
