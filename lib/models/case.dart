import 'package:courtlexmobile/models/client.dart';
import 'package:courtlexmobile/models/user.dart';

class ClientCase {
  int? id;
  String? case_status;
  String? case_title;
  String? client_name;
  String? case_subject;
  String? case_number;
  User? user;

  String? resplawyer_name;
  String? resplawyer_phone;
  String? resplawyer_email;
  String? resplawyer_lawfirmname;
  String? resplawyer_lawfirmcity;
  String? resplawyer_lawfirmaddress;

  String? court_name;
  String? court_city;
  String? nextcourt_date;
  String? notes;
  String? added_by;

  ClientCase({
    this.id,
    this.case_status,
    this.case_title,
    this.client_name,
    this.case_subject,
    this.user,
    this.case_number,
    this.resplawyer_name,
    this.resplawyer_phone,
    this.resplawyer_email,
    this.resplawyer_lawfirmname,
    this.resplawyer_lawfirmcity,
    this.resplawyer_lawfirmaddress,
    this.court_name,
    this.court_city,
    this.nextcourt_date,
    this.notes,
    this.added_by,
  });

  // map json to comment model
  factory ClientCase.fromJson(Map<String, dynamic> json) {
    return ClientCase(
      id: json['id'],
      case_status: json['case_status'],
      case_title: json['case_title'],
      client_name: json['client_name'],
      case_number: json['case_number'],
      case_subject: json['case_subject'],
      resplawyer_name: json['resplawyer_name'],
      resplawyer_phone: json['resplawyer_phone'],
      resplawyer_email: json['resplawyer_email'],
      resplawyer_lawfirmname: json['resplawyer_lawfirmname'],
      resplawyer_lawfirmcity: json['resplawyer_lawfirmcity'],
      resplawyer_lawfirmaddress: json['resplawyer_lawfirmaddress'],
      court_name: json['court_name'],
      court_city: json['court_city'],
      nextcourt_date: json['nextcourt_date'],
      notes: json['notes'],
      added_by: json['added_by'],
      user: User(
        id: json['user']['id'],
        name: json['user']['name'],
      ),
    );
  }
}
