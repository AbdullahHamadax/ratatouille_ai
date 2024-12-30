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
    setState(() {
      widget.ingredientsList.ingredients.removeAt(index);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Ingredient deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: theme.colorScheme.onSecondary,
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
      body: ListView.builder(
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              if (ingredient.amount > 0) ingredient.amount--;
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
                          icon: Icon(Icons.edit, color: theme.primaryColor),
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
