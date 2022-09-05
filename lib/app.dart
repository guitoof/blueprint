import 'dart:io';

import 'package:blueprint/entities/project_component.dart';
import 'package:blueprint/widgets/folder_picker.dart';
import 'package:flutter/material.dart';

const fileExtensionsWhiteList = ['.dart'];

typedef FileSystemEntityFilter = bool Function(FileSystemEntity);

String getFileEntityName(FileSystemEntity fileSystemEntity) =>
    fileSystemEntity.path.split('/').last;

bool isNotHidden(FileSystemEntity entity) =>
    !getFileEntityName(entity).startsWith('.');

bool isFileWhilteListed(FileSystemEntity entity) =>
    entity is! File ||
    fileExtensionsWhiteList.contains(getFileEntityName(entity));

ProjectTree loadFromDirectory(
  Directory directory, {
  List<FileSystemEntityFilter>? filters,
}) {
  final List<ProjectComponent> children = [];
  final Directory currentDirectory = directory;
  final List<FileSystemEntity> directoryListing =
      currentDirectory.listSync(followLinks: false);
  for (final filter in filters ?? []) {
    directoryListing.retainWhere(filter);
  }
  for (final FileSystemEntity fileSystemEntity in directoryListing) {
    if (fileSystemEntity is Directory) {
      children.add(loadFromDirectory(fileSystemEntity));
    } else if (fileSystemEntity is File) {
      children.add(ProjectComponent(
        id: fileSystemEntity.path,
        fileSystemEntity: fileSystemEntity,
        children: [],
      ));
    }
  }
  return ProjectComponent(
    id: currentDirectory.path,
    fileSystemEntity: currentDirectory,
    children: children,
  );
}

class BlueprintApp extends StatefulWidget {
  const BlueprintApp({Key? key}) : super(key: key);

  @override
  State<BlueprintApp> createState() => _BlueprintAppState();
}

class _BlueprintAppState extends State<BlueprintApp> {
  @override
  Widget build(BuildContext context) {
    late ProjectTree projectTree;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Blueprint')),
        body: Center(
          child: FolderPicker(
            onFolderSelected: (Directory directory) {
              projectTree = loadFromDirectory(directory,
                  filters: [isNotHidden, isFileWhilteListed]);
              print(projectTree.children.length);
            },
          ),
        ),
      ),
    );
  }
}
