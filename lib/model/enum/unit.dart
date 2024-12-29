enum Unit {
  g,
  kg,
  l,
  ml,
  cup,
  tbsp,
  tsp,
  oz,
  lb,
  pcs;

  // Convert string values to enum
  static Unit fromString(String value) {
    return Unit.values.firstWhere((e) => e.toString().split('.').last == value);
  }

  // Convert enum to string value
  String toShortString() {
    return toString().split('.').last;
  }
}
