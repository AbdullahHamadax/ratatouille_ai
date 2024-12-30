import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await callOpenAi();
          print(widget.ingredientsList.toJson());
        },
      ),
      appBar: AppBar(
        title: Text("Ingredients List"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: ListView.builder(
        itemCount: widget.ingredientsList.ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = widget.ingredientsList.ingredients[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ingredient Name
                  Text(
                    ingredient.name ?? ingredient.product,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),

                  // Quantity Controls
                  Row(
                    children: [
                      // Minus Button
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            if (ingredient.amount > 0) ingredient.amount--;
                          });
                        },
                      ),

                      // Quantity Display
                      Text(
                        ingredient.amount.toString(),
                        style: TextStyle(fontSize: 16),
                      ),

                      // Plus Button
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          setState(() {
                            ingredient.amount++;
                          });
                        },
                      ),
                    ],
                  ),

                  // Tiny Plus Button
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                    onPressed: () {
                      // Placeholder for future functionality
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
