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
      /// Testing loading fixture project: project_A
      /// file_A1_1.dart <-- file_A2_1.dart
      group('for Project A', () {
        final directory =
            Directory('${Directory.current.path}/test/fixtures/project_A');

        setUpAll(() {
          service = ProjectBlueprintService(workDirectory: directory);
        });

        test('should return a project tree with 2 root children', () {
          final projectTree = service?.loadProjectTree(directory);
          expect(projectTree?.children.length, 2);
        });

        test(
            "should return a project tree that verifies: if file_A import file_B, then file_B's id is contained in file_A's importingComponentIds",
            () {
          final projectTree = service?.loadProjectTree(directory);
          expect(
            getChildForPath(
                    projectTree: projectTree!,
                    path: 'subfolder_A1/file_A1_1.dart')
                .importingComponentIds,
            contains(getChildForPath(
                    projectTree: projectTree,
                    path: 'subfolder_A2/file_A2_1.dart')
                .id),
          );
        });
        test(
            "should return a project tree that verifies: if file_A does not importa any file, then its importingComponentIds is be empty",
            () {
          final projectTree = service?.loadProjectTree(directory);
          expect(
              getChildForPath(
                      projectTree: projectTree!,
                      path: 'subfolder_A2/file_A2_1.dart')
                  .importingComponentIds,
              isEmpty);
        });

        test(
            "should return a project tree that verifies: if folder_A contains a file importing another file from folder_B, then folder_B's id is contained in folder_A's importingComponentIds",
            () {
          final projectTree = service?.loadProjectTree(directory);
          expect(
            getChildForPath(projectTree: projectTree!, path: 'subfolder_A1')
                .importingComponentIds,
            contains(
                getChildForPath(projectTree: projectTree, path: 'subfolder_A2')
                    .id),
          );
        });
      });
    });
  });
}
