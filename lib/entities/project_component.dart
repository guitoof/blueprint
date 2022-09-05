import 'dart:io';

typedef ProjectTree = ProjectComponent;

class ProjectComponent {
  final String id;
  final List<ProjectComponent> children;

  final FileSystemEntity fileSystemEntity;

  ProjectComponent({
    required this.id,
    required this.fileSystemEntity,
    required this.children,
  });
}
