import 'ingredient.dart';

class IngredientsList {
  final List<Ingredient> ingredients;

  IngredientsList({required this.ingredients});

  // Factory method to create IngredientsList from JSON
  factory IngredientsList.fromJson(Map<String, dynamic> json) {
    var list = json["ingredients"] as List;
    List<Ingredient> ingredientsList =
        list.map((i) => Ingredient.fromJson(i)).toList();
    return IngredientsList(ingredients: ingredientsList);
  }

  // Convert IngredientsList object to JSON
  Map<String, dynamic> toJson() {
    return {
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
    };
  }
}
