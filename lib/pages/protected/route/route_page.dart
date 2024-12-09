import 'dart:async';
import 'dart:math';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:trashtrack_user/data/repositories/fleet_repository.dart';
import 'package:trashtrack_user/models/fleet/fleet.dart';
import 'package:trashtrack_user/models/schedule/schedule.dart';
import 'package:trashtrack_user/widgets/custom_app_bar.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.schedule});
  final Schedule schedule;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late Location _locationService;
  late StreamSubscription _fleetSubscription;
  late StreamSubscription? _userLocationSubscription;
  final List<LatLng> _allCoordinates = [];
  final List<LatLng> _allCollections = [];
  LatLng? _driverLocation;
  LatLng? _userLocation;
  BitmapDescriptor _truckIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _goIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _stopIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _userIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _binIcon = BitmapDescriptor.defaultMarker;
  bool _isDriverWithinGeofence = false;
  GoogleMapController? mapController;

  // Set the route coordinates from the schedule
  void _setCoordinates() {
    for (var l in widget.schedule.routePath ?? []) {
      _allCoordinates.add(LatLng(l['lat'], l['lng']));
    }
  }

  // Set collection points
  void _setCollections() {
    for (var l in widget.schedule.collectionsPath ?? []) {
      _allCollections.add(LatLng(l['lat'] ?? 0, l['lng'] ?? 0));
    }
  }

  Future<void> _loadTruckIcon() async {
    _truckIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'lib/assets/images/truck.png',
    );
  }

  Future<void> _loadUserIcon() async {
    _userIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Reduced size
      'lib/assets/images/user.png', // Path to user icon
    );
  }

  Future<void> _loadgoIcon() async {
    _goIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'lib/assets/images/green-go.png',
    );
  }

  Future<void> _loadstopIcon() async {
    _stopIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'lib/assets/images/red-stop.png',
    );
  }

  Future<void> _loadbinIcon() async {
    _binIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Reduced size
      'lib/assets/images/trash-bin.png', // Path to user icon
    );
  }

  // Load custom icons for the map markers
  // Future<void> _loadIcons() async {
  //   _goIcon = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(40, 40)),
  //     'lib/assets/images/green-go.png',
  //   );
  //   _stopIcon = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(40, 40)),
  //     'lib/assets/images/red-stop.png',
  //   );
  //   _binIcon = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(40, 40)),
  //     'lib/assets/images/trash-bin.png',
  //   );
  // }

  // Geofence checking logic
  bool _isWithinGeofence(LatLng driverLoc, double radiusMeters) {
    return _allCoordinates.any((point) {
      final distance = Geolocator.distanceBetween(
        driverLoc.latitude,
        driverLoc.longitude,
        point.latitude,
        point.longitude,
      );
      return distance < radiusMeters;
    });
  }

  // Listen to fleet updates
  void _listenToFleetUpdates(FleetRepository fleetRepository) {
    _fleetSubscription = fleetRepository
        .getFleet(widget.schedule.fleetId)
        .listen((result) async {
      result.fold(
        (error) {
          debugPrint('Error fetching fleet data: $error');
          setState(() {
            _driverLocation = null;
            _isDriverWithinGeofence = false;
          });
        },
        (fleet) async {
          try {
            // Check driver status from Firestore
            final isActive = await fleetRepository.isDriverActive(fleet.id);

            if (!isActive) {
              // Driver is inactive; show "Off Duty" but still render the map
              setState(() {
                _driverLocation = null;
                _isDriverWithinGeofence = false;
              });
              return;
            }

            // Update driver location if active
            final location = fleet.location;
            final driverLat = location['latitude'];
            final driverLng = location['longitude'];

            if (driverLat != null && driverLng != null) {
              final driverLoc = LatLng(driverLat, driverLng);
              setState(() {
                _driverLocation = driverLoc;
                _isDriverWithinGeofence = _isWithinGeofence(driverLoc, 50.0);
              });
            }
          } catch (e) {
            debugPrint('Error during fleet update: $e');
            setState(() {
              _driverLocation = null;
              _isDriverWithinGeofence = false;
            });
          }
        },
      );
    });
  }

  void _startUserLocationTracking() {
    _userLocationSubscription =
        _locationService.onLocationChanged.listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _userLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
        });
      }
    }, onError: (error) {
      debugPrint('Error tracking user location: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _setCoordinates();
    _setCollections();
    _loadTruckIcon();
    _loadgoIcon();
    _loadstopIcon();
    _loadUserIcon();
    _loadbinIcon();

    if (widget.schedule.routePath == null ||
        widget.schedule.collectionsPath == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(context, 'Invalid schedule data received.');
      });
    }

    _locationService = Location();
    _locationService.requestPermission().then((permissionStatus) {
      if (permissionStatus != PermissionStatus.granted) {
        _showErrorDialog(context, 'Location permission denied.');
      }
    });

    final fleetRepository = context.read<FleetRepository>();
    _listenToFleetUpdates(fleetRepository);
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _fleetSubscription.cancel();
    _userLocationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Collection Map',
        showLegendIcon: true,
      ),
      body: Stack(
        children: [
          buildGoogleMap(), // Always load the map
          Positioned(
            top: 16,
            right: 16,
            child: _buildStatusFab(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapScreen() {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Collection Map',
        showLegendIcon: true,
      ),
      body: Stack(
        children: [
          buildGoogleMap(),
          Positioned(
            top: 16,
            right: 16,
            child: _buildStatusFab(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFab() {
    String statusMessage;
    Color fabColor;

    if (_driverLocation != null) {
      final driverStatus = _isDriverWithinGeofence ? "On Route" : "Off Route";
      statusMessage = "Active Driver - $driverStatus";
      fabColor = _isDriverWithinGeofence ? Colors.green : Colors.orange;
    } else {
      statusMessage = "Off Duty";
      fabColor = Colors.red;
    }

    return FloatingActionButton.extended(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Status: $statusMessage"),
          ),
        );
      },
      label: Text(
        statusMessage,
        style: const TextStyle(color: Colors.white),
      ),
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      backgroundColor: fabColor,
    );
  }

  Widget buildGoogleMap() {
    final Set<Marker> markers = {
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
      ),
    };

    // Add collection points
    for (int i = 0; i < _allCollections.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('collection_marker_$i'),
          position: _allCollections[i],
          icon: _binIcon,
          infoWindow: InfoWindow(
            title: 'Collection Point',
            snippet: 'Collection point ${i + 1}',
          ),
        ),
      );
    }

    // Only show the driver's marker if the driver is within the geofence or location is available
    if (_driverLocation != null && _isDriverWithinGeofence) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver_marker'),
          position: _driverLocation!,
          icon: _truckIcon,
        ),
      );
    }
    if (_userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_marker'),
          position: _userLocation!,
          icon: _userIcon,
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Your current location',
          ),
        ),
      );
    }

    return GoogleMap(
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
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
    );
  }
}
