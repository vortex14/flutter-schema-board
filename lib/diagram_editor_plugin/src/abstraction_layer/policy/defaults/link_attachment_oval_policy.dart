 
import 'package:flutter/material.dart';

import '../../../../diagram_editor.dart';

/// Attaches a link endpoint to border of an oval.
mixin LinkAttachmentOvalPolicy implements LinkAttachmentPolicy {
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

    Offset pointAlignment = pointPosition / pointPosition.distance;

    return Alignment(pointAlignment.dx, pointAlignment.dy);
  }
}
