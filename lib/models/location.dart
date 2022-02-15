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
      print('latitude: $latitude');
      print('longitude: $longitude');
      LocalStorage.storeDouble('latitude', latitude);
      LocalStorage.storeDouble('longitude', longitude);
    } catch (e) {
      print(e);
      setDataFromLocalStorage();
    }
  }

  Future<void> setDataFromLocalStorage() async {
    latitude = await LocalStorage.get('latitude') ?? 0.0;
    longitude = await LocalStorage.get('longitude') ?? 0.0;
  }
}
