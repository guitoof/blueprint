import 'dart:io';

import 'package:blueprint/services/project_blueprint_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/project_tree_helper.dart';

void main() {
  group('[ProjectBlueprintService]', () {
    ProjectBlueprintService? service;

    tearDownAll(() {
      service = null;
    });

    group('loadProjectTree', () {
      /// Testing loading fixture project: project_a
      /// file_a1_1.dart <-- file_a2_1.dart
      group('for Project a', () {
        final directory =
            Directory('${Directory.current.path}/test/fixtures/project_a');

        setUpAll(() {
          service = ProjectBlueprintService(workDirectory: directory);
        });

        test('should return a project tree with 2 root children', () {
          final projectTree = service?.loadProjectTree(directory);
          expect(projectTree?.children.length, 2);
        });

        test(
            "should return a project tree that verifies: if file_a import file_b, then file_b's id is contained in file_a's importingComponentIds",
            () {
          final projectTree = service?.loadProjectTree(directory);
          expect(
            getChildForPath(
                    projectTree: projectTree!,
                    path: 'subfolder_a1/file_a1_1.dart')
                .importingComponentIds,
            contains(getChildForPath(
                    projectTree: projectTree,
                    path: 'subfolder_a2/file_a2_1.dart')
                .id),
          );
        });
        test(
            "should return a project tree that verifies: if file_a does not import any file, then its importingComponentIds is be empty",
            () {
          final projectTree = service?.loadProjectTree(directory);
          expect(
              getChildForPath(
                      projectTree: projectTree!,
                      path: 'subfolder_a2/file_a2_1.dart')
                  .importingComponentIds,
              isEmpty);
        });

        test(
            "should return a project tree that verifies: if folder_a contains a file importing another file from folder_b, then folder_b's id is contained in folder_a's importingComponentIds",
            () {
          final projectTree = service?.loadProjectTree(directory);
          expect(
            getChildForPath(projectTree: projectTree!, path: 'subfolder_a1')
                .importingComponentIds,
            contains(
                getChildForPath(projectTree: projectTree, path: 'subfolder_a2')
                    .id),
          );
        });
      });
    });
  });
}
