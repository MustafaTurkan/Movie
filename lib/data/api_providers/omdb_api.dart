import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:Movie/data/data.dart';
import 'package:Movie/infrastructure/infrastructure.dart';

class OMDbApi {
  Dio dio;
  void initialize() {
    dio ??= Dio();
    dio.options.responseType = ResponseType.json;
    dio.options.connectTimeout = 30 * 1000;
    dio.options.receiveTimeout = 30 * 1000;

    var transformer = dio.transformer as DefaultTransformer;
    transformer.jsonDecodeCallback = jsonDecodeAsync;
        if (!kReleaseMode) {
      dio.interceptors.add(LogInterceptor());
    }

  }

  Future<List<Movie>> getMovies(String filter) async {
    try {
      final result = await dio.get<String>(OMDbConnection.url,
          queryParameters: <String, dynamic>{'apikey': OMDbConnection.key, 's': filter});

      final value = await jsonDecodeAsync(result.data) as Map<String, dynamic>;
      if (!value.getValue<bool>('Response')) {
        throw value.getValue<String>('Error');
      }
      var list = value['Search'];
      return list.map<Movie>((dynamic model) => Movie.fromJson(model as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  static dynamic _jsonDecodeCallback(String data) => json.decode(data);
  static Future<dynamic> jsonDecodeAsync(String data) {
    return compute<String, dynamic>(_jsonDecodeCallback, data);
  }
}
