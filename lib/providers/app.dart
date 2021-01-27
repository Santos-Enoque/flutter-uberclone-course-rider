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
  LatLng _lastPosition;

  Address address;
  LatLng get center => _center;
  String countryCode;
  Set<Marker> markers = {};
  BitmapDescriptor locationPin;
  bool _pickUpLocationSet = false;
  bool _dropOffLocationSet = false;
  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();

  AppProvider.initialize() {
    _setCustomMapPin();
    _getUserLocation().then((value)async{
      _addMarker(markerPosition: _center, id: 'pickup', title: 'Pickup Location');
      await _getAddressFromCoordinates();
      _changeAddress(address: address.addressLine);
      _setCountryCode();
    });
  }

 Future _getUserLocation() async {
    position = await Geolocator.getCurrentPosition();
    _center = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

 Future _getAddressFromCoordinates() async {
      final coordinates = new Coordinates(_center.latitude, _center.longitude);
   List<Address> addresses =
       await Geocoder.local.findAddressesFromCoordinates(coordinates);
   address = addresses[0];
 }





  _setCountryCode(){
   countryCode = address.countryCode;
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

  _changeAddress({String address, bool isPickup = true}) async {
    if (isPickup) {
      pickupLocationController.text = address;
    } else {
      dropOffController.text = address;
    }
    notifyListeners();
  }

  changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
