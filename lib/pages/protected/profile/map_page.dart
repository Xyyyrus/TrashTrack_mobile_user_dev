import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trashtrack_user/helpers/message_dialog_helper.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.selectedBarangay});
  final String selectedBarangay;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RouteData> _routes = [];
  List<String> _routeNames = [];
  String? _selectedRoute;
  BitmapDescriptor _truckIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _userIcon = BitmapDescriptor.defaultMarker;
  LatLng? _currentLocation;
  BitmapDescriptor _goIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _stopIcon = BitmapDescriptor.defaultMarker;

  // Default location for Mandaluyong
  static const LatLng _mandaluyongLocation = LatLng(14.5995, 121.0360);

  @override
  void initState() {
    super.initState();
    _loadTruckIcon();
    _loadUserIcon();
    _fetchRoutes();
    _loadgoIcon();
    _loadstopIcon();
    _getCurrentLocation(); // Get current location
  }

  Future<void> _loadTruckIcon() async {
    _truckIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Reduced size
      'lib/assets/images/truck.png',
    );
    setState(() {}); // Update the map with the new icon
  }

  Future<void> _loadgoIcon() async {
    _goIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Reduced size
      'lib/assets/images/green-go.png',
    );
    setState(() {}); // Update the map with the new icon
  }

  Future<void> _loadstopIcon() async {
    _stopIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Reduced size
      'lib/assets/images/red-stop.png',
    );
    setState(() {}); // Update the map with the new icon
  }

  Future<void> _loadUserIcon() async {
    _userIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)), // Reduced size
      'lib/assets/images/user.png', // Path to user icon
    );
    setState(() {}); // Update the map with the new icon
  }

  Future<void> _fetchRoutes() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('routes').get();
      setState(() {
        _routes = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return RouteData(
            routeName: data['routeName'],
            distance: data['distance'],
            duration: data['duration'],
            pathPoints: (data['path'] as List).map((point) {
              return LatLng(point['lat'], point['lng']);
            }).toList(),
          );
        }).toList();

        _routeNames = _routes.map((route) => route.routeName).toList();
      });
      debugPrint('Number of routes retrieved: ${_routes.length}');
    } catch (e) {
      debugPrint('Error fetching routes: $e');
      // Optionally, show an error message to the user
      MessageDialogHelper.showErrorDialog(
        // ignore: use_build_context_synchronously
        context,
        'Error',
        'Failed to fetch routes. Please try again later.',
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          // Permissions are denied, show a message and use default location
          MessageDialogHelper.showErrorDialog(
            // ignore: use_build_context_synchronously
            context,
            'Location Permission',
            'Location permissions are denied. Showing default location.',
          );
          setState(() {
            _currentLocation = _mandaluyongLocation;
          });
          return;
        }
      }

      // Get current location if permission granted
      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint('Error getting current location: $e');
      // Optionally, show an error message and use default location
      MessageDialogHelper.showErrorDialog(
        // ignore: use_build_context_synchronously
        context,
        'Location Error',
        'Failed to get current location. Showing default location.',
      );
      setState(() {
        _currentLocation = _mandaluyongLocation;
      });
    }
  }

  void _showRouteSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Route'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _routeNames.map((String routeName) {
                return ListTile(
                  title: Text(routeName),
                  onTap: () {
                    setState(() {
                      _selectedRoute = routeName;
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page'),
        backgroundColor: const Color(0xFF02413C),
        centerTitle: true,
      ),
      body: Stack(
        // Use Stack to position FAB
        children: [
          Column(
            children: [
              Expanded(
                child: _routes.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentLocation ?? _mandaluyongLocation,
                          zoom: 14.0,
                        ),
                        polylines: _createPolylines(),
                        markers: _createMarkers(),
                        myLocationEnabled: _currentLocation != null,
                        myLocationButtonEnabled: true,
                      ),
              ),
            ],
          ),
          Positioned(
            top: 16.0, // Distance from top
            right: 16.0, // Distance from right
            child: GestureDetector(
              // Use GestureDetector for tap
              onTap: _showRouteSelectionDialog,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.route, color: Colors.white, size: 20),
                    SizedBox(width: 8.0), // Space between icon and text
                    Text(
                      'Select Route',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<Polyline> _createPolylines() {
    Set<Polyline> polylines = {};

    for (var route in _routes) {
      if (_selectedRoute == null || route.routeName == _selectedRoute) {
        polylines.add(Polyline(
          polylineId: PolylineId(route.routeName),
          points: route.pathPoints,
          color: Colors.blue,
          width: 3, // Reduced width for thinner lines
        ));
      }
    }

    return polylines;
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    // Add marker for current location
    if (_currentLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocation!,
        // icon: _userIcon, removed due to not following the user's actual loc
        infoWindow: const InfoWindow(
          title: 'Your Location',
        ),
      ));
    }

    for (var route in _routes) {
      if (_selectedRoute == null || route.routeName == _selectedRoute) {
        if (route.pathPoints.isNotEmpty) {
          markers.add(Marker(
            markerId: MarkerId('${route.routeName}_start'),
            position: route.pathPoints.first,
            icon: _goIcon,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueAccent,
                  content: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Use min size to fit content
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align items to the start
                    children: [
                      const Text(
                        'Start Point of collection', // Replace with your actual start point variable
                        style: TextStyle(
                          fontSize: 18, // Font size for the title
                          color: Colors.white, // Title color
                          fontWeight: FontWeight.bold, // Make title bold
                        ),
                      ),
                      const SizedBox(
                          height:
                              4), // Add some space between title and content
                      Text(
                        '🚙 Distance: ${route.distance} km\n'
                        '⌚ Duration: ${route.duration} min',
                        style: const TextStyle(
                          fontSize: 16, // Adjust font size
                          color: Colors.white, // Change text color
                          fontWeight: FontWeight.normal, // Make text normal
                        ),
                        textAlign: TextAlign.left, // Align text to the left
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  behavior: SnackBarBehavior.floating, // Make it float
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 20), // Adjust margin
                ),
              );
            },
          ));
          markers.add(Marker(
            markerId: MarkerId('${route.routeName}_end'),
            position: route.pathPoints.last,
            icon: _stopIcon,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueAccent,
                  content: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Use min size to fit content
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align items to the start
                    children: [
                      const Text(
                        'End Point of collection', // Replace with your actual start point variable
                        style: TextStyle(
                          fontSize: 18, // Font size for the title
                          color: Colors.white, // Title color
                          fontWeight: FontWeight.bold, // Make title bold
                        ),
                      ),
                      const SizedBox(
                          height:
                              4), // Add some space between title and content
                      Text(
                        '🚙 Distance: ${route.distance} km\n'
                        '⌚ Duration: ${route.duration} min',
                        style: const TextStyle(
                          fontSize: 16, // Adjust font size
                          color: Colors.white, // Change text color
                          fontWeight: FontWeight.normal, // Make text normal
                        ),
                        textAlign: TextAlign.left, // Align text to the left
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  behavior: SnackBarBehavior.floating, // Make it float
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 20), // Adjust margin
                ),
              );
            },
          ));
          // markers.add(Marker(
          //   markerId: MarkerId('${route.routeName}_end'),
          //   position: route.pathPoints.last,
          //   icon: _stopIcon,
          //   infoWindow: InfoWindow(
          //     title: 'End Point',
          //     snippet:
          //         '📍 Distance: ${route.distance} km\n⏱ Duration: ${route.duration} min',
          //     // This will create a more formatted display.
          //   ),
          // ));
        }
      }
    }

    return markers;
  }
}

class RouteData {
  final String routeName;
  final String distance;
  final String duration;
  final List<LatLng> pathPoints;

  RouteData({
    required this.routeName,
    required this.distance,
    required this.duration,
    required this.pathPoints,
  });
}
