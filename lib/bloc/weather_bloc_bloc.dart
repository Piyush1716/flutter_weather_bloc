import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/api_key.dart';

part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<WeatherFetchEvent>((event, emit) async{
      emit(WeatherBlocLoading());
      try{
        double lat = event.pos.latitude;
        double lon = event.pos.longitude;
        String key = api_key;
        WeatherFactory wf = WeatherFactory(key);

        // Weather weather = await wf.currentWeatherByCityName(cityName);
        Weather weather = await wf.currentWeatherByLocation(lat, lon);
        print("weather");
        print(weather);
        print("Position");
        print(event.pos);

        emit(WeatherBlocSuccess(weather));
      }catch(e){
        emit(WeatherBlocFailure());
      }
    });
  }
}
