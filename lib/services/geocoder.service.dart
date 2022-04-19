import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/models/coordinates.dart';
import 'package:fuodz/services/http.service.dart';
import 'package:singleton/singleton.dart';

export 'package:fuodz/models/address.dart';
export 'package:fuodz/models/coordinates.dart';

class GeocoderService extends HttpService {
//
  /// Factory method that reuse same instance automatically
  factory GeocoderService() =>
      Singleton.lazy(() => GeocoderService._()).instance;

  /// Private constructor
  GeocoderService._() {}

  Future<List<Address>> findAddressesFromCoordinates(
    Coordinates coordinates,
  ) async {
    //
    final apiKey = AppStrings.googleMapApiKey;
    final apiResult = await getExternal(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.toString()}&key=$apiKey",
    );
    //
    if (apiResult.statusCode == 200) {
      //
      Map<String, dynamic> apiResponse = apiResult.data;
      return (apiResponse["results"] as List).map((e) {
        return Address().fromMap(e);
      }).toList();
    }
    return [];
  }

  Future<Address> findAddressesFromQuery(String address) async {
    return null;
  }
}
