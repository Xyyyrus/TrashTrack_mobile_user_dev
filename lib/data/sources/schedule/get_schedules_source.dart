// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:trashtrack_user/converters/timestamp_converter.dart';
// import 'package:trashtrack_user/data/repositories/schedule_repository.dart';
// import 'package:trashtrack_user/extensions/datetime_formatter.dart';
// import 'package:trashtrack_user/models/fleet/fleet.dart';
// import 'package:trashtrack_user/models/route/route.dart';
// import 'package:trashtrack_user/models/schedule/schedule.dart';

// class GetSchedulesSource {
//   FESLT getSchedules(String routeId) async {
//     try {
//       final firebaseFire = FirebaseFirestore.instance;
//       final schedsCol = firebaseFire.collection('schedules');
//       final routesCol = firebaseFire.collection('routes');
//       final fleetsCol = firebaseFire.collection('fleets');

//       DateTime now = DateTime.now();
//       String day = now.toFormattedDay();

//       final schedsRoute = schedsCol.where('routeId', isEqualTo: routeId);
//       final schedsDay = schedsRoute.where('day', isEqualTo: day);
//       final schedsSnapshot = await schedsDay.get();

//       final List<Schedule> schedsObjects = [];

//       for (var schedDoc in schedsSnapshot.docs) {
//         final schedMap = schedDoc.data();
//         var schedObject = Schedule.fromJson({
//           ...schedMap,
//           'id': schedDoc.id,
//           'time': const TimestampConverter().toJson(schedMap['time']),
//         });

//         final routeRef = routesCol.doc(schedObject.routeId);
//         final routeSnapshot = await routeRef.get();
//         final routeMap = routeSnapshot.data() as Map<String, dynamic>;
//         final routeObj = Route.fromJson({
//           ...routeMap,
//           'id': routeSnapshot.id,
//         });

//         schedObject = schedObject.copyWith(
//           routeName: routeObj.name,
//           routePath: routeObj.path,
//           collectionsPath: routeObj.collections,
//         );

//         final fleetRef = fleetsCol.doc(schedObject.fleetId);
//         final fleetSnapshot = await fleetRef.get();
//         final fleetMap = fleetSnapshot.data() as Map<String, dynamic>;
//         final fleetObj = Fleet.fromJson({
//           ...fleetMap,
//           'id': fleetSnapshot.id,
//         });

//         schedObject = schedObject.copyWith(fleetStatus: fleetObj.status);

//         if (schedObject.fleetStatus == 'Active') {
//           schedsObjects.add(schedObject);
//         }
//       }

//       return Right(schedsObjects);
//     } catch (e) {
//       String error = 'Error getting schedules: $e';

//       return Left(error);
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:trashtrack_user/converters/timestamp_converter.dart';
import 'package:trashtrack_user/data/repositories/schedule_repository.dart';
import 'package:trashtrack_user/models/fleet/fleet.dart';
import 'package:trashtrack_user/models/route/route.dart';
import 'package:trashtrack_user/models/schedule/schedule.dart';

class GetSchedulesSource {
  FESLT getSchedules(String routeId) async {
    try {
      final firebaseFire = FirebaseFirestore.instance;
      final schedsCol = firebaseFire.collection('schedules');
      final routesCol = firebaseFire.collection('routes');
      final fleetsCol = firebaseFire.collection('fleets');

      // Get all schedules for the specified route, regardless of the day
      final schedsRoute = schedsCol.where('routeId', isEqualTo: routeId);
      final schedsSnapshot = await schedsRoute.get();

      final List<Schedule> schedsObjects = [];

      for (var schedDoc in schedsSnapshot.docs) {
        final schedMap = schedDoc.data();
        var schedObject = Schedule.fromJson({
          ...schedMap,
          'id': schedDoc.id,
          'time': const TimestampConverter().toJson(schedMap['time']),
        });

        final routeRef = routesCol.doc(schedObject.routeId);
        final routeSnapshot = await routeRef.get();
        final routeMap = routeSnapshot.data() as Map<String, dynamic>;
        final routeObj = Route.fromJson({
          ...routeMap,
          'id': routeSnapshot.id,
        });

        schedObject = schedObject.copyWith(
          routeName: routeObj.name,
          routePath: routeObj.path,
          collectionsPath: routeObj.collections,
        );

        // Fetch fleet data without filtering by status
        final fleetRef = fleetsCol.doc(schedObject.fleetId);
        final fleetSnapshot = await fleetRef.get();
        final fleetMap = fleetSnapshot.data() as Map<String, dynamic>;
        final fleetObj = Fleet.fromJson({
          ...fleetMap,
          'id': fleetSnapshot.id,
        });

        // Include the fleet status but do not filter schedules based on it
        schedObject = schedObject.copyWith(fleetStatus: fleetObj.status);

        // Always add the schedule object to the list, regardless of fleet status
        schedsObjects.add(schedObject);
      }

      return Right(schedsObjects);
    } catch (e) {
      String error = 'Error getting schedules: $e';
      return Left(error);
    }
  }
}
