import 'package:blueprint/entities/project_component.dart';

ProjectComponent getChildForPath(
    {required ProjectTree projectTree, required String path}) {
  var component = projectTree;
  for (var fileSystemEntityPath in path.split('/')) {
    component = component.children
        .singleWhere((child) => child.id.contains(fileSystemEntityPath));
  }
  if (component == null) {
    throw Exception(
      'Could not retrieve child in project Tree: $projectTree for path: $path',
    );
  }
  return component;
}
