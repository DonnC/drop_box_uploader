import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

import 'drop_box.dart';

// TODO: paste your dropbox oauth2 token here
final String token = '';

// should enable logging?
final bool enableLogging = true;

final _log = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    printEmojis: false,
  ),
);

void main(List<String> arguments) async {
  log('--- starting ---');

  /// pass your file here to upload
  final _file = File('tpl.docx');

  log(_file);

  // path should start with '/' -> /test.dart
  // automatically using file basename as cloud file path on dropbox
  final pathOfFile = '/' + path.basename(_file.path);

  final dropBox = DropBox(path: pathOfFile, dropBoxToken: token);

  final result = await dropBox.upload(_file);

  print(result.toString());
}

/// nothing too fancy, probably redundancy
void log(var data, [String? type]) {
  if (enableLogging) {
    if (type == null) {
      _log.i(data.toString());
    }

    // switch
    else {
      switch (type) {
        case 'i':
          _log.i(data.toString());
          break;
        case 'd':
          _log.d(data.toString());
          break;
        case 'e':
          _log.e(data.toString());
          break;
        default:
          _log.i(data.toString());
      }
    }
  }
}
