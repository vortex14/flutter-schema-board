import 'import_stub.dart'
    if (dart.library.io) 'package:diagram_editor_apps/utils/import/io_import.dart'
    if (dart.library.html) 'package:diagram_editor_apps/utils/import/html_import.dart';

import 'package:file_picker/file_picker.dart';

import '../../diagram_editor_plugin/src/canvas_context/diagram_editor_context.dart';

abstract class PlatformImport {
  void platformImport (FilePickerResult result, DiagramEditorContext diagramEditorContext) {}

  factory PlatformImport() => getPlatformImport();
}