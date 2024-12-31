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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 500,
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
                              text: "15 minutes",
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
                            SizedBox(
                              height: 220.0,
                              child: TabBarView(
                                  children: [Text("Second"), Text("Third")]),
                            )
                          ]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//
// class IngredientsListTab extends StatelessWidget {
//   final IngredientsList ingredientsList;
//   IngredientsListTab({required this.ingredientsList});
//
//   @override
//   Widget build(BuildContext context) {
//     return  ListView.builder(
//       itemCount: ingredientsList.ingredients.length,
//       itemBuilder: (context, index) {
//         final ingredient = ingredientsList.ingredients[index];
//         return CheckboxListTile(
//           value: _selecteCategorys
//               .contains(_categories['responseBody'][index]['category_id']),
//           onChanged: (bool selected) {
//             _onCategorySelected(selected,
//                 _categories['responseBody'][index]['category_id']);
//           },
//           title: Text(_categories['responseBody'][index]['category_name']),
//         );
//       },
//     );
//   }
// }