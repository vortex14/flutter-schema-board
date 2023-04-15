import 'dart:convert';
import 'dart:html';

import 'package:diagram_editor_apps/utils/export/export_interface.dart';

class HtmlExport implements PlatformExport {
  @override
  void platformExport(String jsonString) async {
    final stream = Stream.fromIterable(jsonString.codeUnits);
    String filename = 'Schema.json';
    filename = filename.replaceAll('/', '_').replaceAll('\\', '_');
    final bytes = await stream.toList();
    // Encode our file in base64
    final b64 = base64Encode(bytes);
    // Create the link with the file
    final anchor = AnchorElement(href: 'data:application/octet-stream;base64,$b64')..target = 'blank';
    // add the name
    anchor.download = filename;

    // trigger download
    document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }
}

PlatformExport getPlatformExport() => HtmlExport();
