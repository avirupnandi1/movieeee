

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/models/user_address_model.dart';

class SplashScrn extends StatefulWidget {
  const SplashScrn({super.key});

  @override
  State<SplashScrn> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScrn> {
  @override
  void initState() {
    route();
    super.initState();
  }

  route() async {
    // await Future.delayed(const Duration(seconds: 2));
    Position? userLocation =
        await _determinePosition().onError((error, stackTrace) => null);
    UserAddressModel? userAddress;
    try {
      if (userLocation != null) {
        Placemark placemark = (await placemarkFromCoordinates(
            userLocation.latitude, userLocation.longitude))[0];
        String mainAdress =
            (placemark.street ?? placemark.name ?? placemark.country) ?? '';
        String secondaryAddress =
            ("${((placemark.thoroughfare?.isEmpty ?? true) ? placemark.subThoroughfare : placemark.thoroughfare)!}, ${((placemark.subLocality?.isEmpty ?? true) ? placemark.locality : placemark.subLocality)!}");
        if (mainAdress.isNotEmpty && secondaryAddress.isNotEmpty) {
          userAddress = UserAddressModel(mainAdress, secondaryAddress);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    userAddress ??= UserAddressModel("Unknown", "Unable to fetch location");
// ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/dashboard',
        arguments: userAddress);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position?> _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.circular(240),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: const CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
           const Positioned(
  child: CircleAvatar(
    radius: 40,
    backgroundImage: AssetImage('assets/we1.jpg'),
  ),
)
          ],
        ),
      ),
    );
  }
}