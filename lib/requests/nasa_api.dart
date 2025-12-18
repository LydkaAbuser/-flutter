import 'dart:convert';
import 'package:http/http.dart' as http;
import '../nasa_insight_model.dart';

class NasaApi {
  static const String _baseUrl = 'https://api.nasa.gov/insight_weather/';
  static const String _apiKey = 'b0cYvEv7ks3xWlIPYjy6NOtSexNglwsBe5gxs90d';
  
  static Future<InsightWeather> getMarsWeather() async {
    final uri = Uri.parse('$_baseUrl?api_key=$_apiKey&feedtype=json&ver=1.0');
    
    try {
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return InsightWeather.fromJson(jsonData);
      } else {
        throw Exception('Ошибка API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }
  
  static Future<SolData?> getSolWeather(String solKey) async {
    try {
      final weather = await getMarsWeather();
      return weather.solData[solKey];
    } catch (e) {
      throw Exception('Ошибка получения данных для сола $solKey: $e');
    }
  }
}