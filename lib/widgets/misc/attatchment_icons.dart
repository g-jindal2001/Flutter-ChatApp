import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AttatchmentIcons extends StatefulWidget {
  final String name;
  final String description;
  final Function(File file, String type, String name) selectedFile;

  AttatchmentIcons(this.name, this.description, this.selectedFile);

  @override
  _AttatchmentIconsState createState() => _AttatchmentIconsState();
}

class _AttatchmentIconsState extends State<AttatchmentIcons> {
  File _finalpickedImage;
  File _finalpickedDocument;
  String _finalFileName;

  void chooseImage() async {
    try {
      if (widget.name == 'camera' || widget.name == 'gallery') {
        final picker = ImagePicker();
        final selectedImage = await picker.getImage(
          source: widget.name == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640,
        );
        final pickedImage = File(
            selectedImage.path); //Converting type PickedFile into type File
        final fileName = basename(selectedImage
            .path); //returns the image name as set by the device camera for that image

        setState(() {
          _finalpickedImage = pickedImage;
          _finalFileName = fileName;
        });

        widget.selectedFile(_finalpickedImage, 'image', fileName);
      }
    } catch (error) {
      print(error); //User cancelled the request
    }
  }

  void chooseDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );

    if (result != null) {
      final pickedFile =
          File(result.files.single.path); //Converting FilePickerResult to File

      final fileName = basename(result.files.single.path);
      print(fileName);

      setState(() {
        _finalpickedDocument = pickedFile;
        _finalFileName = fileName;
      });

      widget.selectedFile(_finalpickedDocument, 'doc', fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.name == 'document' ? chooseDocument : chooseImage,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/${widget.name}.png'),
          ),
          Text(widget.description)
        ],
      ),
    );
  }
}
