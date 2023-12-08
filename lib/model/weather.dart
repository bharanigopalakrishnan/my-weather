class Weather {
  ForeCast? forecast;

  Weather({this.forecast});

  factory Weather.fromJson(json) {
    return Weather(
        forecast: json["forecast"] != null
            ? ForeCast.fromJson(json["forecast"])
            : null);
  }

  Weather createInstance(json) {
    return Weather.fromJson(json);
  }
}

class ForeCast {
  List<ForeCastDay>? forecastday;

  ForeCast({this.forecastday});

  factory ForeCast.fromJson(json) {
    return ForeCast(
        forecastday: json["forecastday"] != null
            ? serialize(json["forecastday"])
            : null);
  }
  ForeCastDay createInstance(json) {
    return ForeCastDay.fromJson(json);
  }
}

class ForeCastDay {
  String? date;
  WeatherDetails? day;

  ForeCastDay({this.date, this.day});
  factory ForeCastDay.fromJson(json) {
    return ForeCastDay(
        date: json["date"],
        day: json["day"] != null ? WeatherDetails.fromJson(json["day"]) : null);
  }
  ForeCastDay createInstance(json) {
    return ForeCastDay.fromJson(json);
  }
}

class WeatherDetails {
  double? maxtemp_c;
  double? mintemp_c;
  double? avgtemp_c;
  double? maxwind_kph;
  int? daily_will_it_rain;
  int? daily_chance_of_rain;
  WeatherDetails(
      {this.avgtemp_c,
      this.daily_chance_of_rain,
      this.daily_will_it_rain,
      this.maxtemp_c,
      this.maxwind_kph,
      this.mintemp_c});

  factory WeatherDetails.fromJson(json) {
    return WeatherDetails(
        avgtemp_c: json["avgtemp_c"],
        maxtemp_c: json["maxtemp_c"],
        mintemp_c: json["mintemp_c"],
        maxwind_kph: json["maxwind_kph"],
        daily_will_it_rain: json["daily_will_it_rain"],
        daily_chance_of_rain: json["daily_chance_of_rain"]);
  }

  WeatherDetails createInstance(json) {
    return WeatherDetails.fromJson(json);
  }
}

List<ForeCastDay> serialize(dynamic data) {
  List<ForeCastDay> tempList = [];
  List<dynamic> result = data;
  if (result.isNotEmpty) {
    for (var i = 0; i < result.length; i++) {
      ForeCastDay temp = ForeCastDay.fromJson(result[i]);
      tempList.add(temp);
    }
  }
  return tempList;
}
