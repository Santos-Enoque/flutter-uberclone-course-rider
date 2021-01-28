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
  LatLng _pickupCoordinates;
  LatLng _dropOffCoordinates;
  bool _pickUpLocationSet = false;
  bool _dropOffLocationSet = false;
  Address address;

  LatLng get center => _center;
  String countryCode;
  Set<Marker> markers = {};
  BitmapDescriptor locationPin;

  TextEditingController pickupLocationController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();


  AppProvider.initialize() {
    _setCustomMapPin();
    _getUserLocation().then((value) async {
      _addMarker(
          markerPosition: _center, id: 'pickup', title: 'Pickup Location');
      await _getAddressFromCoordinates(point: _center);
      _changeAddress(address: address.addressLine);
      _setCountryCode();
    });
  }

  Future _getUserLocation() async {
    position = await Geolocator.getCurrentPosition();
    _center = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

  Future _getAddressFromCoordinates({@required LatLng point}) async {
    final coordinates = Coordinates(point.latitude, point.longitude);
    List<Address> addresses =await Geocoder.local.findAddressesFromCoordinates(coordinates);
    address = addresses[0];
  }

  onCameraMove(CameraPosition cameraPosition) {
    _changeAddress(address: "loading...");
    _lastPosition = cameraPosition.target;
    if (markers.isNotEmpty) {
      if (!_pickUpLocationSet) {
        _moveMarkerAndChangeAddress(
            cameraPosition: cameraPosition,
            markerId: 'pickup',
            markerTitle: 'Pickup Location');
      } else if (!_dropOffLocationSet) {
        _moveMarkerAndChangeAddress(
            cameraPosition: cameraPosition,
            markerId: 'dropoff',
            markerTitle: 'Drop off Location');
      }
    }
  }

  void _moveMarkerAndChangeAddress(
      {@required CameraPosition cameraPosition,
      @required String markerId,
      @required String markerTitle}) {
    LatLng _point = cameraPosition.target;
    _updateLocationMarker(
        cameraPosition: cameraPosition,
        markerTitle: markerTitle,
        markerId: markerId);
    _setCoordinates(coordinates: _point, isPickup: markerId == 'pickup');
    _getAddressFromCoordinates(point: _point).then((value) async {
      _changeAddress(
          address: address.addressLine, isPickup: markerId == "pickup");
    });
  }

  void _updateLocationMarker(
      {@required CameraPosition cameraPosition,
      @required String markerId,
      @required String markerTitle}) {
    Marker _marker =
        markers.singleWhere((element) => element.markerId.value == markerId);
    markers.remove(_marker);
    _addMarker(
        markerPosition: cameraPosition.target,
        id: markerId,
        title: markerTitle);

    notifyListeners();
  }

  _setCoordinates({LatLng coordinates, bool isPickup}) {
    if (isPickup) {
      _pickupCoordinates = coordinates;
    } else {
      _dropOffCoordinates = coordinates;
    }
    notifyListeners();
  }

  _setCountryCode() {
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
