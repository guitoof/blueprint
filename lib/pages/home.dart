import 'dart:io';

import 'package:blueprint/entities/project_component.dart';
import 'package:blueprint/widgets/folder_picker.dart';
import 'package:blueprint/widgets/node.dart';
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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProjectTree? projectTree;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      backgroundColor: Colors.black12,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: projectTree == null
              ? []
              : projectTree!.children
                  .map((component) => Node(
                        projectComponent: component,
                      ))
                  .toList(),
        ),
      ),
      floatingActionButton: FolderPicker(
        onFolderSelected: (Directory directory) {
          setState(() {
            projectTree = loadFromDirectory(
              directory,
              filters: [isNotHidden, isFileWhilteListed],
            );
          });
        },
      ),
    );
  }
}
