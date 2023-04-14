import 'package:diagram_editor_apps/simple_diagram_editor/policy/custom_policy.dart';
import 'package:flutter/material.dart';

import '../../diagram_editor_plugin/diagram_editor.dart';

mixin MyLinkJointControlPolicy implements LinkJointPolicy, CustomStatePolicy {
  @override
  onLinkJointLongPress(int jointIndex, String linkId) {
    canvasWriter.model.removeLinkMiddlePoint(linkId, jointIndex);
    canvasWriter.model.updateLink(linkId);

    hideLinkOption();
  }

  @override
  onLinkJointScaleUpdate(
      int jointIndex, String linkId, ScaleUpdateDetails details) {
    canvasWriter.model.setLinkMiddlePointPosition(
        linkId, details.localFocalPoint, jointIndex);
    canvasWriter.model.updateLink(linkId);

    hideLinkOption();
  }
}
