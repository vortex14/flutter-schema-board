 
import 'package:flutter/material.dart';

import '../../../../diagram_editor.dart';

/// Attaches a link endpoint to border of a rectangle.
mixin LinkAttachmentRectPolicy implements LinkAttachmentPolicy {
  @override
  Alignment getLinkEndpointAlignment(
    ComponentData componentData,
    Offset targetPoint,
  ) {
    Offset pointPosition = targetPoint -
        (componentData.position + componentData.size.center(Offset.zero));
    pointPosition = Offset(
      pointPosition.dx / componentData.size.width,
      pointPosition.dy / componentData.size.height,
    );

    Offset pointAlignment;
    if (pointPosition.dx.abs() >= pointPosition.dy.abs()) {
      pointAlignment = Offset(pointPosition.dx / pointPosition.dx.abs(),
          pointPosition.dy / pointPosition.dx.abs());
    } else {
      pointAlignment = Offset(pointPosition.dx / pointPosition.dy.abs(),
          pointPosition.dy / pointPosition.dy.abs());
    }
    return Alignment(pointAlignment.dx, pointAlignment.dy);
  }
}
