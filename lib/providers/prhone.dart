import 'package:flutter/material.dart';
import 'package:ubercourserider/helpers/constants.dart';
import 'package:ubercourserider/services/user.dart';

class PhoneProvider with ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Color formBorderColor = Colors.transparent;
  TextEditingController phoneController = TextEditingController();
  String completePhoneNumber;
  UserServices _userServices = UserServices();

  setPhoneNumber({String number}){
    completePhoneNumber = number;
    notifyListeners();
  }

  changeFormBorderColor({Color color}){
    formBorderColor = color;
    notifyListeners();
  }

  bool addPhoneNumber({String userId})=>  _userServices.updateUserData({
    "id": userId,
    "phoneNumber": completePhoneNumber
  });
}