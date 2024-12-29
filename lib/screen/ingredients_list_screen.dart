import 'package:flutter/material.dart';
import 'package:recipe_ly/model/ingredients_list.dart';

class IngredientsListScreen extends StatefulWidget {
  final IngredientsList ingredientsList;

  const IngredientsListScreen({super.key, required this.ingredientsList});

  @override
  IngredientsListScreenState createState() => IngredientsListScreenState();
}

class IngredientsListScreenState extends State<IngredientsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingredients List"),
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
