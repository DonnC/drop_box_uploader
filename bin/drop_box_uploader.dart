import 'package:path/path.dart' as path;

import 'aw_storage_service.dart';
import 'console_log.dart';
import 'constants.dart';
import 'drop_box.dart';
import 'file_utility.dart';

void main(List<String> arguments) async {
  log('--- starting ---');

  try {
    // load all cloud files available to backup
    final files = await appwriteStorageService();

    for (var file in files) {
      // path should start with '/' -> /test.dart
      // automatically using file basename as cloud file path on dropbox
      final pathOfFile = '/' + path.basename(file.path);

      final dropBox = DropBox(path: pathOfFile, dropBoxToken: token);

      final result = await dropBox.upload(file);

      print(result);

      log(result.toString());
    }

    // clean up saved files
    await deleteSavedFileOffline(files);
  }

  // err
  catch (e) {
    log(e, 'e');

    print('[ERROR] There was a problem: ${e.toString()}');
  }

  print('[INFO] Done!');
}
