import 'package:screenshot/screenshot.dart';

import 'export_stub.dart'
    if (dart.library.io) 'package:diagram_editor_apps/utils/export/io_export.dart'
    if (dart.library.html) 'package:diagram_editor_apps/utils/export/html_export.dart';

abstract class PlatformExport {
  void platformExport (String jsonString) async {}
  void platformImageExport (ScreenshotController  screenshotController) async {}

  factory PlatformExport() => getPlatformExport();
}