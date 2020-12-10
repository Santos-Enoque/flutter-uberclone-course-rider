import 'package:flutter/material.dart';
import 'package:ubercourserider/helpers/style.dart';

import 'custom_text.dart';

class PickupSelectionWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const PickupSelectionWidget({Key key, this.scaffoldState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.28,
      builder: (BuildContext context, myScrollController) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: grey.withOpacity(.8),
                offset: Offset(3, 2),
                blurRadius: 7)
          ]),
          child: ListView(
            controller: myScrollController,
            children: [
              SizedBox(
                height: 12,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CustomText(
                  text: "Move the pin to adjust pickup location",
                  size: 12,
                  weight: FontWeight.w300,
                ),
              ]),
              Divider(),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: grey.withOpacity(.3),
                  child: TextField(
                    onTap: () async {},
                    textInputAction: TextInputAction.go,
                    controller: null,
                    decoration: InputDecoration(
                        icon: Container(
                            margin: EdgeInsets.only(left: 20, bottom: 15),
                            width: 10,
                            height: 10,
                            child: Icon(
                              Icons.location_on,
                              color: primary,
                            )),
                        hintText: "Pickup Location",
                        hintStyle: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15)),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RaisedButton(
                    onPressed: () {},
                    color: black,
                    child: CustomText(
                      text: 'Confirm Pickup',
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
