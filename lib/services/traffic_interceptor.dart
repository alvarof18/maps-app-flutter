import 'package:dio/dio.dart';

class TrafficInterceptor extends Interceptor {
  final apikey =
      'pk.eyJ1IjoiYWx2YXJvZjE4IiwiYSI6ImNsN3hqbGdmNzBpcm0zbm9ncWoxaGN2MTMifQ.F_iT1Q9a9cjrcfXl440EyA';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': apikey
    });

    super.onRequest(options, handler);
  }
}
