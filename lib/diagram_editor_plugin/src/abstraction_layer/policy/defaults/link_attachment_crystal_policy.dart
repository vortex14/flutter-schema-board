 
import 'package:flutter/material.dart';

import '../../../../diagram_editor.dart';

/// Attaches a link endpoint to border of an crystal shape.
mixin LinkAttachmentCrystalPolicy implements LinkAttachmentPolicy {
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

    Offset pointAlignment =
        pointPosition / (pointPosition.dx.abs() + pointPosition.dy.abs());

    return Alignment(pointAlignment.dx, pointAlignment.dy);
  }
}
