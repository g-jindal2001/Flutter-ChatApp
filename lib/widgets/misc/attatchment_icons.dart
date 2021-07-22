import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AttatchmentIcons extends StatefulWidget {
  final String name;
  final String description;
  final Function(File file) selectedFile;

  AttatchmentIcons(this.name, this.description, this.selectedFile);

  @override
  _AttatchmentIconsState createState() => _AttatchmentIconsState();
}

class _AttatchmentIconsState extends State<AttatchmentIcons> {
  File _finalpickedImage;
  File _finalpickedDocument;

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

        setState(() {
          _finalpickedImage = pickedImage;
        });
      }

      widget.selectedFile(_finalpickedImage);
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

      setState(() {
        _finalpickedDocument = pickedFile;
      });

      widget.selectedFile(_finalpickedDocument);
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
