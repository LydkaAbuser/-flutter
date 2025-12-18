import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/history_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  WeatherRecord? _currentWeather;
  bool _isLoading = false;
  String _error = '';
  final HistoryService _historyService = HistoryService();
  List<WeatherRecord> _weatherHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final history = await _historyService.getWeatherHistory();
    setState(() {
      _weatherHistory = history;
    });
  }

  void _searchWeather() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) {
      setState(() {
        _error = 'Введите название города';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final data = await WeatherService.fetchWeather(city);
      final weather = WeatherService.parseWeatherResponse(data, city);
      
      await _historyService.saveWeatherRecord(weather);
      
      setState(() {
        _currentWeather = weather;
      });
      
      _loadHistory();
      
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      
      setState(() {
        _error = errorMessage;
        _currentWeather = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearHistory() async {
    await _historyService.clearWeatherHistory();
    _loadHistory();
  }

  // Функция для конвертации м/с в км/ч
  double _convertWindSpeedToKmH(double windSpeedMs) {
    return windSpeedMs * 3.6;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        actions: [
          if (_weatherHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _clearHistory,
              tooltip: 'Очистить историю',
            ),
        ],
      ),
      body: Column(
        children: [
          // Верхняя часть с поиском и погодой
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Поисковая строка
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            hintText: 'Введите город, например: Москва',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onSubmitted: (_) => _searchWeather(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _searchWeather,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Поиск'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Сообщение об ошибке
                  if (_error.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[100]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _error,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Карточка с погодой
                  if (_currentWeather != null)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Название города
                            Text(
                              _currentWeather!.cityName,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            // Температура
                            Text(
                              '${_currentWeather!.temperature.toStringAsFixed(1)}°C',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            // Описание погоды
                            Text(
                              _currentWeather!.description,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Ветер (две строки)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  // Ветер в м/с
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.air, color: Colors.blue, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Ветер: ${_currentWeather!.windSpeedMs.toStringAsFixed(1)} м/с',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Ветер в км/ч
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.speed, color: Colors.green, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Ветер: ${_convertWindSpeedToKmH(_currentWeather!.windSpeedMs).toStringAsFixed(1)} км/ч',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  
                  // Если нет погоды и нет ошибки
                  if (_currentWeather == null && _error.isEmpty && !_isLoading)
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Введите город для получения погоды',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          //  часть с историей
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'История запросов:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(${_weatherHistory.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  const Divider(),
                  
                  Expanded(
                    child: _weatherHistory.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'История запросов пуста',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _weatherHistory.length,
                            itemBuilder: (context, index) {
                              final record = _weatherHistory[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: const Icon(Icons.cloud, color: Colors.blue),
                                  title: Text(
                                    record.cityName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${record.temperature.toStringAsFixed(1)}°C, ${record.description}'),
                                      Text(
                                        'Ветер: ${record.windSpeedMs.toStringAsFixed(1)} м/с (${_convertWindSpeedToKmH(record.windSpeedMs).toStringAsFixed(1)} км/ч)',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    DateFormat('HH:mm').format(record.timestamp),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}