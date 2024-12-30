import 'ingredients_list.dart';

class RecipeStep {
  final String number;
  final String description;

  RecipeStep(this.number, this.description);

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(json["number"].toString(), json["description"]);
  }
}

class Recipe {
  final String name;
  final IngredientsList ingredientsList;
  final List<RecipeStep> steps;

  Recipe({required this.name, required this.ingredientsList, required this.steps});

  // Factory method to create a Recipe object from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    var list = json["steps"] as List;
    List<RecipeStep> steps = list.map((i) => RecipeStep.fromJson(i)).toList();
    return Recipe(name: json["name"], ingredientsList: IngredientsList.fromJson(json), steps: steps);
  }

  // Convert Ingredient object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ingredients': ingredientsList,
      'steps': steps
    };
  }
}
