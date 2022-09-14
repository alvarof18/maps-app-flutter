part of 'map_bloc.dart';

class MapState extends Equatable {
  final bool isMapInitialized;
  final bool isfollowUser;
  final bool showMyroute;

  //Polylines
  final Map<String, Polyline> polylines;

  //Markers
  final Map<String, Marker> markers;

  const MapState(
      {this.showMyroute = true,
      this.isMapInitialized = false,
      this.isfollowUser = true,
      Map<String, Polyline>? polylines,
      Map<String, Marker>? markers})
      : polylines = polylines ?? const {},
        markers = markers ?? const {};

  MapState copyWith(
          {bool? isMapInitialized,
          bool? isfollowUser,
          Map<String, Polyline>? polylines,
          Map<String, Marker>? markers,
          bool? showMyroute}) =>
      MapState(
          isMapInitialized: isMapInitialized ?? this.isMapInitialized,
          isfollowUser: isfollowUser ?? this.isfollowUser,
          polylines: polylines ?? this.polylines,
          showMyroute: showMyroute ?? this.showMyroute,
          markers: markers ?? this.markers);

  @override
  List<Object> get props =>
      [isMapInitialized, isfollowUser, polylines, showMyroute, markers];
}
