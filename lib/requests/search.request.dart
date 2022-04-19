import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/search.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/models/vendor.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/services/http.service.dart';
import 'package:fuodz/services/location.service.dart';

class SearchRequest extends HttpService {
  //
  Future<List<dynamic>> searchRequest({
    String keyword = "",
    Search search,
    int page = 1,
  }) async {
    //
    Map<String, dynamic> params = {
      "merge": "1",
      "page": page,
      "keyword": keyword,
      "category_id": search.category != null ? search.category.id : '',
      "vendor_type_id": search.vendorType != null ? search.vendorType.id : "",
      "vendor_id": search.vendorId != null ? search.vendorId : "",
      "type": search.type,
    };

    //
    if (search.byLocation) {
      params = {
        ...params,
        "latitude": LocationService?.currenctAddress?.coordinates?.latitude,
        "longitude": LocationService?.currenctAddress?.coordinates?.longitude,
      };
    }

    print("params ==> $params");
    final apiResult = await get(Api.search, queryParameters: params);
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      //
      List<dynamic> result = [];
      //
      result = (apiResponse.data).map(
        (jsonObject) {
          dynamic model;
          if (search.type == 'product') {
            model = Product.fromJson(jsonObject);
          } else if (search.type == "vendor") {
            model = Vendor.fromJson(jsonObject);
          } else if (search.type == "service") {
            model = Service.fromJson(jsonObject);
          } else {
            model = Product.fromJson(jsonObject);
          }
          return model;
        },
      ).toList();
      return result;
    }

    throw apiResponse.message;
  }
}
