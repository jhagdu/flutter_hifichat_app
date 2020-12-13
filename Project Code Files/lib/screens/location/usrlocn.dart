import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var usrlat = 28.0;
var usrlon = 77.0;

class UsersLocn extends StatefulWidget {
  @override
  _UsersLocnState createState() => _UsersLocnState();
}

class _UsersLocnState extends State<UsersLocn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(usrlat, usrlon),
          zoom: 14,
        ),
      ),
    );
  }
}
