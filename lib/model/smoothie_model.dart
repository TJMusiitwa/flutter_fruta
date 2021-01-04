// To parse this JSON data, do
//
//     final smoothie = smoothieFromJson(jsonString);

import 'dart:convert';

List<Smoothie> smoothieFromJson(String str) =>
    List<Smoothie>.from(json.decode(str).map((x) => Smoothie.fromJson(x)));

List<Ingredient> ingredientsFromJson(String str) =>
    List<Ingredient>.from(json.decode(str).map((x) => Ingredient.fromJson(x)));

String smoothieToJson(List<Smoothie> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Smoothie {
  Smoothie({
    this.smoothieName,
    this.calories,
    this.description,
    this.imagePath,
    this.isFavourite,
    this.ingredients,
  });

  String smoothieName;
  int calories;
  String description;
  String imagePath;
  bool isFavourite;
  List<Ingredient> ingredients;

  factory Smoothie.fromJson(Map<String, dynamic> json) => Smoothie(
        smoothieName: json["smoothie_name"],
        calories: json["calories"],
        description: json["description"],
        imagePath: json["image_path"],
        isFavourite: json["isFavourite"],
        ingredients: List<Ingredient>.from(
            json["ingredients"].map((x) => Ingredient.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "smoothie_name": smoothieName,
        "calories": calories,
        "description": description,
        "image_path": imagePath,
        "isFavourite": isFavourite,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
      };
}

class Ingredient {
  Ingredient({
    this.identifier,
    this.localizedFoodItemNames,
    this.referenceMass,
    this.density,
    this.totalSaturatedFat,
    this.totalMonounsaturatedFat,
    this.totalPolyunsaturatedFat,
    this.cholesterol,
    this.sodium,
    this.totalCarbohydrates,
    this.dietaryFiber,
    this.sugar,
    this.protein,
    this.calcium,
    this.potassium,
    this.vitaminA,
    this.vitaminC,
    this.iron,
  });

  String identifier;
  LocalizedFoodItemNames localizedFoodItemNames;
  String referenceMass;
  String density;
  String totalSaturatedFat;
  String totalMonounsaturatedFat;
  String totalPolyunsaturatedFat;
  String cholesterol;
  String sodium;
  String totalCarbohydrates;
  String dietaryFiber;
  String sugar;
  String protein;
  String calcium;
  String potassium;
  String vitaminA;
  String vitaminC;
  String iron;

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        identifier: json["identifier"],
        localizedFoodItemNames:
            LocalizedFoodItemNames.fromJson(json["localizedFoodItemNames"]),
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
      );

  Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "localizedFoodItemNames": localizedFoodItemNames.toJson(),
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
      };
}

class LocalizedFoodItemNames {
  LocalizedFoodItemNames({
    this.en,
    this.de,
    this.pt,
  });

  String en;
  String de;
  String pt;

  factory LocalizedFoodItemNames.fromJson(Map<String, dynamic> json) =>
      LocalizedFoodItemNames(
        en: json["en"],
        de: json["de"],
        pt: json["pt"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "de": de,
        "pt": pt,
      };
}
