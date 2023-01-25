import 'dart:io';

import 'package:blueprint/entities/project_component.dart';

const _kFileExtensionsWhiteList = ['.dart'];

typedef FileSystemEntityFilter = bool Function(FileSystemEntity);

class ProjectBlueprintService {
  final Directory workDirectory;

  ProjectBlueprintService({required this.workDirectory});

  String _getFileEntityName(FileSystemEntity fileSystemEntity) =>
      fileSystemEntity.path.split('/').last;

  bool _isNotHidden(FileSystemEntity entity) =>
      !_getFileEntityName(entity).startsWith('.');

  bool _isFileWhiteListed(FileSystemEntity entity) =>
      entity is! File ||
      _kFileExtensionsWhiteList
          .any((extension) => _getFileEntityName(entity).contains(extension));

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
        children.add(loadFromDirectory(fileSystemEntity, filters: filters));
      } else if (fileSystemEntity is File) {
        children.add(ProjectComponent(
          rootDirectory: workDirectory,
          fileSystemEntity: fileSystemEntity,
          children: [],
        ));
      }
    }
    return ProjectComponent(
      rootDirectory: workDirectory,
      fileSystemEntity: currentDirectory,
      children: children,
    );
  }

  ProjectTree loadProjectTree(Directory directory) => loadFromDirectory(
        directory,
        filters: [_isNotHidden, _isFileWhiteListed],
      );
}
