import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class GeolocationServices {
  late bool serviceEnabled;
  late LocationPermission permission;
  late String locationPermissionsMessage;

  checkServiceEnabled() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return serviceEnabled;
  }

  checkLocationPermissions() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      locationPermissionsMessage = 'Location permissions are denied';
      return false;
    }
    if (permission == LocationPermission.deniedForever) {
      locationPermissionsMessage =
          'Location permissions are permanently denied, we cannot request permissions.';
      return false;
    } else {
      locationPermissionsMessage = 'Location permissions are allowed';
      return true;
    }
  }

  var address = '';
  getAddressFromLatLng(Position position) async {
    address = '';
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address =
          '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    }).catchError((e) {
      address = "Something went wrong, Please tray again!";
    });
  }

  getCurrentGPSLocation(bool isAddressRequired) async {
    if (await checkServiceEnabled()) {
      if (await checkLocationPermissions()) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        var currentPossition = jsonDecode(jsonEncode(position).toString());
        if (isAddressRequired) {
          await getAddressFromLatLng(position);
          currentPossition['address'] = address;
        }
        return jsonEncode(currentPossition).toString();
      } else {
        return locationPermissionsMessage;
      }
    } else {
      return 'Location services are disabled. Please enable the services';
    }
  }
}
