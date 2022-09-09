import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    show LatLng, Polyline;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? positionStream;

  LocationBloc() : super(const LocationState()) {
    on<onStartFollowingUser>((event, emit) {
      emit(state.copywith(followingUser: true));
    });

    on<onStopFollowingUser>((event, emit) {
      emit(state.copywith(followingUser: false));
    });

    on<onNewUserLocationEvent>((event, emit) {
      emit(state.copywith(
          lastKnowLocation: event.newLocation,
          myLocationHistory: [...state.myLocationHistory, event.newLocation]));
    });
  }

  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    add(onNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() {
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(onStartFollowingUser());
      add(onNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
    });
  }

  void stopFollingUser() {
    add(onStopFollowingUser());
    positionStream?.cancel();
  }

  @override
  Future<void> close() {
    stopFollingUser();
    return super.close();
  }
}
