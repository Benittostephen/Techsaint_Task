class Fruit {
  final int id;
  final String name;
  final String family;
  final String order;
  final String genus;
  final Nutritions nutritions;

  Fruit({
    required this.id,
    required this.name,
    required this.family,
    required this.order,
    required this.genus,
    required this.nutritions,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      id: json['id'] as int,
      name: json['name'] as String,
      family: json['family'] as String,
      order: json['order'] as String,
      genus: json['genus'] as String,
      nutritions: Nutritions.fromJson(json['nutritions'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'family': family,
      'order': order,
      'genus': genus,
      'nutritions': nutritions.toJson(),
    };
  }
}

class Nutritions {
  final double calories;
  final double fat;
  final double sugar;
  final double carbohydrates;
  final double protein;

  Nutritions({
    required this.calories,
    required this.fat,
    required this.sugar,
    required this.carbohydrates,
    required this.protein,
  });

  factory Nutritions.fromJson(Map<String, dynamic> json) {
    return Nutritions(
      calories: (json['calories'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      carbohydrates: (json['carbohydrates'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'fat': fat,
      'sugar': sugar,
      'carbohydrates': carbohydrates,
      'protein': protein,
    };
  }
}