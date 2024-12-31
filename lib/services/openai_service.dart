import 'dart:convert';
import 'package:appwrite/enums.dart';
import 'package:recipe_ly/model/ingredients_list.dart';
import 'package:recipe_ly/model/recipes_list.dart';
import 'package:recipe_ly/services/appwrite_service.dart';

class OpenaiService {
  static void init() {}

  static Future<IngredientsList> extractIngredients(
      String base64Image, String imageUrl) async {
    final result = await AppwriteService.functions.createExecution(
        functionId: AppwriteService.recipesFunctionId,
        body: "data:image/jpeg;base64,$base64Image",
        method: ExecutionMethod.pOST,
        headers: {},
        path: "/get/ingredients");

    if (result.responseStatusCode == 200) {
      final String pureJsonString = jsonDecode(result.responseBody);
      final jsonMap = jsonDecode(pureJsonString);
      final ingredientsList = IngredientsList.fromJson(jsonMap);

      await AppwriteService.updateIngredientsListWithImage(
          imageUrl, pureJsonString);

      return ingredientsList;
    } else {
      throw Exception(
          'Error: ${result.responseStatusCode}, ${result.responseBody}');
    }
  }

  static Future<RecipesList> generateRecipes(
      IngredientsList ingredientsList) async {
    final result = await AppwriteService.functions.createExecution(
      functionId: AppwriteService.recipesFunctionId,
      body: ingredientsList.toJson().toString(),
      method: ExecutionMethod.pOST,
      path: '/get/recipes',
      headers: {},
    );
    if (result.responseStatusCode == 200) {
      var jsonMap = jsonDecode(jsonDecode(result.responseBody));
      // print(jsonMap.toString());
      // Recipe recipe = Recipe.fromJson(jsonMap);
      // List<Recipe> recipes = [recipe, recipe, recipe];
      // final recipesList = RecipesList(recipes: recipes);
      final recipesList = RecipesList.fromJson(jsonMap);
      await AppwriteService.updateIngredientsListWithRecipes(recipesList);

      return recipesList;
    } else {
      throw Exception(
          'Error: ${result.responseStatusCode}, ${result.responseBody}');
    }
  }
}
