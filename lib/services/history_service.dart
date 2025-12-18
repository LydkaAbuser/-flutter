import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/weather_model.dart';

class HistoryService {
  static const String _weatherKey = 'weather_history';
  static const String _conversionKey = 'conversion_history';
  static const int _maxHistoryLength = 20;

  Future<void> saveWeatherRecord(WeatherRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_weatherKey) ?? [];
    
    history.insert(0, jsonEncode(record.toJson()));
    
    if (history.length > _maxHistoryLength) {
      history = history.sublist(0, _maxHistoryLength);
    }
    
    await prefs.setStringList(_weatherKey, history);
  }

  Future<List<WeatherRecord>> getWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_weatherKey) ?? [];
    
    return history.map((jsonString) {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return WeatherRecord.fromJson(data);
    }).toList();
  }

  Future<void> clearWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherKey);
  }

  Future<void> saveConversionRecord(ConversionRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_conversionKey) ?? [];
    
    history.insert(0, jsonEncode(record.toJson()));
    
    if (history.length > _maxHistoryLength) {
      history = history.sublist(0, _maxHistoryLength);
    }
    
    await prefs.setStringList(_conversionKey, history);
  }

  Future<List<ConversionRecord>> getConversionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_conversionKey) ?? [];
    
    return history.map((jsonString) {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return ConversionRecord.fromJson(data);
    }).toList();
  }

  Future<void> clearConversionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_conversionKey);
  }
}