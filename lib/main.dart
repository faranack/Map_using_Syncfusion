import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LocationTrackerBlog(title: 'Flutter Demo Home Page'),
    );
  }
}

class LocationTrackerBlog extends StatefulWidget {
  const LocationTrackerBlog({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  // State<LocationTrackerBlog> createState() => _LocationTrackerBlogState();
  State<LocationTrackerBlog> createState() => _MarkerPageState();
}
class _MarkerPageState extends State<LocationTrackerBlog> {

  late MapLatLng _markerPosition;
  late _CustomZoomPanBehavior _mapZoomPanBehavior;
  late MapTileLayerController _controller;
  var Latitude = 'خالی';
  var Longitude = 'خالی';

  @override
  void initState() {
    _controller = MapTileLayerController();
    _mapZoomPanBehavior = _CustomZoomPanBehavior()..onTap = updateMarkerChange;
    // _mapZoomPanBehavior = _CustomZoomPanBehavior();
    // _mapZoomPanBehavior.onTap = updateMarkerChange;
    super.initState();
  }


  void updateMarkerChange(Offset position) {
    _markerPosition = _controller.pixelToLatLng(position);
    print("$_markerPosition");
    setState(() {
      Latitude = _markerPosition.latitude.toString();
      Longitude = _markerPosition.longitude.toString();
    });
    // if (_controller.markersCount > 0) {
    //   _controller.clearMarkers();
    // }
    _controller.insertMarker(0);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marker sample')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SfMaps(
            layers: [
              MapTileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                zoomPanBehavior: _mapZoomPanBehavior,
                controller: _controller,
                markerBuilder: (BuildContext context, int index) {
                  return MapMarker(
                    latitude: _markerPosition.latitude,
                    longitude: _markerPosition.longitude,
                    child: const Icon(Icons.add_location, color: Colors.red),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10,width: 10),
          Container(alignment: AlignmentDirectional.topStart,child: Text("Latitude: $Latitude")),
          const SizedBox(height: 10,width: 10),
          Container(alignment: AlignmentDirectional.topStart,child: Text("Longitude: $Longitude")),
        ],
      ),
    );
  }
}


class _CustomZoomPanBehavior extends MapZoomPanBehavior {
  late MapTapCallback onTap;

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerUpEvent) {
      onTap(event.localPosition);
    }else if(event is PointerDownEvent){
      print("PointerDownEvent");
    }
    super.handleEvent(event);
  }
}


typedef MapTapCallback = void Function(Offset position);


// class _LocationTrackerBlogState extends State<LocationTrackerBlog> {
//   late List<Model> _data;
//
//   @override
//   void initState() {
//     _data = const <Model>[
//       Model('Brazil', -14.235004, -51.92528),
//       // Model('Germany', 51.16569, 10.451526),
//       // Model('Australia', -25.274398, 133.775136),
//       // Model('India', 20.593684, 78.96288),
//       // Model('Russia', 61.52401, 105.318756)
//     ];
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SfMaps(
//           layers: <MapLayer>[
//             MapTileLayer(
//               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               initialMarkersCount: 1,
//               markerBuilder: (BuildContext context, int index) {
//                 return MapMarker(
//                   latitude: _data[index].latitude,
//                   longitude: _data[index].longitude,
//                   iconColor: Colors.blue,
//                   child:  Icon(Icons.add_location),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
// }
// class Model {
//   const Model(this.country, this.latitude, this.longitude);
//
//   final String country;
//   final double latitude;
//   final double longitude;
// }


