import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../nasa_insight_model.dart';
import '../../requests/nasa_api.dart';

@immutable
abstract class NasaWeatherState {}

class NasaWeatherInitial extends NasaWeatherState {}

class NasaWeatherLoading extends NasaWeatherState {}

class NasaWeatherLoaded extends NasaWeatherState {
  final InsightWeather weatherData;
  
  NasaWeatherLoaded(this.weatherData);
}

class NasaWeatherError extends NasaWeatherState {
  final String message;
  
  NasaWeatherError(this.message);
}

class NasaWeatherCubit extends Cubit<NasaWeatherState> {
  NasaWeatherCubit() : super(NasaWeatherInitial());
  
  Future<void> loadWeatherData() async {
    emit(NasaWeatherLoading());
    
    try {
      final weatherData = await NasaApi.getMarsWeather();
      emit(NasaWeatherLoaded(weatherData));
    } catch (e) {
      emit(NasaWeatherError('Не удалось загрузить данные: $e'));
    }
  }
  
  void reset() {
    emit(NasaWeatherInitial());
  }
}