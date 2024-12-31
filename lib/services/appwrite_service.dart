import 'dart:convert';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:recipe_ly/model/ingredient.dart';
import 'package:recipe_ly/model/recipe.dart';
import 'package:recipe_ly/model/recipes_list.dart';
import 'package:recipe_ly/services/data_service.dart';

class AppwriteService {
  static final String endpoint = 'https://cloud.appwrite.io/v1';
  static final String projectId = '6772e13e0030e088531f';

  static final Client client = Client();

  static final Account account = Account(client);
  static final Databases databases = Databases(client);
  static final Storage storage = Storage(client);
  static final Functions functions = Functions(client);

  static final String databaseId = '6772f54300021614d750';
  static final String operationsCollectionId = '6772f5a10035ed3e74ca';
  static final String recipesCollectionId = '67735b8700103d53cd2d';

  static final String recipesFunctionId = '6772e1ae002207c1e1b3';

  static final String bucketId = '6772f6470035a6304644';

  static void init() {
    client.setEndpoint(endpoint).setProject(projectId);
    // .setProject('6744a0f700127fd3f71b');
  }

  static String getImageUrl(String fileId) {
    return 'https://cloud.appwrite.io/v1/storage/buckets/your_bucket_id/files/$fileId/view?project=$projectId';
  }

  static Future<RecipesList> getAllRecipes() async {
    List<Recipe> recipesList = [];
    try {
      final userId = await AppwriteService.account.get().then((user) {
        return user.$id; // Get the user's unique ID.
      });

      final result = await AppwriteService.databases.listDocuments(
        databaseId: databaseId,
        collectionId: recipesCollectionId,
        queries: [
          Query.equal('userId', userId),
        ],
      );
      for (var document in result.documents) {
        var data = jsonDecode(document.data["recipe"]);
        recipesList.add(Recipe.fromJson(data));
      }
    } catch (e) {
      print('Error updating database: $e');
    }
    return RecipesList(recipes: recipesList);
  }

  static Future<void> updateIngredientsListWithImage(
      String imageUrl, String ingredientData) async {
    try {
      final userId = await AppwriteService.account.get().then((user) {
        return user.$id; // Get the user's unique ID.
      });

      final result = await AppwriteService.databases.createDocument(
        databaseId: databaseId,
        collectionId: operationsCollectionId,
        documentId: ID.unique(),
        data: {
          'imageUrl': imageUrl,
          'ingredientsList': ingredientData,
          'userId': userId
        },
      );
      DataService.currentOperationId = result.$id;
    } catch (e) {
      print('Error updating database: $e');
    }
  }

  static Future<void> updateIngredientsListWithRecipes(
      RecipesList recipeList) async {
    try {
      final userId = await AppwriteService.account.get().then((user) {
        return user.$id; // Get the user's unique ID.
      });

      final recipeIds = [];

      for (var recipe in recipeList.recipes) {
        var result = await AppwriteService.databases.createDocument(
          databaseId: databaseId,
          collectionId: recipesCollectionId,
          documentId: ID.unique(),
          data: {'recipe': jsonEncode(recipe), 'userId': userId},
        );
        recipeIds.add(result.$id);
      }

      await AppwriteService.databases.updateDocument(
        databaseId: databaseId,
        collectionId: operationsCollectionId,
        documentId: DataService.currentOperationId,
        data: {'recipes': recipeIds},
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

  static Future<String> getImageRecipeUrl(String recipeName) async {
    final result = await AppwriteService.functions.createExecution(
      functionId: AppwriteService.recipesFunctionId,
      body: recipeName,
      method: ExecutionMethod.pOST,
      path: '/get/image',
      headers: {},
    );
    if (result.responseStatusCode == 200) {
      var jsonMap = jsonDecode(result.responseBody);
      return jsonMap["image"];
    } else {
      throw Exception(
          'Error: ${result.responseStatusCode}, ${result.responseBody}');
    }
  }
}
