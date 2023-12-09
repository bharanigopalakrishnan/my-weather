import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:myweather/components/weather_home/weather_home.dart';
import 'package:myweather/components/weather_home/weather_home_view_model.dart';
import 'package:myweather/controllers/userController.dart';
import 'package:myweather/model/weather.dart';
import 'package:myweather/service/auth.dart';
import 'package:provider/provider.dart';

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
        _viewModel.textController.text = _viewModel.cityName!;
        _viewModel.getWeatherDetails();
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        _viewModel.pageLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.streamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Your weather',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                GestureDetector(
                  onTap: () async {
                     AuthService.shared.signOut();
    Provider.of<UserController>(context, listen: false).updateUser(null);

                    Navigator.popAndPushNamed(context, "/login");
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      "Sign out",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextField(
                      controller: _viewModel.textController,
                      decoration: borderDecoration("Location",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _viewModel.pageLoader = true;
                                _viewModel.getWeatherDetails();
                              });
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.lightGreen,
                                    borderRadius: BorderRadius.circular(6)),
                                child: const Icon(
                                  Icons.search_sharp,
                                  color: Colors.white,
                                )),
                          )),
                    ),
                  ),
                  _viewModel.pageLoader
                      ? const Column(
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            Center(
                                child: CircularProgressIndicator(
                              color: Colors.greenAccent,
                            )),
                          ],
                        )
                      : _viewModel.weatherData?.forecast?.forecastday != null
                          ? Expanded(
                              child: PageView.builder(
                                  itemCount: _viewModel.weatherData!.forecast!
                                      .forecastday!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: ((context, index) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 70,
                                          ),
                                          weatherCard(_viewModel.weatherData!
                                              .forecast!.forecastday![index]),
                                        ],
                                      ),
                                    );
                                  })))
                          : const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No weather data found",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  ),
                                ],
                              ),
                            )
                ],
              ),
            ),
          );
        });
  }

  InputDecoration borderDecoration(
    String? label, {
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? hint,
    String? prefixText,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(right: 20, top: 20, left: 20, bottom: 20),
      prefixText: prefixText,
      prefixStyle: TextStyle(fontSize: 16),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
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

  Widget weatherCard(ForeCastDay data) {
    return Container(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3)
            ]),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.amberAccent.withOpacity(0.2),
              padding: EdgeInsets.only(top: 25, bottom: 25, left: 25),
              child: Text(
                data.date == DateFormat("yyyy-MM-dd").format(DateTime.now())
                    ? "Today"
                    : (data.date ?? "Unknown"),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  border: Border.all(color: Colors.blueAccent)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                const TextSpan(
                                    text: "Max Temp : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: "${data.day?.maxtemp_c ?? "0"} °C",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ])),
                        ),
                        Expanded(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                const TextSpan(
                                    text: "Min Temp : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: "${data.day?.mintemp_c ?? "0"} °C",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ])),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 25),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "Avg Temp : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: "${data.day?.avgtemp_c ?? "0"} °C",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                        ])),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                const TextSpan(
                                    text: "Max wind : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        "${data.day?.maxwind_kph ?? "0"} kmph",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ])),
                        ),
                        Expanded(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                const TextSpan(
                                    text: "Rain chance : ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        "${((data.day?.daily_will_it_rain ?? 0) * 100)} %",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ])),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
