import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/providers/auth.dart';
import 'package:ubercourserider/providers/phone.dart';
import 'file:///D:/projects/flutter-uberclone-course-rider/lib/screens/authentication/authentication.dart';
import 'file:///D:/projects/flutter-uberclone-course-rider/lib/screens/home/home.dart';
import 'file:///D:/projects/flutter-uberclone-course-rider/lib/screens/phone_number/phone_number_screen.dart';
import 'file:///D:/projects/flutter-uberclone-course-rider/lib/screens/splash/splash.dart';
import 'package:ubercourserider/widgets/loading.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

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
        if(authProvider.userModel.phoneNumber.isEmpty)
          return PhoneValidationScreen();
        return HomeScreen();
      default:
        return AuthenticationScreen();
    }
  }
}

