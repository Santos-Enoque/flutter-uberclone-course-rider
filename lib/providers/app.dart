import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppProvider with ChangeNotifier {

  Position position;
  GoogleMapController _mapController;
  LatLng _center;
  LatLng get center => _center;



  AppProvider.initialize() {
    _getUserLocation();
  }

  _getUserLocation() async {
    position = await Geolocator.getCurrentPosition();
    _center = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }
}
