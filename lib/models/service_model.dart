class ServiceModel {
  final int id;
  final String name;
  final String description;
  final String price;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  // Factory constructor untuk membuat objek dari JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }
}
