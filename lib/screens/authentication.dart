import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/providers/auth.dart';
import 'package:ubercourserider/screens/home.dart';
import 'package:ubercourserider/widgets/auth_button.dart';
import 'package:ubercourserider/widgets/custom_text.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ubercourserider/widgets/loading.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: appProvider.isLoading ? Loading() : Stack(
        children: [
          Image.asset(
            "assets/images/bg.jpg", width: double.infinity, height: MediaQuery
              .of(context)
              .size
              .height, fit: BoxFit.cover,),
          Column(
            children: [
              SizedBox(
                height: 250,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 250,
                      child: Image.asset("assets/images/logo.png")),
                ],
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: .2,
            minChildSize: .2,
            maxChildSize: .2,
            builder: (context, scrollController){
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      offset: Offset(2, 3),
                      blurRadius: 12
                    )
                  ]
                ),
                child: Column(
                  children: [
                    SizedBox(height:30),
                    CustomText(
                      text: "Login or Register with",
                    ),
                    SizedBox(height:20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      AuthButton(
                        title: "Google",
                        image: "google.png",
                        onTap: () async {
                          appProvider.changeLoading();
                         await authProvider.authenticate(context, method: AuthenticationMethod.Google);
                          appProvider.changeLoading();

                        },
                      ),
                        AuthButton(
                          title: "Facebook",
                          image: "facebook.png",
                          onTap: () async {
                            appProvider.changeLoading();
                          await  authProvider.authenticate(context, method: AuthenticationMethod.Facebook);
                            appProvider.changeLoading();
                          },
                        )


                      ],
                    ),

                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
