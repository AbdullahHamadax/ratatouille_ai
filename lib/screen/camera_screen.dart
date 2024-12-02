import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

late List<CameraDescription> cameras;
late CameraController _cameraController;

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
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Ensure the camera is initialized.
                          await _initializeControllerFuture;

                          // Capture the picture.
                          final XFile picture =
                              await _cameraController.takePicture();

                          final Uint8List imageBytes =
                              await File(picture.path).readAsBytes();

                          await File(picture.path).delete();
                        } catch (e) {}
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                      ),
                      child: Icon(Icons.camera, size: 32),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Display a loading spinner until the camera is initialized.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
