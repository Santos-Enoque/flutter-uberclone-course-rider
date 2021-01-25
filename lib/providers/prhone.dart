import 'package:flutter/material.dart';

class PhoneProvider with ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Color formBorderColor = Colors.black;
  TextEditingController phoneController = TextEditingController();
  String completePhoneNumber;

  setPhoneNumber({String number}){
    completePhoneNumber = number;
    notifyListeners();
  }

  changeFormBorderColor({Color color}){
    formBorderColor = color;
    notifyListeners();
  }
}