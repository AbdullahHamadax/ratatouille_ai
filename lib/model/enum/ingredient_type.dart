enum IngredientType {
  fruit,
  vegetable,
  spice,
  legume,
  herb,
  grain,
  nut,
  dairy,
  meat,
  seafood,
  oil;

  // Convert string values to enum
  static IngredientType fromString(String value) {
    return IngredientType.values
        .firstWhere((e) => e.toString().split('.').last == value);
  }

  // Convert enum to string value
  String toShortString() {
    return toString().split('.').last;
  }
}
