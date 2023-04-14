import 'package:diagram_editor_apps/diagram_editor_plugin/diagram_editor.dart';
import 'package:diagram_editor_apps/grid_example/widget/basic_component.dart';
import 'package:flutter/material.dart';

mixin MyComponentDesignPolicy implements ComponentDesignPolicy {
  @override
  Widget showComponentBody(ComponentData componentData) {
    return BasicComponent();
  }
}
