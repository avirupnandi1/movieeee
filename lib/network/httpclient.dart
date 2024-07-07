import 'package:dio/dio.dart';

class HttpClient {
  final Dio _dio = Dio();

  HttpClient() {
    _dio.options.baseUrl = "https://api.themoviedb.org/3/";
    _dio.options.headers["Authorization"] =
        "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YTg3ZTY4MDMyODIwMTIzZmQ0Yzg0YjQzNDhjYjc3ZCIsInN1YiI6IjY2Mjg5NDExOTFmMGVhMDE0YjAwOWU1ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6zIM73Giwg5M4wP6MX8KDCpee7IMnpnLTZUyMpETb08";
    _dio.options.headers["Accept"] = "application/json";
  }

  Dio get sendRequest => _dio;
}