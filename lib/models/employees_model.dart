import 'package:petcare_mobile/models/service_model.dart';

class EmployeesModel {
  String name;
  String image;
  List<String> service;
  String phone;
  String address;

  EmployeesModel({
    required this.name,
    required this.image,
    required this.service,
    required this.phone,
    required this.address,
  });
}

var employees = [
  EmployeesModel(
    name: "Dr. Andrew",
    image: "Profile1.png",
    service: ["PetSitter"],
    phone: "123-456-7890",
    address: "123 Main Street, Anytown, USA",
  ),
  EmployeesModel(
    name: "Dr. Julia",
    image: "Profile2.png",
    service: ["DayCare"],
    phone: "123-456-7890",
    address: "123 Main Street, Anytown, USA",
  ),
];
