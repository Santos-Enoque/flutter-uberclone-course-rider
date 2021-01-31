import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubercourserider/constants/firebase_constants.dart';
import 'package:ubercourserider/models/user.dart';
import 'file:///D:/projects/flutter-uberclone-course-rider/lib/screens/home/home.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ubercourserider/utils/services/user.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }
enum AuthenticationMethod {Google, Facebook}

class AuthProvider with ChangeNotifier {
  User _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();

  UserModel _userModel;
  GoogleSignIn _googleSignIn = GoogleSignIn();

//  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  User get user => _user;

  FacebookLogin _facebookLogin = FacebookLogin();

  AuthProvider.init() {
    _fireSetUp();
  }

  _fireSetUp() async {
    await initialization.then((value) {
      auth.authStateChanges().listen(_onStateChanged);
    });
  }

  Future<Map<String, dynamic>> authenticateWithGoogle() async {
    _status = Status.Authenticating;
    notifyListeners();
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _authenticateOnFirebase(credential);
      return {'success': true, 'message': 'success'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> authenticateWithFacebook() async {
     FacebookLoginResult result = await _facebookLogin.logIn(["email"]);
     if(result.status ==  FacebookLoginStatus.loggedIn){
       String token = result.accessToken.token;
       final AuthCredential credential = FacebookAuthProvider.credential(token);
       await _authenticateOnFirebase(credential);
       return {"success": true, "message": "success"};
     }else if(result.status ==  FacebookLoginStatus.cancelledByUser){
       return {"success": false, "message": "authentication cancelled"};
     }else{
       print("FACEBOOK AUTH ERROR: ${result.errorMessage}");
       return {"success": false, "message": "Authentication failed"};
     }
  }

  Future _authenticateOnFirebase(AuthCredential credential) async {
        await auth.signInWithCredential(credential).then((userCredentials) async{
      _user = userCredentials.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("id", _user.uid);
      if (!await _userServices.doesUserExist(_user.uid)) {
      _userServices.createUser(
      id: _user.uid, name: _user.displayName, photo: _user.photoURL, email: _user.email);
      await initializeUserModel();
      } else {
      await initializeUserModel();
      }
    });
  }

  Future<bool> initializeUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _userId = preferences.getString('id');
    _userModel = await _userServices.getUserById(_userId);
    notifyListeners();
    if (_userModel == null) {
      return false;
    } else {
      return true;
    }
  }

  authenticate(BuildContext context, {@required AuthenticationMethod method})async{
    Map result = method == AuthenticationMethod.Google ? await authenticateWithGoogle() : await authenticateWithFacebook();
    bool success = result['success'];
    String message = result['message'];
    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      HomeScreen().launch(context);
    }
  }

  Future signOut() async {
    auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  _onStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      notifyListeners();
    } else {
      _user = firebaseUser;
      await initializeUserModel().then((value) {
        _status = Status.Authenticated;
        notifyListeners();
      });
    }
  }
}
