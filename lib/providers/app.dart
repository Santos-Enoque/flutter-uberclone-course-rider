import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:ubercourserider/constants/app_constants.dart';

class AppProvider with ChangeNotifier {
  Position position;
  GoogleMapController _mapController;
  bool isLoading = false;
  LatLng _center;
  LatLng _lastPosition;
  LatLng _pickupCoordinates;
  LatLng _dropOffCoordinates;
  bool _isPickupSet = false;
  bool _isDropOffSet = false;
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
      if (_isPickupSet == false) {
        _moveMarkerAndChangeAddress(
            cameraPosition: cameraPosition,
            markerId: 'pickup',
            markerTitle: 'Pickup Location');
      } else if (_isDropOffSet = false) {
        _moveMarkerAndChangeAddress(
            cameraPosition: cameraPosition,
            markerId: 'dropoff',
            markerTitle: 'Drop off Location');
      }
    }
  }

  _animateCamera({LatLng point}) async {
    await _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: point,
            tilt: 15,
            zoom: 19)));
  }

  displayPlacesSearchWidget(BuildContext context)async{
    Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: GOOGLE_MAPS_API_KEY,
        mode: Mode.overlay,
        components: [new Component(Component.country, countryCode)]
    );
    GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: GOOGLE_MAPS_API_KEY);

    PlacesDetailsResponse detail =await places.getDetailsByPlaceId(prediction.placeId);
    double lat = detail.result.geometry.location.lat;
    double lng = detail.result.geometry.location.lng;
    LatLng _point = LatLng(lat, lng);

    _changeAddress(address: prediction.description);
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
   _animateCamera(point: _point);
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
    _setCoordinates(coordinates: _point);
    _getAddressFromCoordinates(point: _point).then((value) async {
      _changeAddress(
          address: address.addressLine);
    });
  }

  void _updateLocationMarker(
      {@required CameraPosition cameraPosition,
      @required String markerId,
      @required String markerTitle}) {
    try{
      Marker _marker =
      markers.singleWhere((element) => element.markerId.value == markerId);
      markers.remove(_marker);
      _addMarker(
          markerPosition: cameraPosition.target,
          id: markerId,
          title: markerTitle);
    }catch(error){
      logger.e(error.toString());
    }
  }

  _setCoordinates({LatLng coordinates}) {
    if (_isPickupSet == false) {
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

  _changeAddress({String address}) async {
    if (_isPickupSet == false) {
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
