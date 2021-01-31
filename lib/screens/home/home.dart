import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/providers/auth.dart';
import 'package:ubercourserider/screens/home/widgets/map.dart';
import 'package:ubercourserider/widgets/custom_text.dart';
import 'file:///D:/projects/flutter-uberclone-course-rider/lib/screens/home/widgets/drop_off_selection_widget.dart';
import 'widgets/pickup_selection_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);


    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(

                accountName: Text(authProvider.userModel.name),
                accountEmail: Text(authProvider.userModel.email),
            decoration: BoxDecoration(
              color: Colors.black
            ),),

            ListTile(
              leading: Icon(Icons.exit_to_app_rounded),
              title: CustomText(text: "Log out",),
              onTap: (){
                authProvider.signOut();
              },
            )
          ],
        ),
      ),
      body: Stack(
        children: [
         MapWidget(scaffoldKey: _key,),
          PickupSelectionWidget()
        ],
      ),
    );
  }
}


