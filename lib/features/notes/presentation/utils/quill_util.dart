import 'package:fleather/fleather.dart';

String getPreviewText(Delta delta) {
  try {
    if (delta.isEmpty ||
        delta.last.data.toString().trim().endsWith('\n') == false) {
      delta = Delta.from(delta)..insert('\n');
    }
    final document = ParchmentDocument.fromDelta(delta);

    return document.toPlainText().trim();
  } catch (_) {
    return '';
  }
}
