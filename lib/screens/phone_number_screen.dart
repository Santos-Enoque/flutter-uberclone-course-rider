import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/helpers/dimenssions.dart';
import 'package:ubercourserider/helpers/navigation.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/providers/auth.dart';
import 'package:ubercourserider/providers/prhone.dart';
import 'package:ubercourserider/screens/home.dart';
import 'package:ubercourserider/widgets/custom_btn.dart';
import 'package:ubercourserider/widgets/custom_text.dart';
import 'package:ubercourserider/widgets/loading.dart';

class PhoneValidationScreen extends StatefulWidget {
  @override
  _PhoneValidationScreenState createState() => _PhoneValidationScreenState();
}

class _PhoneValidationScreenState extends State<PhoneValidationScreen> {
  @override
  Widget build(BuildContext context) {
     AppProvider appProvider = Provider.of<AppProvider>(context);
     PhoneProvider phoneProvider = Provider.of<PhoneProvider>(context);
     AuthProvider authProvider = Provider.of<AuthProvider>(context);


    return Scaffold(
      key: phoneProvider.scaffoldKey,
      appBar: AppBar(
        title: CustomText(text: "Add Phone Number",),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: appProvider.countryCode == null
          ? Loading()
          : SingleChildScrollView(
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
                            color: Colors.grey.withOpacity(.3),
                            border: Border.all(
                              color: phoneProvider.formBorderColor,
                              style: BorderStyle.solid,
                            )),
                        child: IntlPhoneField(
                          controller: phoneProvider.phoneController,
                          onSubmitted: (value){

                            if (phoneProvider.formKey.currentState.validate())
                              return showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30)),
                                      title: Container(
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: "Confirm Number",
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                      content: CustomText(
                                        text:
                                        "Use ${phoneProvider.completePhoneNumber}  as your phone number",
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            appProvider.changeLoading();
                                            if(!phoneProvider.addPhoneNumber(userId: authProvider.userModel.id)){
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text("Number not added"),
                                              ));
                                              appProvider.changeLoading();
                                            }else{
                                              finish(context);
                                              HomeScreen().launch(context);
                                              appProvider.changeLoading();
                                            }
                                          },
                                          child: CustomText(
                                            text: "Yes",
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            finish(context);
                                          },
                                          child: CustomText(
                                            text: "No",
                                          ),
                                        )
                                      ],
                                    );
                                  });
                          },
                          decoration: InputDecoration(
                              hintText: 'Phone Number',
                              border: InputBorder.none),
                          initialCountryCode: 'MZ',
                          onChanged: (value) {
                            phoneProvider.setPhoneNumber(
                                number: value.completeNumber);
                          },
                          autoValidate: false,
                          validator: (value) {
                            if (value.length < 1) {
                              phoneProvider.changeFormBorderColor(
                                  color: Colors.red);
                              return 'Number must not be empty';
                            } else {
                              phoneProvider.changeFormBorderColor(
                                  color: Colors.black);
                              return null;
                            }
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
    );
  }
}
