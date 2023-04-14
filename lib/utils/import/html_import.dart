import 'dart:convert';
import 'dart:typed_data';

import 'package:diagram_editor_apps/utils/import/import_interface.dart';
import 'package:file_picker/file_picker.dart';

import '../../diagram_editor_plugin/src/canvas_context/diagram_editor_context.dart';
import '../../diagram_editor_plugin/src/canvas_context/model/component_data.dart';
import '../../diagram_editor_plugin/src/canvas_context/model/link_data.dart';
import '../../simple_diagram_editor/data/custom_component_data.dart';
import '../../simple_diagram_editor/data/custom_link_data.dart';

class HtmlImport implements PlatformImport {
  @override
  void platformImport(FilePickerResult result, DiagramEditorContext diagramEditorContext) async {
    late final jsonString;
    Uint8List? uint8List = result.files.single.bytes;
    if (uint8List != null) {
      jsonString = await String.fromCharCodes(uint8List);
    } else {
      print('ошибка чтения файла');
    }

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

PlatformImport getPlatformImport() => HtmlImport();
