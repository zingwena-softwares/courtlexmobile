
import 'dart:convert';
import 'package:courtlexmobile/constants.dart';
import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/models/note.dart';
import 'package:courtlexmobile/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> saveNote(String type, String type_subject, String title, String date, String detail) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(saveNoteUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'type': type,
      'type_subject': type_subject,
      'title': title,
      'date': date,
      'detail': detail,
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingwentwrong;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> getAllNotes() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(getAllNotesUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['notes']
            .map((p) => Note.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;

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
Future<ApiResponse> updateNote(int noteId,String type, String type_subject, String title, String date, String detail) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
    await http.put(Uri.parse('$updateNoteUrl/$noteId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'type': type,
      'type_subject': type_subject,
      'title': title,
      'date': date,
      'detail': detail,
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
Future<ApiResponse> deleteNote(int noteId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$deleteNoteUrl/$noteId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
//print(response.body);
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