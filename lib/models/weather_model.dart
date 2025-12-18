class WeatherRecord {
  final String cityName;
  final double temperature;
  final String description;
  final double windSpeedMs;
  final DateTime timestamp;

  WeatherRecord({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.windSpeedMs,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'description': description,
      'windSpeedMs': windSpeedMs,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static WeatherRecord fromJson(Map<String, dynamic> json) {
    return WeatherRecord(
      cityName: json['cityName'],
      temperature: (json['temperature'] as num).toDouble(),
      description: json['description'],
      windSpeedMs: (json['windSpeedMs'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ConversionRecord {
  final double inputValue;
  final String inputUnit;
  final double outputValue;
  final String outputUnit;
  final DateTime timestamp;

  ConversionRecord({
    required this.inputValue,
    required this.inputUnit,
    required this.outputValue,
    required this.outputUnit,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'inputValue': inputValue,
      'inputUnit': inputUnit,
      'outputValue': outputValue,
      'outputUnit': outputUnit,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static ConversionRecord fromJson(Map<String, dynamic> json) {
    return ConversionRecord(
      inputValue: (json['inputValue'] as num).toDouble(),
      inputUnit: json['inputUnit'],
      outputValue: (json['outputValue'] as num).toDouble(),
      outputUnit: json['outputUnit'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}