import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';

class TrafficService {
  final Dio _dioTraffic;
  final Dio _dioPlaces;

  final String urlBase = 'https://api.mapbox.com/directions/v5/mapbox';
  final String placeBaseUrl =
      'https://api.mapbox.com/geocoding/v5/mapbox.places';

  TrafficService()
      : _dioTraffic = Dio()..interceptors.add(TrafficInterceptor()),
        _dioPlaces = Dio()..interceptors.add(PlacesInterceptor());

  Future<TrafficResponse> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final coorsString =
        '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';

    final url = '$urlBase/driving/$coorsString';
    final resp = await _dioTraffic.get(url);
    final data = TrafficResponse.fromMap(resp.data);
    return data;
  }

  Future<List<Feature>> getResultsByQuery(
      LatLng proximity, String query) async {
    if (query.isEmpty) return [];

    final url = '$placeBaseUrl/$query.json';
    final resp = await _dioPlaces.get(url, queryParameters: {
      'proximity': '${proximity.longitude},${proximity.latitude}',
      'limit': 7
    });
    final placesResponse = PlacesResponse.fromMap(resp.data);
    return placesResponse.features;
  }

  Future<Feature> getInformationByCoors(LatLng coors) async {
    final url = '$placeBaseUrl/${coors.longitude},${coors.latitude}.json';
    final resp = await _dioPlaces.get(url, queryParameters: {'limit': 1});
    final responsePlaces = PlacesResponse.fromMap(resp.data);

    return responsePlaces.features[0];
  }
}
