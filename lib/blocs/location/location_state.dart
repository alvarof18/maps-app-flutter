part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;

  final LatLng? lastKnowLocation;
  final List<LatLng> myLocationHistory;

  const LocationState(
      {this.followingUser = false, myLocationHistory, this.lastKnowLocation})
      : myLocationHistory = myLocationHistory ?? const [];

  LocationState copywith(
          {bool? followingUser,
          LatLng? lastKnowLocation,
          List<LatLng>? myLocationHistory}) =>
      LocationState(
          followingUser: followingUser ?? this.followingUser,
          lastKnowLocation: lastKnowLocation ?? this.lastKnowLocation,
          myLocationHistory: myLocationHistory ?? this.myLocationHistory);

  @override
  List<Object?> get props =>
      [followingUser, myLocationHistory, lastKnowLocation];
}
