import 'dart:convert';

import 'package:covid_tracker/Model/world_states_model.dart';
import 'package:covid_tracker/Services/util/app_url.dart';
import 'package:http/http.dart' as http;

class WorldStateService {
  Future<WorldStatesModel> fetchWorldStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStateApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception('Error');
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Assuming the response is a list of countries
      return data;
    } else {
      throw Exception('Error');
    }
  }
}
