import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/widgets/custom_btn.dart';

import '../../../widgets/custom_text.dart';

class DropOffSelectionWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const DropOffSelectionWidget({Key key, this.scaffoldState}) : super(key: key);

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
                color: Colors.grey.withOpacity(.8),
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
                  text: "Move the pin to adjust drop off location",
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
                  color: Colors.grey.withOpacity(.3),
                  child: TextField(
                    onTap: () async {
                      // appProvider.displayPlacesSearchWidget(context);
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
                              color: Colors.black,
                            )),
                        hintText: "Drop off Location",
                        hintStyle: TextStyle(
                            color: Colors.black,
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
