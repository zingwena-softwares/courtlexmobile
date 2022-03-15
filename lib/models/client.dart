import 'dart:core';
import 'package:courtlexmobile/models/user.dart';

class Client {
  int? id;
  String? name;
  String? address;
  String? city;
  String? phone;
  String? email;
  User? user;

  Client(
      {this.id,
       this.name,
       this.address,
       this.city,
       this.phone,
       this.email,
       this.user});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        city: json['city'],
        phone: json['phone'],
        email: json['email'],
        user: User(
          id: json['user']['id'],
          name: json['user']['name'],
          phone: json['user']['phone'],
          email: json['user']['email'],
        ));
  }
  factory Client.fromJsonNames(Map<String, dynamic> json) {
    return Client(
        id: json['id'],
        name: json['name']
    );
  }
 factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
