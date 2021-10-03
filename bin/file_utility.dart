import 'dart:io';

/// temporarily save file to use later
Future<File> saveFileOffline(String filename, var data) async {
  final _file = File(filename);

  final savedFile = await _file.writeAsBytes(data);

  return savedFile;
}

/// clean up
Future<void> deleteSavedFileOffline(List<File> files) async {
  for (var file in files) {
     await file.delete();
  }
 
}
