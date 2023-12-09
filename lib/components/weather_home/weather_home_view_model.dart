import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myweather/model/weather.dart';
import 'package:myweather/service/weather_service.dart';

class WeatherHomeViewModel {
  String? cityName;
  Weather? weatherData;
  bool pageLoader = true;
  TextEditingController textController = TextEditingController();
  StreamController streamController = StreamController.broadcast();
  getWeatherDetails()async{
    Weather? res = await   WeatherService.shared.getWeatherForCity(textController.text);
    if(res != null){
      weatherData = res;
    }
    pageLoader = false;
    streamController.add(DateTime.now().toIso8601String());
  }
}