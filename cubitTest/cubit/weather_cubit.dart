import 'package:bloc/bloc.dart';
import 'package:watch_app/cubitTest/data/model/weather.dart';
import 'package:watch_app/cubitTest/data/model/weather_repository.dart';
import 'package:equatable/equatable.dart';
part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState>  {
  final WeatherRepository _weatherRepository;
  

  WeatherCubit(this._weatherRepository) : super(WeatherInitial());

  Future<void> getWeather(String cityName) async {
    try {
      emit(WeatherLoading());
      final weather = await _weatherRepository.fetchWeather(cityName);
      emit(WeatherLoaded(weather));
    } on NetworkException {
      emit(WeatherError("Couldn't fetch weather. Is the device online?"));
    }
  }
}
