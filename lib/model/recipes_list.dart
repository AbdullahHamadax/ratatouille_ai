import 'recipe.dart';

class RecipesList {
  final List<Recipe> recipesList;

  RecipesList({required this.recipesList});

  // Factory method to create RecipesList from JSON
  factory RecipesList.fromJson(Map<String, dynamic> json) {
    var list = json["recipes"] as List;
    List<Recipe> recipesList =
    list.map((i) => Recipe.fromJson(i)).toList();
    return RecipesList(recipesList: recipesList);
  }

  // Convert RecipesList object to JSON
  Map<String, dynamic> toJson() {
    return {
      'recipes': recipesList.map((i) => i.toJson()).toList(),
    };
  }
}
