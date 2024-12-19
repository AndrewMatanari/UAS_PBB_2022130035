class EmployeeModel {
  final int id;
  final String name;
  final String phone;
  final String photo;

  EmployeeModel({required this.id, required this.name, required this.phone, required this.photo});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      photo: json['photo'], 
    );
  }
}
