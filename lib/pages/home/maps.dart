// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_viruses/helper/session.dart';
import 'package:flutter_viruses/pages/added/detail.dart';
import 'package:flutter_viruses/pages/added/filter_items.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';


class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  //final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    List<String> places = [];
      Session.shared.viruses.forEach((element) {
        if (!places.contains(element.country)) {
          places.add(element.country);
        }
      });

    Set<Marker> markers = {};

    places.forEach((place) async {
      var virusesWithTheSamePoints = Session.shared.viruses
        .where((element) => place == element.country)
        .toList();

      var title = "";
      virusesWithTheSamePoints.forEach((element) {
        title += element.fullName + "\n";
      });

      var googleGeocoding = GoogleGeocoding("AIzaSyDCMnsFaeWZn8S9KOTs9xgL9DaTjmIATxU");
      var result = await googleGeocoding.geocoding.get(place, null);
      var markerIdVal = Uuid().v4();
      final MarkerId markerId = MarkerId(markerIdVal);
          
      var marker = Marker(
        position: LatLng(result.results.first.geometry.location.lat, result.results.first.geometry.location.lng),
        markerId: markerId,
        infoWindow: InfoWindow(title: place,
        onTap: () {
          if (virusesWithTheSamePoints.length == 1) {
            Session.shared.detailVirus = virusesWithTheSamePoints[0];
            Navigator.push(context, MaterialPageRoute(builder: (context) => Detail()));
          } else {
            Session.shared.resultViruses = virusesWithTheSamePoints;
            Navigator.push(context, MaterialPageRoute(builder: (context) => FilterItems()));
          }
        },
        snippet: title),
      );

      markers.add(marker);
      setState(() {
        _markers = markers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: LatLng(53.9006, 27.5590),
          zoom: 4.0,
        ),
      ),
    );
  }
}