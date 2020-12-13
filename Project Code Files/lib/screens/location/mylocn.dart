import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hifichat/global_variables.dart';

var mylat = 20.59;
var mylon = 78.96;

class MyLocnMap extends StatefulWidget {
  @override
  _MyLocnMapState createState() => _MyLocnMapState();
}

class _MyLocnMapState extends State<MyLocnMap> {
  Completer<GoogleMapController> _controller = Completer();

  showMyLocn() async {
    var p = await Geolocator.getCurrentPosition();
    mylat = p.latitude;
    mylon = p.longitude;
    final CameraPosition _kLake =
        CameraPosition(target: LatLng(mylat, mylon), zoom: 14);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

    hiFiFS.collection('/HiFiUsersData/').doc(email).update({
      'loc': [mylat, mylon],
    });
  }

  @override
  void initState() {
    showMyLocn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.green,
            height: 70,
            child: Text(
              'My Location',
              textScaleFactor: 2,
            ),
          ),
          Expanded(
            child: Container(
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(mylat, mylon),
                  zoom: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
