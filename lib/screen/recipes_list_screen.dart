import 'package:flutter/material.dart';
import 'package:recipe_ly/model/recipes_list.dart';


class RecipesListScreen extends StatefulWidget {
  final RecipesList recipesList;

  const RecipesListScreen({super.key, required this.recipesList});

  @override
  RecipesListScreenState createState() => RecipesListScreenState();
}

class RecipesListScreenState extends State<RecipesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes List"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: ListView.builder(
        itemCount: widget.recipesList.recipes.length,
        itemBuilder: (context, index) {
          final recipe = widget.recipesList.recipes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ingredient Name
                  Text(
                    recipe.name ?? "NA",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  // Tiny Plus Button
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
