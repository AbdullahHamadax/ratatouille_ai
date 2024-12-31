import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_ly/model/ingredients_list.dart';
import 'package:recipe_ly/model/recipe.dart';
import 'package:recipe_ly/services/appwrite_service.dart';

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  RecipeScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text(recipe.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 200,
              child: FutureBuilder<String>(
                future: AppwriteService.getImageRecipeUrl(
                    recipe.name), // Fetch the URL
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator while waiting for the image URL
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show error if something went wrong
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    // Show image once data is received
                    return Center(
                      child: Image.network(
                        snapshot.data!, // Use the URL returned by the function
                        fit: BoxFit.cover, // Adjust how the image fits
                      ),
                    );
                  } else {
                    // If no data, show a placeholder or default message
                    return Center(child: Text('No image found.'));
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(10),
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.deepOrange,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "${recipe.preparationTime} minutes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.deepOrange),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      child: TabBar(
                        unselectedLabelColor: Colors.deepOrange,
                        labelColor: Colors.deepOrangeAccent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Container(
                              height: 40,
                              child: Center(child: Text("Ingredients"))),
                          Container(
                              height: 40,
                              child: Center(child: Text("Recipes"))),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TabBarView(
                        children: [
                          IngredientsListTab(
                              ingredientsList: recipe.ingredientsList),
                          StepsListTab(steps: recipe.steps),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientsListTab extends StatefulWidget {
  final IngredientsList ingredientsList;
  IngredientsListTab({required this.ingredientsList});

  @override
  State<IngredientsListTab> createState() =>
      _IngredientsListTabState(length: this.ingredientsList.ingredients.length);
}

class _IngredientsListTabState extends State<IngredientsListTab> {
  // List of booleans to track whether an item is checked or not
  final int length;
  late final List<bool> itemChecked;
  _IngredientsListTabState({required this.length}) {
    itemChecked = List.generate(this.length, (index) => false);
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.ingredientsList.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = widget.ingredientsList.ingredients[index];
        return CheckboxListTile(
          value: itemChecked[index],
          onChanged: (bool? selected) {
            setState(() {
              itemChecked[index] = selected!;
            });
          },
          title:
              Text(widget.ingredientsList.ingredients[index].name.toString()),
        );
      },
    );
  }
}

class StepsListTab extends StatefulWidget {
  final List<RecipeStep> steps;
  StepsListTab({required this.steps});

  @override
  State<StepsListTab> createState() => _StepsListTabState();
}

class _StepsListTabState extends State<StepsListTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: widget.steps.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Card(
                    elevation: 1,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: theme.cardColor,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          child: Text(widget.steps[index].description),
                        )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
