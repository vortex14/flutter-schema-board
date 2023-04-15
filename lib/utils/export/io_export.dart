import 'dart:io';
import 'dart:typed_data';

import 'package:diagram_editor_apps/utils/export/export_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class IoExport implements PlatformExport {
  @override
  Future<void> platformExport(String jsonString) async {
    Uint8List uint8List = Uint8List.fromList(jsonString.codeUnits);

    // Andriod, Ios
    if (Platform.isAndroid || Platform.isIOS) {
      ShareFilesAndScreenshotWidgets().shareFile("Сохранить", "schema.json", uint8List, "application/json", text: "");

      // Windows, MacOS
    } else if (Platform.isMacOS || Platform.isWindows) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'Schema.json',
      );
      if (outputFile == null) {
      } else {
        final jsonFile = File(outputFile);
        jsonFile.writeAsBytes(uint8List);
      }
    }
  }
}

PlatformExport getPlatformExport() => IoExport();
