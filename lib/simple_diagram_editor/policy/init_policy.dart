import 'package:diagram_editor_apps/diagram_editor_plugin/diagram_editor.dart';
import 'package:flutter/material.dart';

mixin MyInitPolicy implements InitPolicy {
  @override
  initializeDiagramEditor() {
    canvasWriter.state.setCanvasColor(Colors.white);
  }
}
