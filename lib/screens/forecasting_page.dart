import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import 'package:weather_app/ui/helper.dart';

class ForeCast extends StatefulWidget {
  String city;
  ForeCast({required this.city});

  @override
  State<ForeCast> createState() => _ForeCastState();
}

class _ForeCastState extends State<ForeCast> {
  void initState() {
    super.initState();
    context
        .read<WeatherBlocBloc>()
        .add(WeatherFetchFiveDaysForecast(city: widget.city));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2e335a),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // BlurryBackground(),
              BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                builder: (context, state){
                  if(state is WeatherBlocLoading){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  else if(state is FiveDayForeCastSuccess){
                    return ListView.builder(
                      itemCount: state.fiveDayForecast.length,
                      itemBuilder: (context, index){
                        return WeatherCard(wether: state.fiveDayForecast[index],);
                      }
                    );
                  }
                  else{
                    return Center(child: CircularProgressIndicator(),);
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


class WeatherCard extends StatelessWidget {
  final Weather wether;
  const WeatherCard({super.key, required this.wether});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ClipPath(
        clipper: WeatherCardClipper(),
        child: Container(
          width: double.infinity,
          height: 190,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5936B4), Color(0xFF362a84)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left - Temperature & location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${wether.temperature!.celsius!.round()}°C',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('H:16°  L:8°', style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 16),
                    Text('${wether.areaName}',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
              // Right - Icon and text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/1.png', width: 90), // Use your asset
                  const SizedBox(height: 8),
                  Text(wether.weatherDescription! , style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class WeatherCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from bottom-right with rounded corner
    path.moveTo(size.width, size.height - 30);
    path.quadraticBezierTo(size.width, size.height, size.width - 30, size.height);

    // Bottom-left corner
    path.lineTo(30, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 30);

    // Top-left corner
    path.lineTo(0, 30);
    path.quadraticBezierTo(0, 0, 30, 0);

    // Top-right slanted downward
    path.lineTo(size.width - 80, size.height * 0.15);
    path.quadraticBezierTo(size.width, size.height * 0.2, size.width, size.height * 0.3);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
