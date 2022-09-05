import 'package:blueprint/entities/project_component.dart';
import 'package:flutter/material.dart';

class Node extends StatelessWidget {
  const Node({super.key, required this.projectComponent});

  final ProjectComponent projectComponent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SizedBox.square(
        dimension: 100,
        child: ColoredBox(
          color: Colors.blue,
          child: Center(
            child: Text(
              projectComponent.id.split('/').last,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
