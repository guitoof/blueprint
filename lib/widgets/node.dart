import 'package:blueprint/entities/project_component.dart';
import 'package:flutter/material.dart';

class Node extends StatelessWidget {
  const Node({super.key, required this.projectComponent});

  final ProjectComponent projectComponent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox.square(
        dimension: 200,
        child: ColoredBox(
          color: Colors.blue,
          child: Center(
            child: Column(
              children: [
                Text(
                  projectComponent.id.split('/').last,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'ID: ${projectComponent.id}',
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox.fromSize(
                  size: const Size(double.infinity, 150),
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        Text(projectComponent.importingComponentIds[index]),
                    itemCount: projectComponent.importingComponentIds.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
