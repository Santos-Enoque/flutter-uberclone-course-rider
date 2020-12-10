import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/providers/app.dart';
import '../widgets/pickup_selection_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text("Santos Enoque"),
                accountEmail: Text("abc@email.com"))
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
                      zoom: 13,
                    ),
                    onMapCreated: appProvider.onCreate,
                    myLocationEnabled: true,
                  ),
                  Positioned(
                      child: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            widget.scaffoldKey.currentState.openDrawer();
                          }))
                ],
              ),
      ),
    );
  }
}
