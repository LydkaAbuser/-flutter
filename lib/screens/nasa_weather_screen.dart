import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/nasa_weather_cubit.dart';
import '../nasa_insight_model.dart';
import 'nasa_detail_screen.dart';

class NasaWeatherScreen extends StatefulWidget {
  @override
  _NasaWeatherScreenState createState() => _NasaWeatherScreenState();
}

class _NasaWeatherScreenState extends State<NasaWeatherScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NasaWeatherCubit>().loadWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Погода на Марсе'),
        backgroundColor: Color.fromARGB(255, 98, 139, 173),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<NasaWeatherCubit>().loadWeatherData();
            },
          ),
        ],
      ),
      body: BlocBuilder<NasaWeatherCubit, NasaWeatherState>(
        builder: (context, state) {
          if (state is NasaWeatherLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Загрузка данных с Марса...', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          } else if (state is NasaWeatherError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 64),
                    SizedBox(height: 20),
                    Text(
                      'Ошибка загрузки',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NasaWeatherCubit>().loadWeatherData();
                      },
                      child: Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is NasaWeatherLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Метеоданные InSight',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text('Последние данные за ${state.weatherData.solKeys.length} солов'),
                          SizedBox(height: 5),
                          Text('Валидность проверена для ${state.weatherData.validityChecks.solsChecked.length} солов'),
                        ],
                      ),
                    ),
                  ),
                ),
                
                Expanded(
                  child: ListView.builder(
                    itemCount: state.weatherData.solKeys.length,
                    itemBuilder: (context, index) {
                      final solKey = state.weatherData.solKeys[index];
                      final solData = state.weatherData.solData[solKey];
                      if (solData == null) return SizedBox();
                      
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NasaDetailScreen(
                                  solKey: solKey,
                                  solData: solData,
                                ),
                              ),
                            );
                          },
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _getTemperatureColor(solData.at.av),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'Сол\n$solKey',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text('Сол $solKey'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Температура: ${solData.at.av.toStringAsFixed(1)}°C'),
                              Text('Ветер: ${solData.hws.av.toStringAsFixed(1)} м/с'),
                              Text('Давление: ${solData.pre.av.toStringAsFixed(1)} Па'),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud, size: 64, color: Colors.blue),
                  SizedBox(height: 20),
                  Text(
                    'Погода на Марсе',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Нажмите кнопку для загрузки данных'),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NasaWeatherCubit>().loadWeatherData();
                    },
                    child: Text('Загрузить данные'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp > -50) return Colors.orange;
    if (temp > -70) return Colors.blue;
    return Colors.blue[900]!;
  }
}