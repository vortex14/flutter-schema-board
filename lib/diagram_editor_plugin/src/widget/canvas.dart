import 'package:diagram_editor_apps/diagram_editor_plugin/src/widget/link.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../main.dart';
import '../../diagram_editor.dart';
import '../canvas_context/canvas_model.dart';
import '../canvas_context/canvas_state.dart';
import 'component.dart';

class DiagramEditorCanvas extends StatefulWidget {
  final PolicySet policy;

  /// The canvas where all components and links are shown on.
  const DiagramEditorCanvas({
    Key? key,
    required this.policy,
  }) : super(key: key);

  @override
  _DiagramEditorCanvasState createState() => _DiagramEditorCanvasState();
}

class _DiagramEditorCanvasState extends State<DiagramEditorCanvas> with TickerProviderStateMixin {
  PolicySet? withControlPolicy;

  @override
  void initState() {
    withControlPolicy = (widget.policy is CanvasControlPolicy || widget.policy is CanvasMovePolicy) ? widget.policy : null;

    (withControlPolicy as CanvasControlPolicy?)?.setAnimationController(
      AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    (withControlPolicy as CanvasControlPolicy?)?.disposeAnimationController();
    super.dispose();
  }

  List<Widget> showComponents(CanvasModel canvasModel) {
    var zOrderedComponents = canvasModel.components.values.toList();
    zOrderedComponents.sort((a, b) => a.zOrder.compareTo(b.zOrder));

    return zOrderedComponents
        .map(
          (componentData) => ChangeNotifierProvider<ComponentData>.value(
            value: componentData,
            child: Component(
              policy: widget.policy,
            ),
          ),
        )
        .toList();
  }

  List<Widget> showLinks(CanvasModel canvasModel) {
    return canvasModel.links.values.map((LinkData linkData) {
      return ChangeNotifierProvider<LinkData>.value(
        value: linkData,
        child: Link(
          policy: widget.policy,
        ),
      );
    }).toList();
  }

  List<Widget> showOtherWithComponentDataUnder(CanvasModel canvasModel) {
    return canvasModel.components.values.map((ComponentData componentData) {
      return ChangeNotifierProvider<ComponentData>.value(
        value: componentData,
        builder: (context, child) {
          return Consumer<ComponentData>(
            builder: (context, data, child) {
              return widget.policy.showCustomWidgetWithComponentDataUnder(context, data);
            },
          );
        },
      );
    }).toList();
  }

  List<Widget> showOtherWithComponentDataOver(CanvasModel canvasModel) {
    return canvasModel.components.values.map((ComponentData componentData) {
      return ChangeNotifierProvider<ComponentData>.value(
        value: componentData,
        builder: (context, child) {
          return Consumer<ComponentData>(
            builder: (context, data, child) {
              return widget.policy.showCustomWidgetWithComponentDataOver(context, data);
            },
          );
        },
      );
    }).toList();
  }

  List<Widget> showBackgroundWidgets() {
    return widget.policy.showCustomWidgetsOnCanvasBackground(context);
  }

  List<Widget> showForegroundWidgets() {
    return widget.policy.showCustomWidgetsOnCanvasForeground(context);
  }

  Widget canvasStack(CanvasModel canvasModel, CanvasState canvasState) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          ...showBackgroundWidgets(),
          Screenshot(
            controller: canvasState.screenshotController,
            child: Stack(clipBehavior: Clip.none, fit: StackFit.expand, children: [
              ...showOtherWithComponentDataUnder(canvasModel),
              ...showComponents(canvasModel),
              ...showLinks(canvasModel),
              ...showOtherWithComponentDataOver(canvasModel),
              ...showForegroundWidgets(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget canvasAnimated(CanvasModel canvasModel, CanvasState canvasState) {
    return AnimatedBuilder(
      animation: (withControlPolicy as CanvasControlPolicy).getAnimationController(),
      builder: (BuildContext context, Widget? child) {
        (withControlPolicy as CanvasControlPolicy).canUpdateCanvasModel = true;
        return Transform(
          transform: Matrix4.identity()
            ..translate((withControlPolicy as CanvasControlPolicy).transformPosition.dx, (withControlPolicy as CanvasControlPolicy).transformPosition.dy)
            ..scale((withControlPolicy as CanvasControlPolicy).transformScale),
          child: child,
        );
      },
      child: canvasStack(canvasModel, canvasState),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canvasModel = Provider.of<CanvasModel>(context);
    final canvasState = Provider.of<CanvasState>(context);

    return AbsorbPointer(
      absorbing: canvasState.shouldAbsorbPointer,
      child: Listener(
        onPointerSignal: (PointerSignalEvent event) => widget.policy.onCanvasPointerSignal(event),
        child: GestureDetector(
          child: Container(
            color: canvasState.color,
            child: ClipRect(
              child: (withControlPolicy != null) ? canvasAnimated(canvasModel, canvasState) : canvasStack(canvasModel, canvasState),
            ),
          ),
          onScaleStart: (details) => widget.policy.onCanvasScaleStart(details),
          onScaleUpdate: (details) => widget.policy.onCanvasScaleUpdate(details),
          onScaleEnd: (details) => widget.policy.onCanvasScaleEnd(details),
          onTap: () => widget.policy.onCanvasTap(),
          onTapDown: (TapDownDetails details) => widget.policy.onCanvasTapDown(details),
          onTapUp: (TapUpDetails details) => widget.policy.onCanvasTapUp(details),
          onTapCancel: () => widget.policy.onCanvasTapCancel(),
          onLongPress: () => widget.policy.onCanvasLongPress(),
          onLongPressStart: (LongPressStartDetails details) => widget.policy.onCanvasLongPressStart(details),
          onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) => widget.policy.onCanvasLongPressMoveUpdate(details),
          onLongPressEnd: (LongPressEndDetails details) => widget.policy.onCanvasLongPressEnd(details),
          onLongPressUp: () => widget.policy.onCanvasLongPressUp(),
        ),
      ),
    );
  }
}
