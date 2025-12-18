class InsightWeather {
  final Map<String, SolData> solData;
  final List<String> solKeys;
  final ValidityChecks validityChecks;

  InsightWeather({
    required this.solData,
    required this.solKeys,
    required this.validityChecks,
  });

  factory InsightWeather.fromJson(Map<String, dynamic> json) {
    final solData = <String, SolData>{};
    
    final solKeys = List<String>.from(json['sol_keys'] ?? []);
    
    for (final key in solKeys) {
      if (json.containsKey(key)) {
        solData[key] = SolData.fromJson(json[key]);
      }
    }
    
    return InsightWeather(
      solData: solData,
      solKeys: solKeys,
      validityChecks: ValidityChecks.fromJson(json['validity_checks'] ?? {}),
    );
  }
}

class SolData {
  final TemperatureData at;
  final WindData hws;
  final PressureData pre;
  final WindDirectionData wd;
  final String firstUTC;
  final String lastUTC;
  final String season;
  final String northernSeason;
  final String southernSeason;
  final int monthOrdinal;

  SolData({
    required this.at,
    required this.hws,
    required this.pre,
    required this.wd,
    required this.firstUTC,
    required this.lastUTC,
    required this.season,
    required this.northernSeason,
    required this.southernSeason,
    required this.monthOrdinal,
  });

  factory SolData.fromJson(Map<String, dynamic> json) {
    return SolData(
      at: TemperatureData.fromJson(json['AT'] ?? {}),
      hws: WindData.fromJson(json['HWS'] ?? {}),
      pre: PressureData.fromJson(json['PRE'] ?? {}),
      wd: WindDirectionData.fromJson(json['WD'] ?? {}),
      firstUTC: json['First_UTC'] ?? '',
      lastUTC: json['Last_UTC'] ?? '',
      season: json['Season'] ?? '',
      northernSeason: json['Northern_season'] ?? '',
      southernSeason: json['Southern_season'] ?? '',
      monthOrdinal: json['Month_ordinal'] ?? 0,
    );
  }
  
  double get averageTemperatureCelsius => at.av;
  
  double get averageWindSpeed => hws.av;
  
  double get averagePressure => pre.av;
  
  WindDirection? get mostCommonWindDirection => wd.mostCommon;
}

class TemperatureData {
  final double av;
  final double mn;
  final double mx;
  final int ct;

  TemperatureData({
    required this.av,
    required this.mn,
    required this.mx,
    required this.ct,
  });

  factory TemperatureData.fromJson(Map<String, dynamic> json) {
    return TemperatureData(
      av: (json['av'] ?? 0.0).toDouble(),
      mn: (json['mn'] ?? 0.0).toDouble(),
      mx: (json['mx'] ?? 0.0).toDouble(),
      ct: (json['ct'] ?? 0).toInt(),
    );
  }
}

class WindData {
  final double av;
  final double mn;
  final double mx;
  final int ct;

  WindData({
    required this.av,
    required this.mn,
    required this.mx,
    required this.ct,
  });

  factory WindData.fromJson(Map<String, dynamic> json) {
    return WindData(
      av: (json['av'] ?? 0.0).toDouble(),
      mn: (json['mn'] ?? 0.0).toDouble(),
      mx: (json['mx'] ?? 0.0).toDouble(),
      ct: (json['ct'] ?? 0).toInt(),
    );
  }
}

class PressureData {
  final double av;
  final double mn;
  final double mx;
  final int ct;

  PressureData({
    required this.av,
    required this.mn,
    required this.mx,
    required this.ct,
  });

  factory PressureData.fromJson(Map<String, dynamic> json) {
    return PressureData(
      av: (json['av'] ?? 0.0).toDouble(),
      mn: (json['mn'] ?? 0.0).toDouble(),
      mx: (json['mx'] ?? 0.0).toDouble(),
      ct: (json['ct'] ?? 0).toInt(),
    );
  }
}

class WindDirectionData {
  final Map<String, WindDirection> directions;
  final WindDirection? mostCommon;

  WindDirectionData({
    required this.directions,
    this.mostCommon,
  });

  factory WindDirectionData.fromJson(Map<String, dynamic> json) {
    final directions = <String, WindDirection>{};
    WindDirection? mostCommon;
    
    json.forEach((key, value) {
      if (key != 'most_common') {
        directions[key] = WindDirection.fromJson(value);
      } else {
        mostCommon = WindDirection.fromJson(value);
      }
    });
    
    return WindDirectionData(
      directions: directions,
      mostCommon: mostCommon,
    );
  }
}

class WindDirection {
  final double compassDegrees;
  final String compassPoint;
  final double compassRight;
  final double compassUp;
  final int ct;

  WindDirection({
    required this.compassDegrees,
    required this.compassPoint,
    required this.compassRight,
    required this.compassUp,
    required this.ct,
  });

  factory WindDirection.fromJson(Map<String, dynamic> json) {
    return WindDirection(
      compassDegrees: (json['compass_degrees'] ?? 0.0).toDouble(),
      compassPoint: json['compass_point'] ?? '',
      compassRight: (json['compass_right'] ?? 0.0).toDouble(),
      compassUp: (json['compass_up'] ?? 0.0).toDouble(),
      ct: (json['ct'] ?? 0).toInt(),
    );
  }
}

class ValidityChecks {
  final Map<String, SensorValidity> checks;
  final int solHoursRequired;
  final List<String> solsChecked;

  ValidityChecks({
    required this.checks,
    required this.solHoursRequired,
    required this.solsChecked,
  });

  factory ValidityChecks.fromJson(Map<String, dynamic> json) {
    final checks = <String, SensorValidity>{};
    
    json.forEach((key, value) {
      if (key != 'sol_hours_required' && key != 'sols_checked') {
        checks[key] = SensorValidity.fromJson(value);
      }
    });
    
    return ValidityChecks(
      checks: checks,
      solHoursRequired: json['sol_hours_required'] ?? 0,
      solsChecked: List<String>.from(json['sols_checked'] ?? []),
    );
  }
}

class SensorValidity {
  final SensorDataValidity at;
  final SensorDataValidity hws;
  final SensorDataValidity pre;
  final SensorDataValidity wd;

  SensorValidity({
    required this.at,
    required this.hws,
    required this.pre,
    required this.wd,
  });

  factory SensorValidity.fromJson(Map<String, dynamic> json) {
    return SensorValidity(
      at: SensorDataValidity.fromJson(json['AT'] ?? {}),
      hws: SensorDataValidity.fromJson(json['HWS'] ?? {}),
      pre: SensorDataValidity.fromJson(json['PRE'] ?? {}),
      wd: SensorDataValidity.fromJson(json['WD'] ?? {}),
    );
  }
}

class SensorDataValidity {
  final List<int> solHoursWithData;
  final bool valid;

  SensorDataValidity({
    required this.solHoursWithData,
    required this.valid,
  });

  factory SensorDataValidity.fromJson(Map<String, dynamic> json) {
    return SensorDataValidity(
      solHoursWithData: List<int>.from(json['sol_hours_with_data'] ?? []),
      valid: json['valid'] ?? false,
    );
  }
}