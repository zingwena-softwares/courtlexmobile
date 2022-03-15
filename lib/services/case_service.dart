import 'dart:convert';

import 'package:courtlexmobile/constants.dart';
import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/case.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getCases() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(caseListUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        // map each comments to comment model
        apiResponse.data = jsonDecode(response.body)['cases']
            .map((p) => ClientCase.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Create a Case
Future<ApiResponse> createCase(
  String? case_status,
  String? case_title,
  String? client_name,
  String? case_subject,
  String? case_number,
  String? resplawyer_name,
  String? resplawyer_phone,
  String? resplawyer_email,
  String? resplawyer_lawfirmname,
  String? resplawyer_lawfirmcity,
  String? resplawyer_lawfirmaddress,
  String? court_name,
  String? court_city,
  String? nextcourt_date,
  String? notes,
  String? added_by,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.post(Uri.parse('$saveCaseUrl'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'case_status': case_status,
      'case_title': case_title,
      'client_name': client_name,
      'case_subject': case_subject,
      'case_number': case_number,
      'resplawyer_name': resplawyer_name,
      'resplawyer_phone': resplawyer_phone,
      'resplawyer_email': resplawyer_email,
      'resplawyer_lawfirmname': resplawyer_lawfirmname,
      'resplawyer_lawfirmcity': resplawyer_lawfirmcity,
      'resplawyer_lawfirmaddress': resplawyer_lawfirmaddress,
      'court_name': court_name,
      'court_city': court_city,
      'nextcourt_date': nextcourt_date,
      'notes': notes,
      'added_by': added_by,
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Delete a case
Future<ApiResponse> deleteCase(int caseId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$editCaseUrl/$caseId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}


Future<void> openCase(int caseId) async{
  String token = await getToken();
  final response = await http.put(Uri.parse('$openCaseUrl/$caseId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },);
}

Future<void> closeCase(int caseId) async{
  String token = await getToken();
  final response = await http.put(Uri.parse('$closeCaseUrl/$caseId'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },);
}
// Edit comment
Future<ApiResponse> editCase(
    int caseId,
    String? case_status,
    String? case_title,
    String? client_name,
    String? case_subject,
    String? case_number,
    String? resplawyer_name,
    String? resplawyer_phone,
    String? resplawyer_email,
    String? resplawyer_lawfirmname,
    String? resplawyer_lawfirmcity,
    String? resplawyer_lawfirmaddress,
    String? court_name,
    String? court_city,
    String? nextcourt_date,
    String? notes,
    String? added_by,
    ) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$editCaseUrl/$caseId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'case_status': case_status,
          'case_title': case_title,
          'client_name': client_name,
          'case_subject': case_subject,
          'case_number': case_number,
          'resplawyer_name': resplawyer_name,
          'resplawyer_phone': resplawyer_phone,
          'resplawyer_email': resplawyer_email,
          'resplawyer_lawfirmname': resplawyer_lawfirmname,
          'resplawyer_lawfirmcity': resplawyer_lawfirmcity,
          'resplawyer_lawfirmaddress': resplawyer_lawfirmaddress,
          'court_name': court_name,
          'court_city': court_city,
          'nextcourt_date': nextcourt_date,
          'notes': notes,
          'added_by': added_by,
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
