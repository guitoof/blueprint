import 'dart:io';

import 'package:blueprint/entities/project_component.dart';
import 'package:blueprint/services/project_blueprint_service.dart';
import 'package:blueprint/widgets/board.dart';
import 'package:blueprint/widgets/folder_picker.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProjectBlueprintService? projectBlueprintService;
  ProjectTree? projectTree;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blueprint')),
      backgroundColor: Colors.black12,
      body: projectTree != null ? Board(projectTree: projectTree!) : null,
      floatingActionButton: FolderPicker(
        onFolderSelected: (Directory directory) {
          setState(() {
            projectBlueprintService =
                ProjectBlueprintService(workDirectory: directory);
            projectTree = projectBlueprintService?.loadProjectTree(directory);
          });
        },
      ),
    );
  }
}
