import 'package:blueprint/entities/project_component.dart';
import 'package:flutter/material.dart';

class Node extends StatefulWidget {
  const Node(
      {super.key,
      required this.projectComponent,
      required this.initialPosition});

  final ProjectComponent projectComponent;
  final Offset initialPosition;

  @override
  State<Node> createState() => _NodeState();
}

class _NodeState extends State<Node> {
  _NodeState();

  late Offset position = Offset.zero;

  @override
  void initState() {
    position = widget.initialPosition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox.square(
            dimension: 200,
            child: ColoredBox(
              color: Colors.blue,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      widget.projectComponent.id.split('/').last,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'ID: ${widget.projectComponent.id}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    SizedBox.fromSize(
                      size: const Size(double.infinity, 150),
                      child: ListView.builder(
                        itemBuilder: (context, index) => Text(widget
                            .projectComponent.importingComponentIds[index]),
                        itemCount: widget
                            .projectComponent.importingComponentIds.length,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
