import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import 'package:weather_app/screens/forecasting_page.dart';
import 'package:weather_app/ui/helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String getGreeting(int hour) {

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
  String getWeatherImage(int code){
    switch(code){
      case >=200 && <300:
        return "assets/1.png";
      case >=300 && <400:
        return "assets/2.png";
      case >=500 && <600:
        return "assets/3.png";
      case >=600 && <700:
        return "assets/4.png";
      case >=700 && <800:
        return "assets/5.png";
      case == 800:
        return 'assets/6.png';
      case >800 && <=804:
        return "assets/7.png";
      default:
        return "assets/1.png";
    }
  }

  Future<void> _refresh(String city) async {
    Position pos = await _determinePosition();
    context.read<WeatherBlocBloc>().add(WeatherFetchByCityEvent(city));
  }

  void _enterCity(BuildContext context){
    final TextEditingController _city_ctrl = TextEditingController();
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Search By City"),
          content: TextField(
            controller: _city_ctrl,
            decoration: InputDecoration(hintText: "Enter City"),
          ),
          actions: [
            TextButton(onPressed: ()=> Navigator.of(context).pop(), child: Text("Cancel")),
            TextButton(onPressed: (){
                Navigator.of(context).pop();
                _refresh(_city_ctrl.text.toString());
              }, 
              child: Text("Ok")
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   systemOverlayStyle:
      //       const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      // ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              BlurryBackground(),
              BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                builder: (context, state) {
                  if(state is WeatherBlocLoading){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(state is WeatherBlocInitial){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(state is WeatherBlocSuccess ){
                    final Weather weather = state.weather;
                    return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${weather.areaName}',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w300),
                            ),
                            IconButton(
                                onPressed: () => _enterCity(context),
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                )),
                            IconButton(
                                onPressed: (){
                                  final String city = state.weather.areaName ?? 'Anand';
                                  Navigator.push(context, MaterialPageRoute(
                                    builder:(context) => BlocProvider.value(value: context.read<WeatherBlocBloc>(),child: ForeCast(city: city,),)
                                  ));
                                },
                                icon: Icon(
                                  Icons.thunderstorm,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        Text(
                          getGreeting(weather.date!.hour),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Center(
                          child: Image.asset(
                              width: 275, height: 275, getWeatherImage(weather.weatherConditionCode!)),
                        ),
                        Center(
                          child: Text(
                            '${weather.temperature!.celsius!.round()}°C',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Center(
                          child: Text(
                            weather.weatherMain!.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Center(
                          child: Text(
                            '${DateFormat('EEEE d . h:mm a').format(weather.date!)}',
                            style: TextStyle(
                                color: Colors.white24,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                small_widget(
                                  imgPath: 'assets/11.png',
                                  top: 'Sunrise',
                                  bottom: DateFormat('h:mm a').format(weather.sunrise!),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                small_widget(
                                  imgPath: 'assets/12.png',
                                  top: 'Sunset',
                                  bottom: DateFormat('h:mm a').format(weather.sunset!),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Divider(color: Colors.grey[800]),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                small_widget(
                                  imgPath: 'assets/13.png',
                                  top: 'Temp Max',
                                  bottom: '${weather.tempMax!.celsius!.round()}°C',
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                small_widget(
                                  imgPath: 'assets/14.png',
                                  top: 'Temp Min',
                                  bottom: '${weather.tempMin!.celsius!.round()}°C',
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                  }
                  else{
                    return Center(
                      child: Text("Error Occured"),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}





/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}