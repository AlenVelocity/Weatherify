import 'package:geolocator/geolocator.dart';
import 'local_storage.dart';

class Location {
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> setCurrentLocation() async {
    bool isGPSEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isGPSEnabled) {
      await setDataFromLocalStorage();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      latitude = position.latitude;
      longitude = position.longitude;
      store('latitude', latitude);
      store('longitude', longitude);
    } catch (e) {
      setDataFromLocalStorage();
    }
  }

  Future<void> setDataFromLocalStorage() async {
    latitude = await get<double>('latitude');
    longitude = await get<double>('longitude');
  }
}
