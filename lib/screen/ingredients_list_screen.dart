import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ly/dialogs/ingredient_dialog.dart';
import 'package:recipe_ly/model/ingredient.dart';
import 'package:recipe_ly/model/ingredients_list.dart';

import '../services/appwrite_service.dart';

class IngredientsListScreen extends StatefulWidget {
  final IngredientsList ingredientsList;

  const IngredientsListScreen({super.key, required this.ingredientsList});

  @override
  IngredientsListScreenState createState() => IngredientsListScreenState();
}

class IngredientsListScreenState extends State<IngredientsListScreen> {
  Ingredient? _recentlyRemovedIngredient;
  int? _recentlyRemovedIndex;
  //TODO: Reformat code and move callOpenAi to Utils
  Future<void> callOpenAi() async {
    Functions functions = Functions(AppwriteService.client);
    if (!mounted) return;

    Future result = functions.createExecution(
      functionId: '6772e1ae002207c1e1b3',
      body: widget.ingredientsList.toJson().toString(),
      method: ExecutionMethod.pOST,
      path: '/get/recipes',
      headers: {},
    );
    result.then((response) {
      if (response.responseStatusCode == 200) {
        var jsonMap = jsonDecode(jsonDecode(response.responseBody));
        print(jsonMap.toString());
        //TODO: Use the the recipe generated and navigate to recipes page
        // IngredientsList ingredientsList = IngredientsList.fromJson(jsonMap);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => IngredientsListScreen(
        //       ingredientsList: ingredientsList,
        //     ),
        //   ),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error: ${response.responseStatusCode}, ${response.responseBody}'),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
        ),
      );
    });
  }

  void _addOrEditIngredient({Ingredient? ingredient, int? index}) {
    showDialog(
      context: context,
      builder: (context) => IngredientDialog(
        ingredient: ingredient,
        onSave: (newIngredient) {
          setState(() {
            if (index != null) {
              widget.ingredientsList.ingredients[index] =
                  newIngredient; // Edit mode
            } else {
              widget.ingredientsList.ingredients.add(newIngredient); // Add mode
            }
          });
        },
      ),
    );
  }

  void _deleteIngredient(int index) {
    _recentlyRemovedIngredient = widget.ingredientsList.ingredients[index];
    _recentlyRemovedIndex = index;

    setState(() {
      widget.ingredientsList.ingredients.removeAt(index);
    });
    // Show Snackbar with Undo action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ingredient deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).clearSnackBars();
            if (_recentlyRemovedIngredient != null &&
                _recentlyRemovedIndex != null) {
              setState(() {
                widget.ingredientsList.ingredients.insert(
                    _recentlyRemovedIndex!, _recentlyRemovedIngredient!);
              });

              _recentlyRemovedIngredient = null;
              _recentlyRemovedIndex = null;
            }
          },
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.cardColor,
        child: Icon(Icons.add),
        onPressed: () => _addOrEditIngredient(),
      ),
      appBar: AppBar(
        title: Text("Ingredients List"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: theme.primaryColor,
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: widget.ingredientsList.ingredients.isEmpty
          ? Center(
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 32),
                color: theme.cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 64, color: theme.primaryColor),
                      SizedBox(height: 16),
                      Text(
                        "No ingredients added yet!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Start adding your ingredients by tapping the '+' button below.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: widget.ingredientsList.ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = widget.ingredientsList.ingredients[index];

                return Dismissible(
                  key: Key(ingredient.name ?? ingredient.product),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    final removedIngredient = ingredient;
                    _deleteIngredient(index);

                    // Show Undo Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ingredient deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              widget.ingredientsList.ingredients
                                  .insert(index, removedIngredient);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: theme.cardColor,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Product Name (Takes up remaining space)
                          Expanded(
                            child: Text(
                              ingredient.name ?? ingredient.product,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Quantity Controls and Edit Button
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    if (ingredient.amount > 1)
                                      ingredient.amount--;
                                  });
                                },
                              ),
                              Text(
                                '${ingredient.amount} ${ingredient.unit.toShortString()}',
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.green),
                                onPressed: () {
                                  setState(() {
                                    ingredient.amount++;
                                  });
                                },
                              ),

                              // Edit Button
                              IconButton(
                                icon:
                                    Icon(Icons.edit, color: theme.primaryColor),
                                onPressed: () => _addOrEditIngredient(
                                    ingredient: ingredient, index: index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
