// lib/utils/web_file_picker.dart
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

class WebFilePicker {
  static Future<FilePickerResult?> pickImage() async {
    final completer = Completer<FilePickerResult?>();
    
    final uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*'
      ..click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        
        reader.onLoadEnd.listen((event) {
          final result = reader.result as String;
          final bytes = base64Decode(result.split(',').last);
          
          completer.complete(FilePickerResult(
            fileName: file.name,
            bytes: bytes,
            base64: result.split(',').last,
          ));
        });
        
        reader.readAsDataUrl(file);
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}

class FilePickerResult {
  final String fileName;
  final Uint8List bytes;
  final String base64;

  FilePickerResult({
    required this.fileName,
    required this.bytes,
    required this.base64,
  });
}