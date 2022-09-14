import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/services/services.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  TrafficService trafficService;

  SearchBloc({required this.trafficService}) : super(const SearchState()) {
    on<OnActivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: true));
    });

    on<OnInActivateManualMarkerEvent>((event, emit) {
      emit(state.copyWith(displayManualMarker: false));
    });

    on<OnNewPlacesFoundEvent>(
        (event, emit) => emit(state.copyWith(places: event.places)));

    on<AddToHistoryEvent>((event, emit) =>
        emit(state.copyWith(history: [event.place, ...state.history])));
  }

  Future<RouteDestination> getCoorsStartToEnd(LatLng start, LatLng end) async {
    final trafficResponse = await trafficService.getCoorsStartToEnd(start, end);

    //Informacion del destino
    final endPlace = await trafficService.getInformationByCoors(end);

    final distance = trafficResponse.routes[0].distance;
    final duration = trafficResponse.routes[0].duration;
    final geometry = trafficResponse.routes[0].geometry;

    //Decode Geometry
    final points = decodePolyline(geometry, accuracyExponent: 6);
    final latLngList = points
        .map((coors) => LatLng(coors[0].toDouble(), coors[1].toDouble()))
        .toList();
    return RouteDestination(
        points: latLngList,
        duration: duration,
        distance: distance,
        endPlace: endPlace);
  }

  Future getPlacesByQuery(LatLng proximity, String query) async {
    final resp = await trafficService.getResultsByQuery(proximity, query);
    add(OnNewPlacesFoundEvent(resp));
  }
}
