import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watch_app/cubitTest/cubit/weather_cubit.dart';
import 'package:watch_app/cubitTest/data/model/weather.dart';
import 'package:watch_app/cubitTest/data/model/weather_repository.dart';

class CubitWeatherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocProvider(
        create: (context) => WeatherCubit(
          FakeWeatherRepo(),
        ),
        child: WeatherSearchPage(),
      ),
    );
  }
}

class WeatherSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cubit_Weather Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<WeatherCubit, WeatherState>(
            listener: (context, state) {
          if (state is WeatherError) {
            showSncakBar(context, state.message);
          }
          if (state is WeatherLoaded) {
            showSncakBar(context, 'Got Done');
          }
        }, builder: (context, state) {
          if (state is WeatherInitial)
            return buildInitialInput();
          else if (state is WeatherLoading)
            return buildLoading();
          else if (state is WeatherLoaded)
            return buildColumnWithData(state.weather);
          else
            return buildInitialInput(); // (state is WeatherError)
        }),
      ),
    );
  }

  showSncakBar(BuildContext context, String title) {
    Scaffold.of(context).hideCurrentSnackBar();
     Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (val) => submitCityName(context, val),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Enter a city',
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    final weatherCubit = context.bloc<WeatherCubit>();
    weatherCubit.getWeather(cityName);
  }
}
