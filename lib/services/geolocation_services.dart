import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:pocket_hrms/mixins/shared_preferences_mixin.dart';
import 'package:pocket_hrms/services/logging.dart';

class GeolocationServices with SharedPreferencesMixin {
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
    }).catchError((error, stackTrace) async {
      await LoggingService().logErrorToFile(error, stackTrace);
      address = "Something went wrong, Please tray again!";
    });
  }

  double vincentyDistance(
      Map<String, double> coord1, Map<String, double> coord2) {
    const double a = 6378137.0; // Major axis of the WGS-84 ellipsoid (meters)
    const double f = 1 / 298.257223563; // Flattening of the WGS-84 ellipsoid
    const double b =
        6356752.314245; // Minor axis of the WGS-84 ellipsoid (meters)

    double lat1 = coord1['lat']! * (math.pi / 180);
    double lon1 = coord1['lon']! * (math.pi / 180);
    double lat2 = coord2['lat']! * (math.pi / 180);
    double lon2 = coord2['lon']! * (math.pi / 180);

    double U1 = math.atan((1 - f) * math.tan(lat1));
    double U2 = math.atan((1 - f) * math.tan(lat2));
    double L = lon2 - lon1;

    double lambda = L;
    double lambdaP;
    int iterLimit = 100;
    double sinSigma, cosSigma, sigma, sinAlpha, cos2Alpha, cos2SigmaM, C;

    do {
      double sinLambda = math.sin(lambda);
      double cosLambda = math.cos(lambda);
      sinSigma = math.sqrt(
          (math.cos(U2) * sinLambda) * (math.cos(U2) * sinLambda) +
              (math.cos(U1) * math.sin(U2) -
                      math.sin(U1) * math.cos(U2) * cosLambda) *
                  (math.cos(U1) * math.sin(U2) -
                      math.sin(U1) * math.cos(U2) * cosLambda));
      if (sinSigma == 0) return 0; // Co-incident points
      cosSigma =
          math.sin(U1) * math.sin(U2) + math.cos(U1) * math.cos(U2) * cosLambda;
      sigma = math.atan2(sinSigma, cosSigma);
      sinAlpha = math.cos(U1) * math.cos(U2) * sinLambda / sinSigma;
      cos2Alpha = 1 - sinAlpha * sinAlpha;
      cos2SigmaM = cosSigma - 2 * math.sin(U1) * math.sin(U2) / cos2Alpha;
      C = f / 16 * cos2Alpha * (4 + f * (4 - 3 * cos2Alpha));
      lambdaP = lambda;
      lambda = L +
          (1 - C) *
              f *
              sinAlpha *
              (sigma +
                  C *
                      sinSigma *
                      (cos2SigmaM +
                          C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    } while ((lambda - lambdaP).abs() > 1e-12 && --iterLimit > 0);

    if (iterLimit == 0) return double.nan; // Formula failed to converge

    double u2 = cos2Alpha * (a * a - b * b) / (b * b);
    double A = 1 + u2 / 16384 * (4096 + u2 * (-768 + u2 * (320 - 175 * u2)));
    double B = u2 / 1024 * (256 + u2 * (-128 + u2 * (74 - 47 * u2)));
    double deltaSigma = B *
        sinSigma *
        (cos2SigmaM +
            B /
                4 *
                (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                    B /
                        6 *
                        cos2SigmaM *
                        (-3 + 4 * sinSigma * sinSigma) *
                        (-3 + 4 * cos2SigmaM * cos2SigmaM)));

    double s = b * A * (sigma - deltaSigma);

    return s / 1000; // Return distance in kilometers
  }

  static double maxSpeedThreshold = 50;
  calculateTravelledDistance(Position position) async {
    try {
      var oldPosition = await getValue("OLDGPSPOSITION");
      var PositionsList = await getValue("POSITIONSLIST");
      var SavedDistance = await getValue("DISTANCE");
      double distance = 0.0;
      List<Position> PositionsRecords = [];
      if (oldPosition != null) {
        Position lastPosition = json.decode(oldPosition.toString());

        var validatedDistance = Geolocator.distanceBetween(
          lastPosition.latitude,
          lastPosition.longitude,
          position.latitude,
          position.longitude,
        );

        final timeDifference = position.timestamp
            .difference(DateTime.fromMillisecondsSinceEpoch(
                lastPosition.timestamp as int))
            .inSeconds;

        final speed = validatedDistance / timeDifference;
        if (speed <= maxSpeedThreshold) {
          var newPos = {"lat": position.latitude, "lon": position.longitude};
          var oldPos = {
            "lat": lastPosition.latitude,
            "lon": lastPosition.longitude
          };
          var calculatedDistance = vincentyDistance(newPos, oldPos);
          if (SavedDistance != null) {
            distance = double.parse(SavedDistance);
            distance = distance + calculatedDistance;
          } else {
            distance = distance + calculatedDistance;
          }
        }
      }

      if (PositionsList != null) {
        PositionsRecords = json.decode(PositionsList);
        PositionsRecords.add(position);
      } else {
        PositionsRecords = [];
        PositionsRecords.add(position);
      }

      await saveValue(
          "POSITIONSLIST", json.encode(PositionsRecords).toString());
      await saveValue("DISTANCE", distance.toString());
      await saveValue("OLDGPSPOSITION", json.encode(position));
      String formattedDate = DateFormat('dd_MM_yyyy').format(DateTime.now());
      await LoggingService().saveContentInlocalFiles(
          "gps_locations",
          "trip_$formattedDate.txt",
          "${json.encode(position)} \n ${distance.toString()}");
    } catch (error, stackTrace) {
      await LoggingService().logErrorToFile(error, stackTrace);
    }
  }

  getCurrentGPSLocation(bool isAddressRequired, bool calculateDistance) async {
    if (await checkServiceEnabled()) {
      if (await checkLocationPermissions()) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        var currentPossition = jsonDecode(jsonEncode(position).toString());
        if (isAddressRequired) {
          await getAddressFromLatLng(position);
          currentPossition['address'] = address;
        }
        if (calculateDistance) {
          calculateTravelledDistance(position);
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
