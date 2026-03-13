import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class MachineFrameCache {
  static const int _frameCount = 120;
  static Future<List<ui.Image>>? _pending;
  static List<ui.Image>? _frames;

  static Future<List<ui.Image>> load() {
    final frames = _frames;
    if (frames != null) {
      return Future.value(frames);
    }
    final pending = _pending;
    if (pending != null) {
      return pending;
    }
    final future = _loadFrames();
    _pending = future;
    return future;
  }

  static Future<List<ui.Image>> _loadFrames() async {
    try {
      final decodedFrames = <ui.Image>[];
      for (var i = 0; i < _frameCount; i++) {
        final index = (i + 1).toString().padLeft(3, '0');
        final data = await rootBundle.load('assets/image/machine$index.webp');
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        decodedFrames.add(frame.image);
      }
      _frames = decodedFrames;
      return decodedFrames;
    } finally {
      _pending = null;
    }
  }
}
