import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ubercourserider/helpers/constants.dart';

class AppProvider with ChangeNotifier {
  Position position;
  GoogleMapController _mapController;
  bool isLoading = false;
  LatLng _center;

  LatLng get center => _center;
  String country;
  Set<Marker> markers = {};
  BitmapDescriptor locationPin;

  AppProvider.initialize() {
    _setCustomMapPin();
    _getUserLocation();
  }

  _getUserLocation() async {
    position = await Geolocator.getCurrentPosition();

    _center = LatLng(position.latitude, position.longitude);
    _addMarker(markerPosition: _center, id: 'pickup', title: 'Pickup Location');
    final coordinates = new Coordinates(_center.latitude, _center.longitude);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String countryCode = addresses[0].countryCode;
    country = countryCode;
    logger.i(
      "user country is $country",
    );
    notifyListeners();
  }

  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  _setCustomMapPin() async {
    locationPin = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/pin.png');
  }

  _addMarker({LatLng markerPosition, String id, String title}) {
    markers.add(Marker(
        markerId: MarkerId(id),
        position: markerPosition,
        zIndex: 10,
        infoWindow: InfoWindow(title: title),
        icon: locationPin));
    notifyListeners();
  }

  changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
