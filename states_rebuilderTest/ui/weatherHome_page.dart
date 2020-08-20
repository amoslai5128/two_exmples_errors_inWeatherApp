import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../data/model/weather.dart';
import '../data/model/weather_repository.dart';
import '../service/weather_state.dart';

class StateRebuilderWeatherHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Injector(inject: [
        //Injecting Asset Stream
        Inject(
          () => WeatherState(
            weather: Weather(),
            weatherRepository: FakeWeatherRepo(),
          ),
        ),
      ], builder: (context) => WeatherSearchPage()),
    );
  }
}

class WeatherSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StatesRebuilder_Weather Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: WhenRebuilder<WeatherState>(
          observe: () => RM.get<WeatherState>(),
       
          onWaiting: () => CircularProgressIndicator(),
          onIdle: () => buildInitialInput(),
          onData: (data) => buildColumnWithData(data.weather),
          onError: (err) => buildInitialInput(),
        ),
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

  showSncakBar(String title) {
   RM.scaffold.hideCurrentSnackBar();
    RM.scaffold.showSnackBar(SnackBar(content: Text('$title')));
  }

  void submitCityName(BuildContext context, String cityName) async {
    final weatherRM = RM.get<WeatherState>();
    await weatherRM.setState((s) => WeatherState.getWeather(s, cityName),
        onError: (context, err) => showSncakBar(err.message.toString()));
  }
}
