import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/helpers/constants.dart';
import 'package:ubercourserider/helpers/style.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/widgets/custom_btn.dart';

import 'custom_text.dart';

class PickupSelectionWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const PickupSelectionWidget({Key key, this.scaffoldState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
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
                    onTap: () async {
                        appProvider.displayPlacesSearchWidget(context);
                    },
                    textInputAction: TextInputAction.go,
                    controller: appProvider.pickupLocationController,
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
              Padding(
                padding: const EdgeInsets.all(4),
                child: CustomBtn(text: "Continue", onTap: () {}),
              )
            ],
          ),
        );
      },
    );
  }
}
