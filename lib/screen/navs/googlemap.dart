import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../home.dart';


class MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Function to get the current location
  void _getCurrentLocation() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = position;
        });
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      // Request location permission
      await Permission.location.request();
    }
  }

  // Function to add a marker at the current location
  void _addMarkerAtCurrentLocation() {
    if (_currentPosition != null && _controller != null) {
      Marker marker = Marker(
        markerId: const MarkerId("current_location"),
        position: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // You can customize the marker icon here
        infoWindow: const InfoWindow(
          title: "Current Location",
        ),
      );

      setState(() {
        _markers.add(marker);
      });

      _controller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 15.0,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12.0,
        ),
        markers: _markers, // Add markers to the map
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight, // Align to the bottom left corner
        child: Padding(
          padding: const EdgeInsets.only(right: 45.0), // Add some left padding
          child: FloatingActionButton(
            onPressed: () {
              _addMarkerAtCurrentLocation(); // Call the function to add a marker
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent, // Use foregroundColor to set the color of the child
            child: const Icon(Icons.my_location),
          ),
        ),
      ),

    );
  }
}