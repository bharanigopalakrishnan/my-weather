import 'dart:convert';

import 'package:myweather/model/config.dart';
import 'package:myweather/model/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static WeatherService shared = WeatherService();

  Future<Weather?> getWeatherForCity(String city) async {
    var url = Uri.https(
      'http://api.weatherapi.com/v1/forecast.json?key=${AppConfig.shared.weatherKey}&q=$city&days=7&aqi=no&alerts=no',
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
