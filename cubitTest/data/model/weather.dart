import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperatureCelsius;
  
  Weather({
    this.cityName,
    this.temperatureCelsius,
  });

  @override
  List<Object> get props => [cityName, temperatureCelsius];

 
}
