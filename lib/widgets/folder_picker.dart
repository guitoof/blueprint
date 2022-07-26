import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FolderPicker extends StatefulWidget {
  const FolderPicker({Key? key}) : super(key: key);

  @override
  State<FolderPicker> createState() => _FolderPickerState();
}

class _FolderPickerState extends State<FolderPicker> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _directoryPath;
  bool _isLoading = false;

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      print(path);

      if (path == null) return;
      print(path.replaceAll(RegExp(r' '), '%20'));
      final myDir = new Directory(path);
      List<FileSystemEntity> _folders = myDir
          .listSync(recursive: true, followLinks: false)
          .where((FileSystemEntity fileSystemEntity) {
        final isDartFile = fileSystemEntity.uri.path.endsWith('.dart');
        if (isDartFile) {
          final relativePath = fileSystemEntity.uri.path
              .split(path.replaceAll(RegExp(r' '), '%20'))
              .last;
          print(path.replaceAll(RegExp(r' '), '%20'));
          // print(relativePath.contains(path.replaceAll(RegExp(r' '), '%20')));
          print(relativePath);
        }
        return isDartFile;
      }).toList();
      print(_folders.length);

      setState(() {
        _directoryPath = path;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectFolder(),
                child: const Text('Load project...'),
              ),
            ],
          ),
        ),
        Builder(
          builder: (BuildContext context) => _isLoading
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: CircularProgressIndicator(),
                )
              : _directoryPath != null
                  ? ListTile(
                      title: const Text('Directory path'),
                      subtitle: Text(_directoryPath!),
                    )
                  : const SizedBox(),
        ),
      ],
    );
  }
}
