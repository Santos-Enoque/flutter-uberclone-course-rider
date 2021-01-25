import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/providers/auth.dart';
import 'package:ubercourserider/providers/prhone.dart';
import 'package:ubercourserider/screens/authentication.dart';
import 'package:ubercourserider/screens/home.dart';
import 'package:ubercourserider/screens/splash.dart';
import 'package:ubercourserider/widgets/loading.dart';

import 'helpers/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  LocationPermission permission = await Geolocator.checkPermission();
  bool _isLocationEnabled  = await Geolocator.isLocationServiceEnabled();

  bool _hasLocationPermission = prefs.getBool(HAS_PERMISSION) ?? false;

  if(!_isLocationEnabled){
    await Geolocator.openLocationSettings();
  }else{
    if(!_hasLocationPermission){
      if(permission != LocationPermission.always){
        LocationPermission requestPermission = await Geolocator.requestPermission();
        if(requestPermission == LocationPermission.always){
          await prefs.setBool(HAS_PERMISSION, true);
        }else{
          //TODO:: do something when the permission is not LocationPermission.always
        }
      }
    }
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AppProvider.initialize()),
    ChangeNotifierProvider.value(value: AuthProvider.init()),
    ChangeNotifierProvider.value(value: PhoneProvider()),

  ],
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Cab Grab",
    home: AppScreensController(),
  ),));
}

class AppScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.Uninitialized:
        return SplashScreen();
      case Status.Unauthenticated:
        return AuthenticationScreen();

      case Status.Authenticating:
        return Loading();
      case Status.Authenticated:
        return HomeScreen();
      default:
        return AuthenticationScreen();
    }
  }
}

