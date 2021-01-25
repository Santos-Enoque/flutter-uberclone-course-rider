import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/helpers/dimenssions.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/providers/prhone.dart';
import 'package:ubercourserider/widgets/custom_text.dart';
import 'package:ubercourserider/widgets/loading.dart';

class PhoneValidationScreen extends StatefulWidget {
  @override
  _PhoneValidationScreenState createState() => _PhoneValidationScreenState();
}

class _PhoneValidationScreenState extends State<PhoneValidationScreen> {

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    final PhoneProvider phoneProvider = Provider.of<PhoneProvider>(context);


    return Scaffold(
      key: phoneProvider.scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Phone Number Verification',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w900, color: Colors.blue),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: appProvider.country == null ? Loading() : SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Form(
          key: phoneProvider.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: widthScreen(context) / 1.1,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: phoneProvider.formBorderColor,
                        style: BorderStyle.solid,
                      )),
                  child: IntlPhoneField(
                    controller: phoneProvider.phoneController,
                    decoration: InputDecoration(
                      fillColor: Colors.blue,
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    initialCountryCode: appProvider.country,
                    onChanged: (value) {
                      phoneProvider.setPhoneNumber(number: value.completeNumber);
                    },
                    autoValidate: false,
                    validator: (value) {
                      if (value.length < 1) {
                        phoneProvider.changeFormBorderColor(color: Colors.red);
                        return 'Number must not be empty';
                      } else {
                        phoneProvider.changeFormBorderColor(color: Colors.black);
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 150,
                child: RaisedButton(
                  elevation: 2,
                  color: Colors.blue[800],
                  textColor: Colors.white,
                  splashColor: Colors.yellow[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: appProvider.isLoading ? CircularProgressIndicator() : Text(
                      "Send OTP",
                    ),
                  ),
                  onPressed: () {
                    if (phoneProvider.formKey.currentState.validate())
                      return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              title: CustomText(text: "Confirm Number",),
                              content: CustomText(text: "Use ${phoneProvider.completePhoneNumber} \n as your phone number",),
                              actions: [
                                FlatButton(
                                  onPressed: (){},
                                  child: CustomText(text: "Yes",),
                                ),
                                FlatButton(
                                  onPressed: (){},
                                  child: CustomText(text: "Yes",),
                                )
                              ],
                            );
                          });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
