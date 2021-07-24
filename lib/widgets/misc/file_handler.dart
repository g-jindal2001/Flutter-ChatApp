import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class FileHandler extends StatefulWidget {
  final String name;
  final String url;

  FileHandler(this.name, this.url);
  @override
  _FileHandlerState createState() => _FileHandlerState();
}

class _FileHandlerState extends State<FileHandler> {
  Future<String> get _localDevicePath async {
    final _devicePath = await getApplicationDocumentsDirectory();
    return _devicePath.path;
  }

  Future<File> _localFile(String name) async {
    String _path = await _localDevicePath;

    var _newPath = await Directory("$_path").create();
    return File("${_newPath.path}/$name");
  }

  Future<void> _downloadAndOpenFile() async {
    final _response = await http.get(Uri.parse(widget.url));

    if (_response.statusCode == 200) {
      final _file = await _localFile(widget.name);
      final _saveFile = await _file.writeAsBytes(_response.bodyBytes);

      print(_saveFile.path);

      final result = await OpenFile.open(_saveFile.path);
      print(result.message);
    } else {
      print(_response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _downloadAndOpenFile,
      child: Text(widget.name),
    );
  }
}
