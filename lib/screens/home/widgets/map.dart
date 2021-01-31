import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ubercourserider/providers/app.dart';

class MapWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MapWidget({Key key, this.scaffoldKey}) : super(key: key);

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
                    scaffoldKey.currentState.openDrawer();
                    }))
          ],
        ),
      ),
    );
  }
}
