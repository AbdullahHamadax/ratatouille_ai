import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final String endpoint = 'https://cloud.appwrite.io/v1';
  static final String projectId = '6772e13e0030e088531f';

  static final Client client = Client();

  static final Account account = Account(client);
  static final Databases databases = Databases(client);
  static final Storage storage = Storage(client);
  static final Functions functions = Functions(client);

  static final String databaseId = '6772f54300021614d750';
  static final String collectionId = '6772f5a10035ed3e74ca';

  static final String recipesFunctionId = '6772e1ae002207c1e1b3';

  static final String bucketId = '6772f6470035a6304644';

  static void init() {
    client.setEndpoint(endpoint).setProject(projectId);
    // .setProject('6744a0f700127fd3f71b');
  }

  static String getImageUrl(String fileId) {
    return 'https://cloud.appwrite.io/v1/storage/buckets/your_bucket_id/files/$fileId/view?project=$projectId';
  }

  static Future<void> updateIngredientsListWithImage(
      String imageUrl, String ingredientData) async {
    try {
      final userId = await AppwriteService.account.get().then((user) {
        return user.$id; // Get the user's unique ID.
      });

      await AppwriteService.databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
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
        bucketId: bucketId,
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
