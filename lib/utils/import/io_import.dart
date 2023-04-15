import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:diagram_editor_apps/utils/import/import_interface.dart';
import 'package:file_picker/file_picker.dart';

import '../../diagram_editor_plugin/diagram_editor.dart';
import '../../simple_diagram_editor/data/custom_component_data.dart';
import '../../simple_diagram_editor/data/custom_link_data.dart';

class IoImport implements PlatformImport {
  @override
  Future<void> platformImport(FilePickerResult result, DiagramEditorContext diagramEditorContext) async {
    File file = File(result.files.single.path!);
    final jsonString = await file.readAsString();
    final jsonMap = jsonDecode(jsonString);

    final List<ComponentData> components = (jsonMap["components"] as List).map((component) {
      return ComponentData.fromJson(component, decodeCustomComponentData: MyCustomComponentData.fromJson);
    }).toList();
    final List<LinkData> links = (jsonMap["links"] as List).map((link) {
      return LinkData.fromJson(link, decodeCustomLinkData: MyLinkData.fromJson);
    }).toList();

    for (var component in components) {
      diagramEditorContext.canvasModel.addComponent(diagramEditorContext.canvasModel.components[component.id] = component);
    }
    for (var link in links) {
      diagramEditorContext.canvasModel.addLink(diagramEditorContext.canvasModel.links[link.id] = link);
    }
  }
}

PlatformImport getPlatformImport() => IoImport();
