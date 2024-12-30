import 'recipe.dart';

class RecipesList {
  final List<Recipe> recipes;

  RecipesList({required this.recipes});

  // Factory method to create RecipesList from JSON
  factory RecipesList.fromJson(Map<String, dynamic> json) {
    var list = json["recipes"] as List;
    List<Recipe> recipesList =
    list.map((i) => Recipe.fromJson(i)).toList();
    return RecipesList(recipes: recipesList);
  }

  // Convert RecipesList object to JSON
  Map<String, dynamic> toJson() {
    return {
      'recipes': recipes.map((i) => i.toJson()).toList(),
    };
  }
}
