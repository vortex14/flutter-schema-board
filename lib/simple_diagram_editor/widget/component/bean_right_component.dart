import 'package:diagram_editor_apps/diagram_editor_plugin/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/component/base_component_body.dart';
import 'package:flutter/material.dart';

class BeanRightBody extends StatelessWidget {
  final ComponentData componentData;

  const BeanRightBody({
    Key? key,
    required this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseComponentBody(
      componentData: componentData,
      componentPainter: BeanRightPainter(
        color: componentData.data.color,
        borderColor: componentData.data.borderColor,
        borderWidth: componentData.data.borderWidth,
      ),
    );
  }
}

class BeanRightPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size? componentSize;

  BeanRightPainter({
    this.color = Colors.grey,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    componentSize = size;

    Path path = componentPath();

    canvas.drawPath(path, paint);

    if (borderWidth > 0) {
      paint
        ..style = PaintingStyle.stroke
        ..color = borderColor
        ..strokeWidth = borderWidth;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    Path path = componentPath();
    return path.contains(position);
  }

  Path componentPath() {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(4 * componentSize!.width / 5, 0);
    path.quadraticBezierTo(
      componentSize!.width,
      componentSize!.height / 6,
      componentSize!.width,
      componentSize!.height / 2,
    );
    path.quadraticBezierTo(
      componentSize!.width,
      5 * componentSize!.height / 6,
      4 * componentSize!.width / 5,
      componentSize!.height,
    );
    path.lineTo(0, componentSize!.height);
    path.close();
    return path;
  }
}
