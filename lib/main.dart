import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';

import 'package:maps_app/screens/screens.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => GpsBloc()),
    BlocProvider(create: (context) => LocationBloc()),
    // El context ya tiene tanto el GpsBloc como el LocationBloc porque los a;ade de forma secuencial
    BlocProvider(
        create: (context) =>
            MapBloc(locationBloc: BlocProvider.of<LocationBloc>(context)))
  ], child: MapsApp()));
}

class MapsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Maps App',
        debugShowCheckedModeBanner: false,
        home: LoadingScreen());
  }
}
