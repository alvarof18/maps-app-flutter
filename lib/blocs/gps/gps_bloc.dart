import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

// Aqui va toda la logica del evento

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServicesubcription;
  GpsBloc()
      : super(
            const GpsState(isGpsEnable: false, isGpsPermissionGranted: false)) {
    on<GpsAndPermissionEvent>((event, emit) => emit(state.copyWith(
        isGpsEnable: event.isGpsEnable,
        isGpsPermissionGranted: event.isGpsPermissionGranted)));

    _init();
  }

  Future<bool> _isPermissionGrated() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();

    switch (status) {
      case PermissionStatus.granted:
        add(GpsAndPermissionEvent(
            isGpsEnable: state.isGpsEnable, isGpsPermissionGranted: true));
        break;

      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(GpsAndPermissionEvent(
            isGpsEnable: state.isGpsEnable, isGpsPermissionGranted: false));
        openAppSettings();
    }
  }

  Future<void> _init() async {
    // final isEnable = await _checkGpsStatus();
    // final isGranted = await _isPermissionGrated();

    //Ejecutar varios Future simultaneamente
    final gpsInitStatus =
        await Future.wait([_checkGpsStatus(), _isPermissionGrated()]);
    add(GpsAndPermissionEvent(
        isGpsEnable: gpsInitStatus[0],
        isGpsPermissionGranted: gpsInitStatus[1]));
  }

  Future<bool> _checkGpsStatus() async {
    final isEnable = await Geolocator.isLocationServiceEnabled();
    gpsServicesubcription = Geolocator.getServiceStatusStream().listen((event) {
      final isEnable = (event.index == 1) ? true : false;
      add(GpsAndPermissionEvent(
          isGpsEnable: isEnable,
          isGpsPermissionGranted: state.isGpsPermissionGranted));
    });

    return isEnable;
  }

  @override
  Future<void> close() async {
    gpsServicesubcription?.cancel;
    return super.close();
  }
}
