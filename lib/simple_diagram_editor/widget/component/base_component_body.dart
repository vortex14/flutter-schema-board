import 'package:diagram_editor_apps/diagram_editor_plugin/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_component_data.dart';
import 'package:flutter/material.dart';

class BaseComponentBody extends StatelessWidget {
  final ComponentData? componentData;
  final CustomPainter? componentPainter;

  const BaseComponentBody({
     Key? key,
    required this.componentData,
    this.componentPainter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyCustomComponentData customData = componentData?.data;

    return GestureDetector(
      child: CustomPaint(
        painter: componentPainter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Align(
            alignment: customData.textAlignment,
            child: Text(
              customData.text,
              style: TextStyle(fontSize: customData.textSize),
            ),
          ),
        ),
      ),
    );
  }
}
