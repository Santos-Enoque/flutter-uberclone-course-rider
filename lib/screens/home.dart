import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/providers/app.dart';
import 'package:ubercourserider/providers/auth.dart';
import 'package:ubercourserider/widgets/custom_text.dart';
import 'package:ubercourserider/widgets/drop_off_selection_widget.dart';
import '../widgets/pickup_selection_widget.dart';

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
          MapScreen(
            scaffoldKey: _key,
          ),
          PickupSelectionWidget()
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MapScreen({Key key, this.scaffoldKey}) : super(key: key);
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: appProvider.center == null
            ? CircularProgressIndicator()
            : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: appProvider.center,
                      zoom: 17,
                    ),
                    onMapCreated: appProvider.onCreate,
                    myLocationEnabled: true,
                    markers: appProvider.markers,
                    onCameraMove: appProvider.onCameraMove,
                  ),
                  Positioned(
                      child: IconButton(
                          icon: Icon(Icons.menu, size: 40,),
                          onPressed: () {
                            widget.scaffoldKey.currentState.openDrawer();
                          }))
                ],
              ),
      ),
    );
  }
}
