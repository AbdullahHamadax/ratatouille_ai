import 'ingredients_list.dart';

class RecipeStep {
  final String number;
  final String description;

  RecipeStep(this.number, this.description);

  factory RecipeStep.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecipeStep(json["number"].toString(), json["description"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "description": description,
    };
  }
}

class Recipe {
  final String name;
  final IngredientsList ingredientsList;
  final List<RecipeStep> steps;
  final int preparationTime;

  Recipe(
      {required this.name,
      required this.ingredientsList,
      required this.steps,
      required this.preparationTime});

  // Factory method to create a Recipe object from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    var list = json["steps"] as List;
    List<RecipeStep> steps;

    steps = list.map((i) => RecipeStep.fromJson(i)).toList();

    return Recipe(
        name: json["name"],
        ingredientsList: IngredientsList.fromJson(json),
        steps: steps,
        preparationTime: json["preparationTime"]);
  }

  // Convert Ingredient object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'steps': steps.map((step) => step.toJson()).toList(),
      'preparationTime': preparationTime,
      ...ingredientsList.toJson()
    };
  }
}
