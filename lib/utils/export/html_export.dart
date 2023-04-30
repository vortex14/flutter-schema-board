import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:diagram_editor_apps/utils/export/export_interface.dart';
import 'package:diagram_editor_apps/utils/extensions/global_key_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';

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
    final anchor = html.AnchorElement(href: 'data:application/octet-stream;base64,$b64')..target = 'blank';
    // add the name
    anchor.download = filename;

    // trigger download
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }

  @override
  void platformImageExport(ScreenshotController screenshotController) async {
    String filename = 'Schema.png';
    try {
      Uint8List? capturedImage = await screenshotController.capture(delay: const Duration(milliseconds: 10));
      if (capturedImage != null) {
        final b64 = base64Encode(capturedImage.toList());
        // Create the link with the file
        final anchor = html.AnchorElement(href: 'data:application/octet-stream;base64,$b64')..target = 'blank';
        // add the name
        anchor.download = filename;

        // trigger download
        html.document.body?.append(anchor);
        anchor.click();
        anchor.remove();
      }
    } catch (e) {
      print(e);
    }
    print('done');
  }
}

PlatformExport getPlatformExport() => HtmlExport();
