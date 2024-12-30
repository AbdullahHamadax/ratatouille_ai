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
  bool _isLoading = false;
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
    setState(() {
      _isLoading = true;
    });
    _cameraController.pausePreview();
    try {
      Functions functions = Functions(AppwriteService.client);
      if (!mounted) return;

      Future result = functions.createExecution(
          functionId: '6772e1ae002207c1e1b3',
          body: "data:image/jpeg;base64,$base64Image",
          method: ExecutionMethod.pOST,
          headers: {},
          path: "/get/ingredients");

      result.then((response) {
        if (response.responseStatusCode == 200) {
          var jsonMap = jsonDecode(jsonDecode(response.responseBody));
          IngredientsList ingredientsList = IngredientsList.fromJson(jsonMap);

          setState(() {
            _isLoading = false;
          });
          _cameraController.resumePreview();

          Navigator.push(
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {}
  }

  Future<void> takePicture(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
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
    setState(() {
      _isLoading = true;
    });
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
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox.expand(
                  child: CameraPreview(_cameraController),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          // Overlay for loading
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Processing image...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Buttons at the bottom
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IngredientsListScreen(
                        ingredientsList: IngredientsList(ingredients: []),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Icon(Icons.arrow_forward, size: 32),
                ),

                // Capture Button
                ElevatedButton(
                  onPressed: () => takePicture(context),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Icon(Icons.camera, size: 32, color: Colors.white),
                ),

                // Gallery Button
                ElevatedButton(
                  onPressed: () => openGallery(context),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.green,
                  ),
                  child: Icon(Icons.photo, size: 32, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
