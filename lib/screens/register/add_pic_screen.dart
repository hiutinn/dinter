import 'dart:io';

import 'package:dinter/constants/colors.dart';
import 'package:dinter/models/user_model.dart';
import 'package:dinter/screens/home_screen.dart';
import 'package:dinter/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddPicScreen extends StatefulWidget {
  const AddPicScreen({super.key, required this.user});
  final User user;

  @override
  State<AddPicScreen> createState() => _AddPicScreenState();
}

class _AddPicScreenState extends State<AddPicScreen> {
  File? imageFile;

  Future pickImageFromGallery() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print("Failed to pick image: $e");
    }
  }

  Widget showImage() {
    if (imageFile != null) {
      return SizedBox(height: 300, child: Image.file(imageFile!));
    } else {
      return const Text("No image");
    }
  }

  Future<String> uploadFileAndGetURL(File file) async {
    // Generate a unique filename for the uploaded file
    String fileName = path.basename(file.path);

    // Create a reference to the desired location in Firebase Storage
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child(fileName);

    // Upload the file to Firebase Storage
    await ref.putFile(file);

    // Retrieve the download URL for the uploaded file
    String downloadURL = await ref.getDownloadURL();

    // Return the download URL
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(children: [
            const Text(
              'Làm cái ảnh cho đẹp :>',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            showImage(),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                onPressed: () {
                  pickImageFromGallery();
                },
                child: const Text("Chọn ảnh")),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(MyColor.primaryColor)),
                onPressed: () async {
                  try {
                    await uploadFileAndGetURL(imageFile!).then((imageUrl) {
                      widget.user.imageUrl = imageUrl;
                      UserService().createUser(widget.user).then((value) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                            ((route) => false));
                      });
                    });
                  } catch (e) {
                    // ignore: avoid_print
                    print(e);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: const Text(
                    'Hoàn thành',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
