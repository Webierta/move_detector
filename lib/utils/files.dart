import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';

/* Future<String> getFile() async {
  Directory directory = await getApplicationDocumentsDirectory();
  var dbPath = join(directory.path, 'beep.mp3');
  if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
    ByteData data = await rootBundle.load('assets/audio/beep.mp3');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    File archivo = await File(dbPath).writeAsBytes(bytes);
    return archivo.path;
  }
  return dbPath;
} */

Future<String> getAsset({String file = 'beep.mp3'}) async {
  Directory directory = await getApplicationDocumentsDirectory();
  var dbPath = join(directory.path, file);
  if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
    ByteData data = await rootBundle.load('assets/audio/$file');
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    File archivo = await File(dbPath).writeAsBytes(bytes);
    return archivo.path;
  }
  return dbPath;
}
