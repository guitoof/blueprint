import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class ImportDirectiveRecursiveAstVisitor extends RecursiveAstVisitor {
  List<String> importedPaths = [];

  @override
  visitImportDirective(ImportDirective node) {
    if (node.uri.stringValue != null) {
      importedPaths.add(node.uri.stringValue!);
    }
  }
}

typedef ProjectTree = ProjectComponent;

class ProjectComponent {
  final String id;
  final Directory rootDirectory;
  final FileSystemEntity fileSystemEntity;
  late List<String> importingComponentIds;
  final List<ProjectComponent> children;

  ProjectComponent({
    required this.rootDirectory,
    required this.fileSystemEntity,
    required this.children,
  }) : id = fileSystemEntity.path.replaceFirst('${rootDirectory.path}/', '') {
    if (fileSystemEntity is File) {
      final visitor = ImportDirectiveRecursiveAstVisitor();
      final result = parseFile(
        path: fileSystemEntity.path,
        featureSet: FeatureSet.latestLanguageVersion(),
      );
      result.unit.visitChildren(visitor);
      importingComponentIds = visitor.importedPaths
          .map((path) => path.replaceFirst(RegExp(r'(package:\w+)\/'), ''))
          .toList();
    } else if (fileSystemEntity is Directory) {
      importingComponentIds = children.fold<List<String>>(
        [],
        (previousList, child) => <String>{
          ...previousList,
          ...child.importingComponentIds
              .map((childComponentId) {
                final splitPath = childComponentId.split('/');
                if (splitPath.length == 1) {
                  return splitPath.first;
                }
                splitPath.removeLast();
                return splitPath.join('/');
              })
              .toSet()
              .toList()
        }.toList(),
      );
    }
  }
}
