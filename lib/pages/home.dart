import 'dart:io';

import 'package:blueprint/entities/project_component.dart';
import 'package:blueprint/services/project_blueprint_service.dart';
import 'package:blueprint/widgets/folder_picker.dart';
import 'package:blueprint/widgets/node.dart';
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
      appBar: AppBar(title: const Text('Home')),
      backgroundColor: Colors.black12,
      body: SizedBox(
        height: 200,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: projectTree == null
              ? []
              : projectTree!.children
                  .map((component) => SliverToBoxAdapter(
                        child: Node(
                          projectComponent: component,
                        ),
                      ))
                  .toList(),
        ),
      ),
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
