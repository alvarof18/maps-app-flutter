import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/helpers/helpers.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.displayManualMarker) return const _ManualMarkerBody();
        return const SizedBox();
      },
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          const Positioned(top: 70, left: 20, child: _BtnBack()),
          Center(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: BounceInDown(
                from: 100,
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 50,
                ),
              ),
            ),
          ),

          //Boton de Confirmar

          Positioned(
              bottom: 70,
              left: 40,
              child: FadeInUp(
                duration: const Duration(milliseconds: 300),
                child: MaterialButton(
                    height: 50,
                    minWidth: size.width - 120,
                    color: Colors.black,
                    elevation: 0,
                    onPressed: () async {
                      //TODO Loading
                      final start = locationBloc.state.lastKnowLocation;
                      if (start == null) return;

                      final end = mapBloc.mapCenter;
                      if (end == null) return;

                      showLoadingMessage(context);

                      final destination =
                          await searchBloc.getCoorsStartToEnd(start, end);
                      mapBloc.drawRoutePolyline(destination);
                      searchBloc.add(OnInActivateManualMarkerEvent());
                      Navigator.pop(context);
                    },
                    shape: const StadiumBorder(),
                    child: const Text(
                      'Confirmar Destino',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    )),
              ))
        ],
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
            onPressed: () {
              BlocProvider.of<SearchBloc>(context)
                  .add(OnInActivateManualMarkerEvent());
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
    );
  }
}
