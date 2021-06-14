
import 'package:geocoder/geocoder.dart';
Future getSearchLocationCoordinates(query) async {
  var addresses = await Geocoder.local.findAddressesFromQuery(query);
  Coordinates coordinates =addresses.first.coordinates;
  return coordinates;
}
