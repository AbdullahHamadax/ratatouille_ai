import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // For parsing JSON

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:recipe_ly/model/ingredients_list.dart';
import 'package:recipe_ly/screen/ingredients_list_screen.dart';
import 'package:recipe_ly/services/appwrite_service.dart';

late List<CameraDescription> cameras;
late CameraController _cameraController;

const String prompt = "please identify all ingredients in this image!";

Future<void> initializeCamera() async {
  cameras = await availableCameras();
  _cameraController = CameraController(cameras.first, ResolutionPreset.high);
  await _cameraController.initialize();
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> callOpenAi(String base64Image) async {
    Functions functions = Functions(AppwriteService.client);
    if (!mounted) return;

    Future result = functions.createExecution(
      functionId: '6772e1ae002207c1e1b3',
      body: "data:image/jpeg;base64,$base64Image",
      method: ExecutionMethod.pOST,
      headers: {},
    );

    result.then((response) {
      if (response.responseStatusCode == 200) {
        var jsonMap = jsonDecode(jsonDecode(response.responseBody));
        IngredientsList ingredientsList = IngredientsList.fromJson(jsonMap);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IngredientsListScreen(
              ingredientsList: ingredientsList,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error: ${response.responseStatusCode}, ${response.responseBody}'),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    });
  }

  Future<void> takePicture(BuildContext context) async {
    late XFile picture;
    try {
      // Ensure the camera is initialized.
      await _initializeControllerFuture;

      picture = await _cameraController.takePicture();
      late final Uint8List imageBytes;
      if (kIsWeb) {
        imageBytes = await picture.readAsBytes();
      } else {
        imageBytes = await File(picture.path).readAsBytes();
      }

      final String base64Image = base64Encode(imageBytes);

      await callOpenAi(base64Image);
    } finally {
      await File(picture.path).delete();
    }
  }

  Future<void> openGallery(BuildContext context) async {
    if (!mounted) return;
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        final String base64Image = base64Encode(imageBytes);

        if (!mounted) return;

        await callOpenAi(base64Image);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No image selected'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Display the camera preview as full screen if initialized.
            return Stack(
              children: [
                SizedBox.expand(
                  child: CameraPreview(_cameraController),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Button to skip to the next page
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/nextPage'),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(Icons.arrow_forward, size: 32),
                      ),

                      // Capture button
                      ElevatedButton(
                        onPressed: () => takePicture(context),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(Icons.camera, size: 32),
                      ),

                      // Button to open the gallery
                      ElevatedButton(
                        onPressed: () => openGallery(context),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(Icons.photo, size: 32),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
