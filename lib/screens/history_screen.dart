import 'package:flutter/material.dart';
import '../calculation_model.dart';
import 'cubit/main_screen_cubit.dart'; 

class HistoryScreen extends StatefulWidget {
  final MainScreenCubit cubit; 
  
  HistoryScreen({required this.cubit});
  
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Calculation>> _calculationsFuture;

  @override
  void initState() {
    super.initState();
    _calculationsFuture = widget.cubit.getAllCalculations(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('История расчетов'),
        backgroundColor: Color.fromARGB(255, 98, 139, 173),
      ),
      body: FutureBuilder<List<Calculation>>(
        future: _calculationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка загрузки данных'),
            );
          }

          final calculations = snapshot.data ?? [];

          if (calculations.isEmpty) {
            return Center(
              child: Text('Нет сохраненных расчетов'),
            );
          }

          return ListView.builder(
            itemCount: calculations.length,
            itemBuilder: (context, index) {
              final calc = calculations[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Расчет #${calc.id}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await widget.cubit.deleteCalculation(calc.id!);
                            
                              setState(() {
                                _calculationsFuture = widget.cubit.getAllCalculations();
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Начальная скорость: ${calc.initialVelocity.toStringAsFixed(2)} м/с'),
                      Text('Конечная скорость: ${calc.finalVelocity.toStringAsFixed(2)} м/с'),
                      Text('Время: ${calc.time.toStringAsFixed(2)} с'),
                      Text('Ускорение: ${calc.acceleration.toStringAsFixed(2)} м/с²'),
                      Text('Тип движения: ${calc.movementType}'),
                      Text('Дата: ${calc.createdAt.toLocal()}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}