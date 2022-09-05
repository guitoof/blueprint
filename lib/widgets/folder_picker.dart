import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FolderPicker extends StatefulWidget {
  final void Function(Directory) onFolderSelected;

  const FolderPicker({Key? key, required this.onFolderSelected})
      : super(key: key);

  @override
  State<FolderPicker> createState() => _FolderPickerState();
}

class _FolderPickerState extends State<FolderPicker> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _isLoading = false;

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path == null) return;
      widget.onFolderSelected(Directory(path));
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: ((context) {
      return FloatingActionButton(
        onPressed: () => _selectFolder(),
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.folder),
      );
    }));
  }
}
