import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppProvider with ChangeNotifier {

  Position position;
  GoogleMapController _mapController;
  bool isLoading = false;
  LatLng _center;
  LatLng get center => _center;
  String country = "";



  AppProvider.initialize() {
    _getUserLocation();
  }

  _getUserLocation() async {
    position = await Geolocator.getCurrentPosition();
    _center = LatLng(position.latitude, position.longitude);
    final coordinates = new Coordinates(_center.latitude, _center.longitude);
    List<Address> addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String countryCode = addresses[0].countryCode;
    country = countryCode;
    notifyListeners();
  }

  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
