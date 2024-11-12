import 'package:petcare_mobile/models/service_model.dart';

class EmployeesModel {
  String name;
  String image;
  List<String> service;
  String address;

  EmployeesModel({
    required this.name,
    required this.image,
    required this.service,
    required this.address,
  });
}

var employees = [
  EmployeesModel(
    name: "Dr. Andrew",
    image:"Profile1.png",
    service: Service.all(),
    address: "123 Main Street, Anytown, USA",
  ),
  EmployeesModel(
    name: "Dr. Julia",
    image:"Profile2.png",
    service: Service.all(),
    address: "123 Main Street, Anytown, USA",
  ),
];

