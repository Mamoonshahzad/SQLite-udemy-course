class Dish {
  String name;
  String description;
  double price;

  Dish(this.name, this.description, this.price);

  Dish.fromMap(Map<String, dynamic> map)
      : name = map['name'] ?? '',
        description = map['description'] ?? '',
        price = map['price'] ?? 0.0;
}
