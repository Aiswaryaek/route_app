// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:route_app/styles/colors.dart';
import '../styles/textstyles.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "Your key";

  Set<Marker> markers = Set();
  Map<PolylineId, Polyline> polylines = {};

  LatLng startLocation = LatLng(11.308312797152421, 75.81628574521424);
  LatLng endLocation = LatLng(11.708232043889279, 76.1093394669075);

  @override
  void initState() {
    markers.add(Marker(
      markerId: MarkerId(startLocation.toString()),
      position: startLocation,
      onTap: () {
        modelBottomSheetStart(context);
      },
      infoWindow: InfoWindow(
        title: 'KOZHIKODE',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    markers.add(Marker(
      markerId: MarkerId(endLocation.toString()),
      position: endLocation,
      onTap: () {
        modelBottomSheetDest(context);
      },
      infoWindow: InfoWindow(
        title: 'WAYANAD',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    getDirections();

    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Google Map",
          style: titleTextStyle,
        ),
        backgroundColor: backGroundColor,
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: startLocation,
          zoom: 16.0,
        ),
        markers: markers,
        polylines: Set<Polyline>.of(polylines.values),
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }

  void modelBottomSheetDest(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
          child: Wrap(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Destination Point', style: titleTextStyle),
                  SizedBox(height: 15),
                  Text(
                    'Wayanad, a rural district. In the Ambukuthi Hills to the south, Edakkal Caves contain ancient petroglyphs, some dating back to the Neolithic age.',style: subTextStyle,),
                  SizedBox(height: 15),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void modelBottomSheetStart(BuildContext context) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.only(left: 15, right: 10, bottom: 10),
          child: Wrap(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Starting Point', style: titleTextStyle),
                  SizedBox(height: 15),
                  Text(
                    'Kozhikode, a coastal city.It was a significant spice trade center and is close to Kappad Beach, where Portuguese explorer Vasco da Gama landed in 1498.',style: subTextStyle,),
                  SizedBox(height: 15),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
