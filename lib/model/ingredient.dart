import 'enum/unit.dart';
import 'enum/ingredient_type.dart';

class Ingredient {
  String? name;
  String product;
  IngredientType type;
  int amount;
  Unit unit;

  Ingredient({
    this.name,
    required this.product,
    required this.type,
    required this.amount,
    required this.unit,
  });

  // Factory method to create an Ingredient object from JSON
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      product: json['product'],
      type: IngredientType.fromString(json['type']),
      amount: json['amount'],
      unit: Unit.fromString(json['unit']),
    );
  }

  // Convert Ingredient object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'product': product,
      'type': type.toShortString(),
      'amount': amount,
      'unit': unit.toShortString(),
    };
  }
}
