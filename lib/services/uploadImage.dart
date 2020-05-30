import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as im;
import 'package:path_provider/path_provider.dart';

class ImageService {

  ImageService imageService;
  // File _image;
  final picker = ImagePicker();

  Future<File> pickImage({@required ImageSource source}) async {
    var _selectedImage = await picker.getImage(source: source);

    File _image = File(_selectedImage.path);
    return compressImage(_image);
  }

  Future<File> compressImage(File imageFile) async {
    final dir = await getTemporaryDirectory();
    final path = dir.path;
    int random = Random().nextInt(1000);
    im.Image image = im.decodeImage(imageFile.readAsBytesSync());
    im.copyResize(image, width: 500, height: 500);

    return new File('$path/img_$random.jpg')
      ..writeAsBytesSync(im.encodeJpg(image, quality: 85));
  }
}
