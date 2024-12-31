import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:recipe_ly/model/ingredients_list.dart';
import 'package:recipe_ly/services/appwrite_service.dart';

class OpenaiService {
  static void init() {}

  static Future<IngredientsList> extractIngredients(
      String base64Image, String imageUrl) async {
    try {
      Functions functions = Functions(AppwriteService.client);
      final result = await functions.createExecution(
          functionId: '6772e1ae002207c1e1b3',
          body: "data:image/jpeg;base64,$base64Image",
          method: ExecutionMethod.pOST,
          headers: {},
          path: "/get/ingredients");

      if (result.responseStatusCode == 200) {
        final String pureJsonString = jsonDecode(result.responseBody);
        final jsonMap = jsonDecode(pureJsonString);
        final ingredientsList = IngredientsList.fromJson(jsonMap);
        return ingredientsList;
      } else {
        throw Exception(
            'Error: ${result.responseStatusCode}, ${result.responseBody}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
