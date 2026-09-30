import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(13.704182091000947, -89.23053873244504),
    zoom: 17,
  );

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId("Christopher"),
      position: LatLng(13.704182091000947, -89.23053873244504),
      infoWindow: InfoWindow(title: "Mi trabajo"),
    ),
  };

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void addMarker(LatLng latLong) async {
    TextEditingController textController = TextEditingController();

    String? title = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Añade un título"),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(hintText: "Lugar..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(textController.text),
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );

    if (title != null && title.isNotEmpty) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(latLong.toString()),
            position: latLong,
            infoWindow: InfoWindow(title: title),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapas")),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          onMapCreated: (controller) => _controller = controller,
          mapType: MapType.normal,
          markers: _markers,
          onTap: (latLong) => addMarker(latLong),
        ),
      ),
    );
  }
}
