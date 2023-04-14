
import 'model_reader.dart';
import 'state_reader.dart';

/// Takes care of reading from model and state of the canvas.
class CanvasReader {
  /// Access to canvas model (components, links..).
  final CanvasModelReader model;

  /// Access to canvas state data (canvas scale, position..).
  final CanvasStateReader state;

  CanvasReader(this.model, this.state);
}
