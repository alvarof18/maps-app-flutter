import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';
import 'package:maps_app/models/models.dart';
import 'package:maps_app/themes/theme.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;
  GoogleMapController? _mapController;
  LatLng? mapCenter;
  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({required this.locationBloc}) : super(const MapState()) {
    on<OnMapInitialzedEvent>(_onInitMap);
    on<OnStartFollowingUserEvent>(_onStartFollowingUserEvent);
    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(isfollowUser: false)));

    on<UpdateUserPolylineEvent>(_updateUserPolylineEvent);
    on<OnToggleUserRoute>(
        (event, emit) => emit(state.copyWith(showMyroute: !state.showMyroute)));

    on<DisplayPolylinesEvent>((event, emit) => emit(
        state.copyWith(polylines: event.polylines, markers: event.markers)));

    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnowLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }

      if (!state.isfollowUser) return;
      if (locationState.lastKnowLocation == null) return;

      moveCamera(locationState.lastKnowLocation!);
    });
  }

  void _onInitMap(OnMapInitialzedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(uberMapTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void _onStartFollowingUserEvent(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isfollowUser: true));
    if (locationBloc.state.lastKnowLocation == null) return;
    moveCamera(locationBloc.state.lastKnowLocation!);
  }

  void _updateUserPolylineEvent(
      UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocation);
// Anadir rutas al mapa sin borrar la que ya existen
// Crea una copia del estado actual
    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  void drawRoutePolyline(RouteDestination destination) async {
    final myRoute = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.black,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: destination.points);

    // La distancia la devuelve en metros la convertimos en el kilometros
    double kms = destination.distance / 1000;
    kms = (kms * 100).floorToDouble();
    kms /= 100;

    double tripDuration = (destination.duration / 60).floorToDouble();

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    //Custom Markers
    // final startMarkerI = await getAssetsImageMarker();
    // final endMarkerI = await getNetworkImageMarker();

    //Custom Markers Widgets to Market
    final startMarkerI = await getStartCustomMarker(
        minutes: tripDuration.toInt(), destination: 'Mi ubicacion');
    final endMarkerI =
        await getEndCustomMarker(kms.toInt(), destination.endPlace.text);

    //Markers
    final startMarker = Marker(
        markerId: const MarkerId('start'),
        position: destination.points.first,
        icon: startMarkerI,
        anchor: const Offset(0.08, 0.4));
    // infoWindow: InfoWindow(
    // title: 'Inicio',
    // snippet:
    // 'Distancia:${kms.toString()}, Tiempo:${tripDuration.toString()}'));

    final endMarker = Marker(
        markerId: const MarkerId('end'),
        position: destination.points.last,
        icon: endMarkerI,
        anchor: const Offset(0.5, 0.4)
        // infoWindow: InfoWindow(
        //     title: destination.endPlace.text,
        //     snippet: destination.endPlace.placeName)
        );

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;

    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));

    // await Future.delayed(const Duration(milliseconds: 300));
    // _mapController?.showMarkerInfoWindow(const MarkerId('start'));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController!.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
