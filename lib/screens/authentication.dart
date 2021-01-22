import 'package:flutter/material.dart';
import 'package:ubercourserider/widgets/auth_button.dart';
import 'package:ubercourserider/widgets/custom_text.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                        onTap: (){},
                      ),
                        AuthButton(
                          title: "Facebook",
                          image: "facebook.png",
                          onTap: (){},
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
