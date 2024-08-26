import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_hrms/services/localization.dart';
import 'package:pocket_hrms/util/config.dart';
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';

class GoogleMapController extends GetxController with SharedPreferencesMixin {
  var markers = <Marker>[].obs;
  var circle = <Circle>[].obs;
  Position? currentPosition;
}

class GmapView extends StatelessWidget
    with SharedPreferencesMixin
    implements PreferredSizeWidget {
  final GoogleMapController GoogleMapCtrl = Get.put(GoogleMapController());

  GmapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            mapType: MapType.terrain,
            markers: GoogleMapCtrl.markers.toSet(),
            circles: GoogleMapCtrl.circle.toSet(),
            initialCameraPosition: CameraPosition(
                zoom: 16,
                target: LatLng(GoogleMapCtrl.currentPosition!.latitude,
                    GoogleMapCtrl.currentPosition!.longitude)))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
