import 'dart:math';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trashtrack_user/data/repositories/fleet_repository.dart';
import 'package:trashtrack_user/helpers/notification_message_helper.dart';
import 'package:trashtrack_user/models/fleet/fleet.dart';
import 'package:trashtrack_user/models/schedule/schedule.dart';
import 'package:trashtrack_user/widgets/custom_app_bar.dart';

typedef GFSBT = StreamBuilder<dartz.Either<String, Fleet>>;
typedef ESFST = dartz.Either<String, Fleet>;

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.schedule});
  final Schedule schedule;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _uniqueId = 0;
  final List<LatLng> _allCoordinates = [];
  final List<LatLng> _allCollections = [];
  BitmapDescriptor _truckIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _goIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _userIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _stopIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _binIcon = BitmapDescriptor.defaultMarker;
  LocationData _currentLocation = LocationData.fromMap({
    'latitude': 0.0,
    'longitude': 0.0,
  });

  void _generateId() {
    const min = 0;
    const max = 1000000;
    final random = Random.secure();
    final id = min + random.nextInt(max - min);

    setState(() {
      _uniqueId = id;
    });
  }

  Future<void> _getLocation() async {
    final Location locationService = Location();

    bool serviceEnabled = await locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.requestService();

      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationService.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await locationService.getLocation();
    if (mounted) {
      setState(() {});
    }
  }

  void _setCoordinates() {
    for (var l in widget.schedule.routePath ?? []) {
      LatLng latLng = LatLng(l['lat'], l['lng']);

      _allCoordinates.add(latLng);
    }
  }

  void _setCollections() {
    for (var l in widget.schedule.collectionsPath ?? []) {
      LatLng latLng = LatLng(l['lat'] ?? 0, l['lng'] ?? 0);

      _allCollections.add(latLng);
    }
  }

  Future<void> _loadTruckIcon() async {
    _truckIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'lib/assets/images/truck.png',
    );
  }

  Future<void> _loadgoIcon() async {
    _goIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'lib/assets/images/green-go.png',
    );
  }

  Future<void> _startLocationUpdates() async {
    final Location locationService = Location();

    bool serviceEnabled = await locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.requestService();

      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationService.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Start listening to location updates
    locationService.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData; // Update current location
      });
    });
  }

  Future<void> _loadstopIcon() async {
    _stopIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'lib/assets/images/red-stop.png',
    );
  }

  Future<void> _loadUserIcon() async {
    _userIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Reduced size
      'lib/assets/images/user.png', // Path to user icon
    );
  }

  Future<void> _loadbinIcon() async {
    _binIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Reduced size
      'lib/assets/images/trash-bin.png', // Path to user icon
    );
  }

  Future<void> _checkLocation(
    FleetRepository fleetRepository,
    LatLng driverLoc,
  ) async {
    final userLoc = LatLng(
      _currentLocation.latitude ?? 0,
      _currentLocation.longitude ?? 0,
    );

    final result = await fleetRepository.getDistance(userLoc, driverLoc);

    result.fold((String l) {
      debugPrint(l);
    }, (int r) {
      if (r < 500) {
        NotificationMessageHelper.showMessageNotification(
          _uniqueId.toString(),
          'Location Notification',
          'The truck driver is near!',
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
    _generateId();
    _getLocation();
    _setCoordinates();
    _setCollections();
    _loadTruckIcon();
    _loadgoIcon();
    _loadstopIcon();
    _loadUserIcon();
    _loadbinIcon();

    // Check for valid schedule data
    if (widget.schedule.routePath == null ||
        widget.schedule.collectionsPath == null) {
      // Show an error dialog if route or collection paths are null
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(context, 'Invalid schedule data received.');
      });
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fleetRepository = context.read<FleetRepository>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Active Collector',
        showLegendIcon: true,
      ),
      body: Center(
        child: buildGetFleetSB(fleetRepository),
      ),
    );
  }

  GFSBT buildGetFleetSB(FleetRepository fleetRepository) {
    return GFSBT(
      stream: fleetRepository.getFleet(widget.schedule.fleetId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;

          Widget widget = Container();

          if (result != null) {
            result.fold((String l) {
              widget = const Text('Error getting the fleet');
            }, (Fleet r) {
              final location = r.location;

              // Validate driver location before using it
              final double? driverLat = location['latitude'];
              final double? driverLng = location['longitude'];

              if (driverLat == null || driverLng == null) {
                // Handle the case where driver location is invalid
                widget = Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                        size: 48.0,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Driver Location Unavailable',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'The driver location is currently unavailable. Please check back later.',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else {
                final driverLoc = LatLng(driverLat, driverLng);

                final userLat = _currentLocation.latitude;
                final userLng = _currentLocation.longitude;

                if (userLat != 0 && userLng != 0) {
                  _checkLocation(fleetRepository, driverLoc);
                }

                final Set<Marker> markers = {
                  Marker(
                    markerId: const MarkerId('user_marker'),
                    icon: _userIcon,
                    position: LatLng(
                      _currentLocation.latitude ?? 0,
                      _currentLocation.longitude ?? 0,
                    ),
                    infoWindow: const InfoWindow(
                      title: 'User Point',
                      snippet: 'This is the user in the map',
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('driver_marker'),
                    position: driverLoc,
                    icon: _truckIcon,
                    infoWindow: const InfoWindow(
                      title: 'Driver Point',
                      snippet: 'This is the driver in the route',
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('start_marker'),
                    position: _allCoordinates.first,
                    icon: _goIcon,
                    infoWindow: const InfoWindow(
                      title: 'Start Point',
                      snippet: 'This is the start of the route',
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('end_marker'),
                    position: _allCoordinates.last,
                    icon: _stopIcon,
                    infoWindow: const InfoWindow(
                      title: 'End Point',
                      snippet: 'This is the end of the route',
                    ),
                  ),
                };

                for (int i = 0; i < _allCollections.length; i++) {
                  final collectionLoc = _allCollections[i];
                  final collectionLatLng = LatLng(
                    collectionLoc.latitude,
                    collectionLoc.longitude,
                  );
                  markers.add(
                    Marker(
                      markerId: MarkerId('collection_marker_$i'),
                      icon: _binIcon,
                      position: collectionLatLng,
                      infoWindow: InfoWindow(
                        title: 'Collection Point',
                        snippet: 'Collection point ${i + 1}',
                      ),
                    ),
                  );
                }

                widget = GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _allCoordinates.first,
                    zoom: 15.0,
                  ),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route_path'),
                      points: _allCoordinates,
                      color: Colors.blue,
                      width: 5,
                    ),
                  },
                  markers: markers,
                );
              }
            });
          }

          return widget;
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
