import 'package:flutter/material.dart';
import 'package:recipe_ly/model/enum/ingredient_type.dart';
import 'package:recipe_ly/model/enum/unit.dart';
import 'package:recipe_ly/model/ingredient.dart';

class IngredientDialog extends StatefulWidget {
  final Ingredient? ingredient;
  final void Function(Ingredient) onSave;

  const IngredientDialog({super.key, this.ingredient, required this.onSave});

  @override
  State<IngredientDialog> createState() => _IngredientDialogState();
}

class _IngredientDialogState extends State<IngredientDialog> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String product;
  late IngredientType type;
  late int amount;
  late Unit unit;

  @override
  void initState() {
    super.initState();
    name = widget.ingredient?.name ?? '';
    product = widget.ingredient?.product ?? '';
    type = widget.ingredient?.type ?? IngredientType.fruit;
    amount = widget.ingredient?.amount ?? 1;
    unit = widget.ingredient?.unit ?? Unit.g;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.ingredient == null ? 'Add Ingredient' : 'Edit Ingredient'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Product Field
              TextFormField(
                initialValue: product,
                decoration: InputDecoration(labelText: 'Product'),
                onChanged: (value) => product = value,
                validator: (value) =>
                    value!.isEmpty ? 'Product is required' : null,
              ),
              SizedBox(height: 10),

              // Name Field
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
              ),
              SizedBox(height: 10),

              // Type Dropdown
              DropdownButtonFormField<IngredientType>(
                value: type,
                onChanged: (value) => setState(() => type = value!),
                items: IngredientType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Type'),
              ),
              SizedBox(height: 10),

              // Amount Field
              TextFormField(
                initialValue: amount.toString(),
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = int.tryParse(value) ?? 1,
                validator: (value) => (value == null ||
                        int.tryParse(value) == null ||
                        int.parse(value) <= 0)
                    ? 'Enter a valid amount'
                    : null,
              ),
              SizedBox(height: 10),

              // Unit Dropdown
              DropdownButtonFormField<Unit>(
                value: unit,
                onChanged: (value) => setState(() => unit = value!),
                items: Unit.values.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit.toString().split('.').last),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Unit'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                Ingredient(
                  product: product,
                  name: name,
                  type: type,
                  amount: amount,
                  unit: unit,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
