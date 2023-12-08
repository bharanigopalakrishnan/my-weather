import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myweather/components/weather_home/weather_home.dart';
import 'package:myweather/components/weather_home/weather_home_view_model.dart';

class WeatherHomeView extends State<WeatherHome> {
  late WeatherHomeViewModel _viewModel;
  WeatherHomeView() {
    _viewModel = WeatherHomeViewModel();
  }
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _viewModel.cityName = placemarks.first.locality ?? "Unknown";
        _viewModel.getWeatherDetails();
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User City Name'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: borderDecoration("Location"),
            ),
            Text('User City Name: ${_viewModel.cityName}'),
          ],
        ),
      ),
    );
  }

  InputDecoration borderDecoration(String? label,
      {Widget? suffixIcon,
      Widget? prefixIcon,
      String? hint,
      String? prefixText,
      bool isEnable = false,
      InputBorder? borderCustom,
      InputBorder? focusedBorderCustom,
      EdgeInsetsGeometry? contentPaddingCustom}) {
    return InputDecoration(
      prefixText: prefixText,
      prefixStyle: TextStyle(fontSize: 16),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding:
          contentPaddingCustom != null ? contentPaddingCustom : null,
      border: isEnable
          ? null
          : borderCustom != null
              ? borderCustom
              : OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
      focusedBorder: isEnable
          ? null
          : focusedBorderCustom != null
              ? focusedBorderCustom
              : OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      labelText: label,
      labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
      alignLabelWithHint: true,
      hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
    );
  }
}
