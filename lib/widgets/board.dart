import 'package:blueprint/entities/project_component.dart';
import 'package:blueprint/widgets/node.dart';
import 'package:flutter/widgets.dart';

class Board extends StatelessWidget {
  const Board({super.key, required this.projectTree});

  final ProjectTree projectTree;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: projectTree.children
            .map((component) => Node(
                  projectComponent: component,
                  initialPosition: Offset(
                    projectTree.children.indexOf(component) * 205.0,
                    projectTree.children.indexOf(component) * 20.0,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
