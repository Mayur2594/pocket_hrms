import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GmapView extends StatelessWidget implements PreferredSizeWidget {
  final Set<Marker> markers;
  final Set<Circle> circles;
  final Set<Polyline> polylines;
  final LatLng initialPosition;

  GmapView({
    Key? key,
    this.markers = const {},
    this.circles = const {},
    this.polylines = const {},
    required this.initialPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            mapType: MapType.terrain,
            markers: markers,
            circles: circles,
            polylines: polylines,
            initialCameraPosition:
                CameraPosition(zoom: 12, target: initialPosition))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MarkersOnlyGmapView extends GmapView {
  MarkersOnlyGmapView({
    Key? key,
    required Set<Marker> markers,
    required LatLng initialPosition,
  }) : super(key: key, markers: markers, initialPosition: initialPosition);
}

class MarkersAndRadiusGmapView extends GmapView {
  MarkersAndRadiusGmapView({
    Key? key,
    required Set<Marker> markers,
    required Set<Circle> circles,
    required LatLng initialPosition,
  }) : super(
            key: key,
            markers: markers,
            circles: circles,
            initialPosition: initialPosition);
}

class MarkersAndPolylinesGmapView extends GmapView {
  MarkersAndPolylinesGmapView({
    Key? key,
    required Set<Marker> markers,
    required Set<Polyline> polylines,
    required LatLng initialPosition,
  }) : super(
            key: key,
            markers: markers,
            polylines: polylines,
            initialPosition: initialPosition);
}
