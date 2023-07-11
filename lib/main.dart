import 'dart:math';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'place_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const addressChannel =
      MethodChannel('volodymyr.rykhva/addressChannel');
  late AppleMapController mapController;
  Set<Annotation> annotations = {};
  PlaceDetails? annotationDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Method channel test'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AppleMap(
              annotations: annotations,
              onMapCreated: _onMapCreated,
              onTap: _onTap,
              initialCameraPosition: const CameraPosition(
                target: LatLng(51.509865, -0.118092),
                zoom: 15,
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          if (annotationDetails != null)
            SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  annotationDetails.toString(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<PlaceDetails> _getAddress(double lat, double lon) async {
    final args = {
      'lat': lat,
      'lon': lon,
    };
    dynamic result = await addressChannel.invokeMethod('getAddress', args);
    return PlaceDetails.fromJson(result.cast<String, dynamic>());
  }

  void _onMapCreated(AppleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng latLng) async {
    final res = await _getAddress(latLng.latitude, latLng.longitude);
    final id = AnnotationId(Random().nextInt(1000000).toString());
    final annotation = Annotation(
      annotationId: id,
      position: latLng,
      infoWindow: InfoWindow(
        title: res.name,
      ),
    );
    setState(() {
      annotations = {annotation};
      annotationDetails = res;
    });
    Future.delayed(
      const Duration(milliseconds: 100),
      () => mapController.showMarkerInfoWindow(id),
    );
  }
}
