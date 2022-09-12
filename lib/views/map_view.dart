import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/blocs/blocs.dart';

class MapView extends StatelessWidget {
  const MapView(
      {Key? key, required this.initialLocation, required this.polylines})
      : super(key: key);

  final LatLng initialLocation;
  final Set<Polyline> polylines;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mapBloc = BlocProvider.of<MapBloc>(context);

    final CameraPosition initialCameraPosition =
        CameraPosition(target: initialLocation, zoom: 15);
    return SizedBox(
        width: size.width,
        height: size.height,
        child: Listener(
          onPointerMove: (pointerMoveEvent) =>
              mapBloc.add(OnStopFollowingUserEvent()),
          child: GoogleMap(
              compassEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              polylines: polylines,
              onCameraMove: (position) => mapBloc.mapCenter = position.target,
              onMapCreated: (controller) =>
                  mapBloc.add(OnMapInitialzedEvent(controller)),
              initialCameraPosition: initialCameraPosition),
        ));
  }
}
