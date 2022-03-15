import 'dart:convert';
import 'package:courtlexmobile/models/client.dart';
import 'package:http/http.dart' as http;
import 'package:courtlexmobile/models/api_response.dart';
import 'package:courtlexmobile/services/user_service.dart';

import '../constants.dart';

Future<ApiResponse> saveClient(String name, String address, String city,
    String phone, String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(saveClientUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'name': name,
      'address': address,
      'city': city,
      'phone': phone,
      'email': email,
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

// client list
Future<ApiResponse> getClients() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(clientsListUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['clients']
            .map((p) => Client.fromJson(p))
            .toList();
        // we get list of clients, so we need to map each item to client model
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



Future<List<Client>> getClientsNames() async {
  ApiResponse apiResponse = ApiResponse();
  List<Client> clientsList = [];
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(clientListNamesUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        var jsonList = jsonDecode(response.body)['clients'];
        for (var client in jsonList) {
          clientsList.add(Client.fromJsonNames(client));
        }
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
  return clientsList;

}

// Edit post
Future<ApiResponse> editClient(int clientId, String name, String address,
    String city, String phone, String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.put(Uri.parse('$saveClientUrl/$clientId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'name': name,
      'address': address,
      'city': city,
      'phone': phone,
      'email': email,
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

// Delete post
Future<ApiResponse> deleteClient(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$saveClientUrl/$postId'),
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
