import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final apikey =
      'pk.eyJ1IjoiYWx2YXJvZjE4IiwiYSI6ImNsN3hqbGdmNzBpcm0zbm9ncWoxaGN2MTMifQ.F_iT1Q9a9cjrcfXl440EyA';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters
        .addAll({'access_token': apikey, 'language': 'es', 'limit': 7});
    super.onRequest(options, handler);
  }
}
