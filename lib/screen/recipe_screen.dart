import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe_ly/model/ingredients_list.dart';
import 'package:recipe_ly/model/recipe.dart';

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;
  RecipeScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //TODO: Ask chatgpt for an image and display it
    //TODO: Ask chatgpt for an estimated preparation time
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
              child: Center(
                child: Image.asset(
                  'assets/images/fruits.jpg',
                  // width: 200.0, // Set width (optional)
                  // height: 200.0, // Set height (optional)
                  fit: BoxFit.cover, // Adjust how the image fit
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(
                      Icons.timer,
                      color: Colors.deepOrange,
                    ),
                  ),
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text: "${recipe.preparationTime} minutes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepOrange),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: DefaultTabController(
                  length: 2,
                  child: Column(children: [
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
                          ]),
                    ),
                    Expanded(
                      flex: 1,
                      child: TabBarView(children: [
                        IngredientsListTab(
                            ingredientsList: recipe.ingredientsList),
                        StepsListTab(steps: recipe.steps)
                      ]),
                    ),
                  ]),
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
