import 'dart:math';

import 'package:watch_app/states_rebuilderTest/data/model/weather.dart';


abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);
}

class FakeWeatherRepo extends WeatherRepository {
  @override
  Future<Weather> fetchWeather(String cityName) {
    final random = Random();

    //Simulate some network exception
    if (random.nextBool()) throw NetworkException();
    
    return Future.delayed(
      Duration(seconds: 1),
      () {
        final random = Random();

        //Simulate some network exception
        if (random.nextBool()) throw NetworkException();

        return Weather(
          cityName: cityName,
          temperatureCelsius: 20 + random.nextInt(35) + random.nextDouble(),
        );
      },
    );
  }
}

class NetworkException implements Exception {}
