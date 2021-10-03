import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';

import 'console_log.dart';
import 'constants.dart';
import 'file_utility.dart';

/// loads all files found from cloud storage
///
/// returns a list of file objects saved to disk
Future<List<File>> appwriteStorageService() async {
  List<File> savedFiles = [];

  final Client client = Client();

  client.setEndpoint(endpoint).setProject(projectId).setKey(apiKey);

  // Initialise the storage SDK
  final storage = Storage(client);

  final res = await storage.listFiles(orderType: 'DESC');

  final data = res.data;

  final files = List.from(data['files']);

  log('[INFO] Found ${files.length} files');

  for (final file in files) {
    final filename = file['name'];
    final fileId = file['\$id'];

    print('[INFO] Downloading: $filename..');

    // download cloud file to disk
    final res = await storage.getFileDownload(fileId: fileId);

    // save bytes to file
    final saved = await saveFileOffline(filename, res.data);

    log(saved.path, 'd');

    // append file to list
    savedFiles.add(saved);
  }

  return savedFiles;
}
