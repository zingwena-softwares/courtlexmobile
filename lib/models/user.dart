import 'dart:core';


class User{
  int ? id ;
  String? name;
  String? surname;
  String? email;
  String? phone;
  String? address;
  String? lawfirm;
  String? token;


  User({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.phone,
    this.address,
    this.lawfirm,
    this.token

  });
  factory User.fromJson(Map<String ,dynamic> json){
    return User(
      id: json['user']['id'],
      name: json['user']['name'],
      surname: json['user']['surname'],
      email: json['user']['email'],
      phone: json['user']['phone'],
      address: json['user']['address'],
      lawfirm: json['user']['law_firm'],
      token: json['token'],

    );
  }
}