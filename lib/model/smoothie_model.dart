// To parse this JSON data, do
//
//     final smoothie = smoothieFromMap(jsonString);

import 'dart:convert';

List<Smoothie> smoothieFromJson(String str) => List<Smoothie>.from(
    (json.decode(str) as List).map((x) => Smoothie.fromMap(x)));

List<Ingredient> ingredientsFromJson(String str) =>
    List<Ingredient>.from(json.decode(str).map((x) => Ingredient.fromMap(x)));

String smoothieToJson(List<Smoothie> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Smoothie {
  final String smoothieName;
  final int calories;
  final String description;
  final String imagePath;
  final bool isFavourite;
  final List<Ingredient> ingredients;

  Smoothie({
    required this.smoothieName,
    required this.calories,
    required this.description,
    required this.imagePath,
    required this.isFavourite,
    required this.ingredients,
  });

  factory Smoothie.fromMap(Map<String, dynamic> json) => Smoothie(
        smoothieName: json["smoothie_name"],
        calories: json["calories"],
        description: json["description"],
        imagePath: json["image_path"],
        isFavourite: json["isFavourite"],
        ingredients: List<Ingredient>.from(
            json["ingredients"].map((x) => Ingredient.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "smoothie_name": smoothieName,
        "calories": calories,
        "description": description,
        "image_path": imagePath,
        "isFavourite": isFavourite,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toMap())),
      };
}

class Ingredient {
  final String identifier;
  final LocalizedFoodItemNames localizedFoodItemNames;
  final String referenceMass;
  final String density;
  final String totalSaturatedFat;
  final String totalMonounsaturatedFat;
  final String totalPolyunsaturatedFat;
  final String cholesterol;
  final String sodium;
  final String totalCarbohydrates;
  final String dietaryFiber;
  final String sugar;
  final String protein;
  final String calcium;
  final String potassium;
  final String vitaminA;
  final String vitaminC;
  final String iron;
  final String? ingredientImage;

  Ingredient({
    required this.identifier,
    required this.localizedFoodItemNames,
    required this.referenceMass,
    required this.density,
    required this.totalSaturatedFat,
    required this.totalMonounsaturatedFat,
    required this.totalPolyunsaturatedFat,
    required this.cholesterol,
    required this.sodium,
    required this.totalCarbohydrates,
    required this.dietaryFiber,
    required this.sugar,
    required this.protein,
    required this.calcium,
    required this.potassium,
    required this.vitaminA,
    required this.vitaminC,
    required this.iron,
    this.ingredientImage,
  });

  factory Ingredient.fromMap(Map<String, dynamic> json) => Ingredient(
        identifier: json["identifier"],
        localizedFoodItemNames:
            LocalizedFoodItemNames.fromMap(json["localizedFoodItemNames"]),
        referenceMass: json["referenceMass"],
        density: json["density"],
        totalSaturatedFat: json["totalSaturatedFat"],
        totalMonounsaturatedFat: json["totalMonounsaturatedFat"],
        totalPolyunsaturatedFat: json["totalPolyunsaturatedFat"],
        cholesterol: json["cholesterol"],
        sodium: json["sodium"],
        totalCarbohydrates: json["totalCarbohydrates"],
        dietaryFiber: json["dietaryFiber"],
        sugar: json["sugar"],
        protein: json["protein"],
        calcium: json["calcium"],
        potassium: json["potassium"],
        vitaminA: json["vitaminA"],
        vitaminC: json["vitaminC"],
        iron: json["iron"],
        ingredientImage: json["ingredient_image"],
      );

  Map<String, dynamic> toMap() => {
        "identifier": identifier,
        "localizedFoodItemNames": localizedFoodItemNames.toMap(),
        "referenceMass": referenceMass,
        "density": density,
        "totalSaturatedFat": totalSaturatedFat,
        "totalMonounsaturatedFat": totalMonounsaturatedFat,
        "totalPolyunsaturatedFat": totalPolyunsaturatedFat,
        "cholesterol": cholesterol,
        "sodium": sodium,
        "totalCarbohydrates": totalCarbohydrates,
        "dietaryFiber": dietaryFiber,
        "sugar": sugar,
        "protein": protein,
        "calcium": calcium,
        "potassium": potassium,
        "vitaminA": vitaminA,
        "vitaminC": vitaminC,
        "iron": iron,
        "ingredient_image": ingredientImage,
      };
}

class LocalizedFoodItemNames {
  final String en;
  final String de;
  final String pt;

  LocalizedFoodItemNames({
    required this.en,
    required this.de,
    required this.pt,
  });

  factory LocalizedFoodItemNames.fromMap(Map<String, dynamic> json) =>
      LocalizedFoodItemNames(
        en: json["en"],
        de: json["de"],
        pt: json["pt"],
      );

  Map<String, dynamic> toMap() => {
        "en": en,
        "de": de,
        "pt": pt,
      };
}
