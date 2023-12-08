import 'dart:developer';

import 'package:myweather/model/weather.dart';
import 'package:myweather/service/weather_service.dart';

class WeatherHomeViewModel {
  String? cityName;
  

  getWeatherDetails()async{
    Weather? res = await   WeatherService.shared.getWeatherForCity(cityName!);
    inspect(res);
  }
}
