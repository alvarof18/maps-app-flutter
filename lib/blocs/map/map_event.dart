part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitialzedEvent extends MapEvent {
  final GoogleMapController controller;
  const OnMapInitialzedEvent(this.controller);
}

class OnStartFollowingUserEvent extends MapEvent {}

class OnStopFollowingUserEvent extends MapEvent {}

class UpdateUserPolylineEvent extends MapEvent {
  final List<LatLng> userLocation;
  const UpdateUserPolylineEvent(this.userLocation);
}

class OnToggleUserRoute extends MapEvent {}

class DisplayPolylinesEvent extends MapEvent {
  final Map<String, Polyline> polylines;

  DisplayPolylinesEvent(this.polylines);
}
