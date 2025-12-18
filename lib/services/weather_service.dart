import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
 
  static const String _apiKey = 'zpka_b5d715accea9465a9256516c3a9b8529_fd4f29f2';
  
  
  static const String _baseUrl = 'https://dataservice.accuweather.com';
  

  static Future<String> _getLocationKey(String cityName) async {
    final url = Uri.parse(
      '$_baseUrl/locations/v1/cities/search?apikey=$_apiKey&q=$cityName&language=ru-ru'
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0]['Key'] as String;
        } else {
          throw Exception('Город "$cityName" не найден');
        }
      } else {
        throw Exception('Ошибка получения location key: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }


  static Future<Map<String, dynamic>> fetchWeather(String cityName) async {
    try {
     
      final locationKey = await _getLocationKey(cityName);
      
   
      final weatherUrl = Uri.parse(
        '$_baseUrl/currentconditions/v1/$locationKey?apikey=$_apiKey&language=ru-ru&details=true'
      );
      
      final response = await http.get(weatherUrl);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          // Добавляем имя города и location key в данные
          final weatherData = data[0];
          weatherData['cityName'] = cityName;
          weatherData['locationKey'] = locationKey;
          return weatherData;
        } else {
          throw Exception('Данные о погоде для "$cityName" не найдены');
        }
      } else {
        throw Exception('Ошибка получения погоды: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Парсим ответ AccuWeather
  static WeatherRecord parseWeatherResponse(Map<String, dynamic> data, String cityName) {
    final temperature = data['Temperature']['Metric']['Value'];
    final weatherText = data['WeatherText'];
    final windSpeed = data['Wind']['Speed']['Metric']['Value'];
    
    return WeatherRecord(
      cityName: cityName,
      temperature: temperature,
      description: weatherText,
      windSpeedMs: windSpeed, 
      timestamp: DateTime.now(),
    );
  }
}