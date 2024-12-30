import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final Client client = Client();

  static final Account account = Account(client);
  static final Databases databases = Databases(client);
  static final Storage storage = Storage(client);

  static void init() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6772e13e0030e088531f');
    // .setProject('6744a0f700127fd3f71b');
  }

  static String getImageUrl(String fileId) {
    return 'https://cloud.appwrite.io/v1/storage/buckets/your_bucket_id/files/$fileId/view?project=6772e13e0030e088531f';
  }

  static Future<void> updateIngredientsListWithImage(
      String imageUrl, String ingredientData) async {
    try {
      final userId = await AppwriteService.account.get().then((user) {
        return user.$id; // Get the user's unique ID.
      });

      await AppwriteService.databases.createDocument(
        databaseId: '6772f54300021614d750',
        collectionId: '6772f5a10035ed3e74ca',
        documentId: ID.unique(),
        data: {
          'imageUrl': imageUrl,
          'ingredientsList': ingredientData,
          'userId': userId
        },
      );
    } catch (e) {
      print('Error updating database: $e');
    }
  }

  static Future<String?> uploadImage(
      Uint8List imageBytes, String imageName) async {
    try {
      final result = await AppwriteService.storage.createFile(
        bucketId: '6772f6470035a6304644',
        fileId: ID.unique(),
        file: InputFile.fromBytes(
          bytes: imageBytes,
          filename: imageName,
        ),
      );

      return result.$id; // Return the File ID
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
