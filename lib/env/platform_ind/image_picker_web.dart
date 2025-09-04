import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

Future<Uint8List?> pickImage() async {
  html.FileUploadInputElement element = html.FileUploadInputElement();
  element.multiple = false;
  element.accept = 'image/*';
  element.click();

  final completer = Completer<Uint8List?>();

  element.onChange.listen((event) {
    final files = element.files;
    if (files == null || files.isEmpty) {
      completer.complete(null);
      return;
    }

    final file = files[0];
    final reader = html.FileReader();

    reader.onLoadEnd.listen((event) {
      final result = reader.result as String;

      final base64String = result.split(',').last;
      final bytes = Base64Decoder().convert(base64String);

      completer.complete(Uint8List.fromList(bytes));
    });

    reader.readAsDataUrl(file);
  });

  return completer.future;
}
