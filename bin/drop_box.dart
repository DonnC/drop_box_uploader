import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'console_log.dart';


// helper service class
class DropBox {
  static final Uri _url =
      Uri.parse("https://content.dropboxapi.com/2/files/upload");

  /// determine mode of file upload, best to set to `overwrite` to avoid conflicts in case of same file name
  ///
  /// trying to be uploaded on dropbox
  ///
  /// valid options are >>> add, overwrite, update
  final String writeMode;

  /// rename file strategy, if same file exist either rename or leave as is, default to `true`
  final bool autorename;

  /// the path on your dropbox cloud server storage to store the file
  ///
  ///  Path in the user's Dropbox to save the file.
  ///
  /// String(pattern="(/(.|[\r\n])*)|(ns:[0-9]+(/.*)?)|(id:.*)")
  final String path;

  // dropbox oauth2 token
  late String _token;

  // headers
  late Map<String, String> _headers;

  DropBox({
    this.writeMode = 'overwrite',
    this.autorename = true,
    required this.path,
    required String dropBoxToken,
  }) {
    // add token
    _token = dropBoxToken;

    // create api args
    final _apiArgs = {
      "path": path,
      "mode": {
        ".tag": writeMode,
      },
      "autorename": autorename,
    };

    // create request headers
    _headers = {
      'Authorization': 'Bearer $_token',
      "Content-Type": "application/octet-stream",
      "Dropbox-API-Arg": jsonEncode(_apiArgs),
    };

    log(_headers, 'd');
  }

  /// upload a file to your dropbox cloud storage
  Future<String?> upload(File fileToUpload) async {
    final _client = http.Client();

    var filePath = fileToUpload.path;

    try {
      final bytes = await fileToUpload.readAsBytes();

      final response = await _client.post(_url, body: bytes, headers: _headers);

      if (response.statusCode == 200) {
        final res = response.body;

        log(res, 'd');

        // success
        return '[INFO] File: $filePath successfully uploaded on your dropbox account';
      }

      // something went wrong
      else {
        print('[ERROR] Failed to upload: $filePath to dropbox!');

        final err = response.body;

        log(err, 'e');

        return err.toString();
      }
    }

    // http err
    on http.ClientException catch (ce) {
      log(ce, 'e');
      return ce.message;
    }

    // err
    catch (e) {
      log(e, 'e');
      return e.toString();
    }

    // close
     finally {
      _client.close();
    }
  }
}
