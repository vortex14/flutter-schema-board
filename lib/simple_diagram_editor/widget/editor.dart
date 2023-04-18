import 'dart:convert';

import 'package:diagram_editor_apps/diagram_editor_plugin/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/minimap_policy.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/policy/my_policy_set.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/menu.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/widget/option_icon.dart';
import 'package:diagram_editor_apps/utils/import/import_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../utils/export/export_interface.dart';

class SimpleDemoEditor extends StatefulWidget {
  @override
  _SimpleDemoEditorState createState() => _SimpleDemoEditorState();
}

class _SimpleDemoEditorState extends State<SimpleDemoEditor> {
  DiagramEditorContext? diagramEditorContext;
  DiagramEditorContext? diagramEditorContextMiniMap;

  MyPolicySet myPolicySet = MyPolicySet();
  MiniMapPolicySet miniMapPolicySet = MiniMapPolicySet();

  bool isMiniMapVisible = true;
  bool isMenuVisible = true;
  bool isOptionsVisible = true;

  @override
  void initState() {
    diagramEditorContext = DiagramEditorContext(
      policySet: myPolicySet,
    );
    diagramEditorContextMiniMap = DiagramEditorContext.withSharedModel(diagramEditorContext!, policySet: miniMapPolicySet);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: !kIsWeb,
      showPerformanceOverlay: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(color: Colors.grey),
              Positioned(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: DiagramEditor(
                    diagramEditorContext: diagramEditorContext!,
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: isMiniMapVisible,
                      child: Container(
                        width: 320,
                        height: 240,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black,
                            width: 2,
                          )),
                          child: DiagramEditor(
                            diagramEditorContext: diagramEditorContextMiniMap!,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMiniMapVisible = !isMiniMapVisible;
                        });
                      },
                      child: Container(
                        color: Colors.grey[300]!,
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(isMiniMapVisible ? 'Скрыть миникарту' : 'Показать мини-карту'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OptionIcon(
                        color: Colors.grey.withOpacity(0.7),
                        iconData: isOptionsVisible ? Icons.menu_open : Icons.menu,
                        shape: BoxShape.rectangle,
                        onPressed: () {
                          setState(() {
                            isOptionsVisible = !isOptionsVisible;
                          });
                        },
                        tooltip: '',
                      ),
                      SizedBox(width: 8),
                      Visibility(
                        visible: isOptionsVisible,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            OptionIcon(
                              tooltip: 'Сбросить вид',
                              color: Colors.grey.withOpacity(0.7),
                              iconData: Icons.replay,
                              onPressed: () => myPolicySet.resetView(),
                            ),
                            SizedBox(width: 8),
                            OptionIcon(
                              tooltip: 'Удалить всё',
                              color: Colors.grey.withOpacity(0.7),
                              iconData: Icons.delete_forever,
                              onPressed: () => myPolicySet.removeAll(),
                            ),
                            SizedBox(width: 8),
                            OptionIcon(
                              tooltip: myPolicySet.isGridVisible ? 'Скрыть сетку' : 'Показать сетку',
                              color: Colors.grey.withOpacity(0.7),
                              iconData: myPolicySet.isGridVisible ? Icons.grid_off : Icons.grid_on,
                              onPressed: () {
                                setState(() {
                                  myPolicySet.isGridVisible = !myPolicySet.isGridVisible;
                                });
                              },
                            ),
                            SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: myPolicySet.isMultipleSelectionOn,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OptionIcon(
                                        tooltip: 'Выбрать всё',
                                        color: Colors.grey.withOpacity(0.7),
                                        iconData: Icons.all_inclusive,
                                        onPressed: () => myPolicySet.selectAll(),
                                      ),
                                      SizedBox(height: 8),
                                      OptionIcon(
                                        tooltip: 'Дублировать выделенное',
                                        color: Colors.grey.withOpacity(0.7),
                                        iconData: Icons.copy,
                                        onPressed: () => myPolicySet.duplicateSelected(),
                                      ),
                                      SizedBox(height: 8),
                                      OptionIcon(
                                        tooltip: 'Удалить выбранное',
                                        color: Colors.grey.withOpacity(0.7),
                                        iconData: Icons.delete,
                                        onPressed: () => myPolicySet.removeSelected(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                OptionIcon(
                                  tooltip: myPolicySet.isMultipleSelectionOn ? 'Отключить множественный выбор' : 'Включить множественный выбор',
                                  color: Colors.grey.withOpacity(0.7),
                                  iconData: myPolicySet.isMultipleSelectionOn ? Icons.group_work : Icons.group_work_outlined,
                                  onPressed: () {
                                    setState(() {
                                      if (myPolicySet.isMultipleSelectionOn) {
                                        myPolicySet.turnOffMultipleSelection();
                                      } else {
                                        myPolicySet.turnOnMultipleSelection();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(width: 8),
                            OptionIcon(
                              tooltip: 'Импортировать схему',
                              color: Colors.grey.withOpacity(0.7),
                              iconData: Icons.input_rounded,
                              onPressed: () async => _importFile(),
                            ),
                            SizedBox(width: 8),
                            OptionIcon(
                              tooltip: 'Экспортировать схему',
                              color: Colors.grey.withOpacity(0.7),
                              iconData: Icons.output_rounded,
                              onPressed: () async => _exportFile(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Visibility(
                      visible: isMenuVisible,
                      child: Container(
                        color: Colors.grey.withOpacity(0.7),
                        width: 120,
                        height: 320,
                        child: DraggableMenu(myPolicySet: myPolicySet),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 1,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isMenuVisible = !isMenuVisible;
                          });
                        },
                        child: Container(
                          color: Colors.grey[300]!,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(isMenuVisible ? 'Скрыть меню' : 'Показать меню'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   top: 8,
              //   left: 8,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all(Colors.blue),
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(Icons.arrow_back, size: 16),
              //         SizedBox(width: 8),
              //         Text('BACK TO MENU'),
              //       ],
              //     ),
              //     onPressed: () => Navigator.pop(context),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformImport().platformImport(result, diagramEditorContext!);
    } else {
      // User canceled the picker
    }
  }

  void _exportFile() async {
    final jsonMap = diagramEditorContext!.canvasModel.getDiagram().toJson();
    final String jsonString = jsonEncode(jsonMap);
    PlatformExport().platformExport(jsonString);
  }
}
