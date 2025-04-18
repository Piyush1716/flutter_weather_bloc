import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


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
              Align(
                alignment: AlignmentDirectional(3, -.3),
                child: Container(
                  height: 350,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple, shape: BoxShape.circle),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-3, -.3),
                child: Container(
                  height: 350,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple, shape: BoxShape.circle),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 350,
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 115, 9),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
              ),

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
                        Text(
                          '${weather.areaName}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          'Good Moring',
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

class small_widget extends StatelessWidget {
  final String imgPath;
  final String top;
  final String bottom;

  const small_widget({
    super.key,
    required this.imgPath, 
    required this.top, 
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imgPath,
          width: 60,
          height: 60,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${top}',
              style: TextStyle(color: Colors.white24, fontSize: 15),
            ),
            Text(
              '${bottom}',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        )
      ],
    );
  }
}
