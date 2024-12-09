import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trashtrack_user/data/sources/fleet/get_distance_source.dart';
import 'package:trashtrack_user/data/sources/fleet/get_fleet_source.dart';
import 'package:trashtrack_user/data/sources/fleet/get_status_source.dart';
import 'package:trashtrack_user/models/fleet/fleet.dart';

typedef SESFT = Stream<Either<String, Fleet>>;
typedef FESFT = Future<Either<String, Fleet>>;
typedef FESIT = Future<Either<String, int>>;

class FleetRepository {
  GetFleetSource getFleetSource;
  GetStatusSource getStatusSource;
  GetDistanceSource getDistanceSource;

  FleetRepository({
    required this.getFleetSource,
    required this.getStatusSource,
    required this.getDistanceSource,
  });

  SESFT getFleet(String id) {
    return getFleetSource.getFleet(id);
  }

  FESFT getStatus(String id) async {
    return await getStatusSource.getStatus(id);
  }

  FESIT getDistance(LatLng userLoc, LatLng driverLoc) async {
    return await getDistanceSource.getDistance(userLoc, driverLoc);
  }

  Future<bool> isDriverActive(String fleetId) async {
    final fleet = await getStatus(fleetId);
    return fleet.fold(
      (failure) => false, // Handle error, assume driver is inactive
      (fleet) => fleet.status.toLowerCase() == 'active',
    );
  }
}
