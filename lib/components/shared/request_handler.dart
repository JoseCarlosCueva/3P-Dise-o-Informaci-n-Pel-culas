import 'dart:convert';
//import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_/components/shared/request_model.dart';
import 'package:peliculas_/components/utils/constantes.dart';

class RequestHandler {
  Future<RequestModel> requestGet({required String host, required String endpoint}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    try {
      if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(host, endpoint,
        {'language':'es-ES'}
      );

        final response = await http.get(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        return RequestModel.fromJson(json.decode(response.body));
      }
    } catch (error) {
      return RequestModel.fromJson({
        'success': false,
        'message': error.toString(),
        'data': null,
        'action': 'server_error'
      });
    }

    return RequestModel.fromJson({});
  }


  Future<RequestModel> requestPost(
      {required RequestModel endpoint, required Map<String, dynamic> body}) async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    try {
      if (connectivityResult != ConnectivityResult.none) {
        final url = Uri.https(host);

        final response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(body));

        return RequestModel.fromJson(json.decode(response.body));
      }
    } catch (error) {
      return RequestModel.fromJson({
        'success': false,
        'message': error.toString(),
        'data': null,
        'action': 'server_error-post'
      });
    }

    return RequestModel.fromJson({});
  }

 }
