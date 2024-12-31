import 'package:flutter/material.dart';
import 'package:recipe_ly/model/recipe.dart';
import 'package:recipe_ly/model/recipes_list.dart';
import 'package:recipe_ly/screen/recipe_screen.dart';
import 'package:recipe_ly/services/appwrite_service.dart'; // Import AppwriteService

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  Future<RecipesList>? _recipesFuture;

  Future<RecipesList> fetchRecipes() async {
    try {
      return await AppwriteService.getAllRecipes();
    } catch (e) {
      throw Exception('Failed to load recipes: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _recipesFuture = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _recipesFuture = fetchRecipes(); // Manually refresh data
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<RecipesList>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.recipes.isEmpty) {
            return const Center(
              child: Text('No recipes available'),
            );
          }

          final recipesList = snapshot.data!;
          return ListView.builder(
            itemCount: recipesList.recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipesList.recipes[index];
              return Card(
                key: Key(recipe.name),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // This ensures the Text widget can use available space
                          child: Text(
                            recipe.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                            overflow: TextOverflow
                                .ellipsis, // Adds ellipsis if the text overflows
                            maxLines: 1, // Ensures the text is in a single line
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
