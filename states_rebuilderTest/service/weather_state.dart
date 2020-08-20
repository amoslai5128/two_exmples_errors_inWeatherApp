import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:watch_app/states_rebuilderTest/data/model/weather.dart';
import 'package:watch_app/states_rebuilderTest/data/model/weather_repository.dart';

import 'exception/weather.dart';

@immutable
class WeatherState extends Equatable {
  final WeatherRepository _weatherRepository;
  final Weather _weather;

  //Public getter
  Weather get weather => _weather;

  WeatherState({
    WeatherRepository weatherRepository,
    Weather weather,
  })  : _weatherRepository = weatherRepository,
        _weather = weather;

  static Future<WeatherState> getWeather(
      WeatherState state, String cityName) async {
    try {
      final _newWeather = await state._weatherRepository.fetchWeather(cityName);
      return state.copyWith(weather: _newWeather);
    } catch (e) {
      throw WeatherError("Couldn't fetch weather. Is the device online?");
    }
  }

  @override
  List<Object> get props => [_weatherRepository, _weather];

  WeatherState copyWith({
    WeatherRepository weatherRepository,
    Weather weather,
  }) {
    return WeatherState(
      weatherRepository: weatherRepository ?? _weatherRepository,
      weather: weather ?? _weather,
    );
  }
}
