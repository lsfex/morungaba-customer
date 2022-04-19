import 'coordinates.dart';

class Address {
  /// The geographic coordinates.
  final Coordinates coordinates;

  /// The formatted address with all lines.
  final String addressLine;

  /// The localized country name of the address.
  final String countryName;

  /// The country code of the address.
  final String countryCode;

  /// The feature name of the address.
  final String featureName;

  /// The postal code.
  final String postalCode;

  /// The administrative area name of the address
  final String adminArea;

  /// The sub-administrative area name of the address
  final String subAdminArea;

  /// The locality of the address
  final String locality;

  /// The sub-locality of the address
  final String subLocality;

  /// The thoroughfare name of the address
  final String thoroughfare;

  /// The sub-thoroughfare name of the address
  final String subThoroughfare;

  Address(
      {this.coordinates,
      this.addressLine,
      this.countryName,
      this.countryCode,
      this.featureName,
      this.postalCode,
      this.adminArea,
      this.subAdminArea,
      this.locality,
      this.subLocality,
      this.thoroughfare,
      this.subThoroughfare});

  /// Creates an address from a map containing its properties.
  Address fromMap(Map map) {
    return new Address(
      coordinates: new Coordinates.fromMap(map["geometry"]["location"]),
      addressLine: map['formatted_address'],
      //map["addressLine"],
      countryName: getTypeFromAddressComponents("country", map),
      //map["countryName"],
      countryCode: getTypeFromAddressComponents(
        "country",
        map,
        nameTye: "short_name",
      ),
      //map["countryCode"],
      featureName: getTypeFromAddressComponents("formatted_address", map),
      //map["featureName"],
      postalCode: getTypeFromAddressComponents("postal_code", map),
      //map["postalCode"],
      locality: getTypeFromAddressComponents("locality", map),
      //map["locality"],
      subLocality: getTypeFromAddressComponents("sublocality", map),
      //map["subLocality"],
      adminArea:
          getTypeFromAddressComponents("administrative_area_level_1", map),
      //map["adminArea"],
      subAdminArea:
          getTypeFromAddressComponents("administrative_area_level_2", map),
      //map["subAdminArea"],
      thoroughfare: getTypeFromAddressComponents("thorough_fare", map),
      //map["thoroughfare"],
      subThoroughfare: getTypeFromAddressComponents("sub_thorough_fare", map),
      //map["subThoroughfare"],
    );
  }

  /// Creates a map from the address properties.
  Map toMap() => {
        "coordinates": this.coordinates.toMap(),
        "addressLine": this.addressLine,
        "countryName": this.countryName,
        "countryCode": this.countryCode,
        "featureName": this.featureName,
        "postalCode": this.postalCode,
        "locality": this.locality,
        "subLocality": this.subLocality,
        "adminArea": this.adminArea,
        "subAdminArea": this.subAdminArea,
        "thoroughfare": this.thoroughfare,
        "subThoroughfare": this.subThoroughfare,
      };

  //
  String getTypeFromAddressComponents(
    String type,
    Map searchResult, {
    String nameTye = "long_name",
  }) {
    //
    String result = "";
    //
    for (var componenet in (searchResult["address_components"] as List)) {
      final found = (componenet["types"] as List).contains(type);
      if (found) {
        //
        result = componenet[nameTye];
        break;
      }
    }
    return result;
  }
}
