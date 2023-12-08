class AppConfig {
  static AppConfig shared = AppConfig();

  String? weatherKey;

  AppConfig({this.weatherKey});

  factory AppConfig.fromJson(json) {
    return AppConfig(weatherKey: json["apiKey"]);
  }

  AppConfig createInstance(json) {
    return AppConfig.fromJson(json);
  }
}
