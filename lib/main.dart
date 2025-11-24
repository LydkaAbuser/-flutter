import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа - Прокопенко Илья Андреевич'),
          backgroundColor: const Color.fromARGB(255, 98, 139, 173),
        ),
        body: MyHomePage(),
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final initialVelocityController = TextEditingController();
  final finalVelocityController = TextEditingController();
  final timeController = TextEditingController();
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Начальная скорость
            TextFormField(
              controller: initialVelocityController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Начальная скорость (м/с)',
                border: OutlineInputBorder(),
                hintText: '0.0',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите начальную скорость';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите корректное число';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Конечная скорость
            TextFormField(
              controller: finalVelocityController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Конечная скорость (м/с)',
                border: OutlineInputBorder(),
                hintText: '10.0',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите конечную скорость';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите корректное число';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Время
            TextFormField(
              controller: timeController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Время (секунды)',
                border: OutlineInputBorder(),
                hintText: '5.0',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите время';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите корректное число';
                }
                if (double.parse(value) <= 0) {
                  return 'Время должно быть больше 0';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            // Чекбокс
            CheckboxListTile(
              title: Text('Согласен на обработку данных'),
              value: agreed,
              onChanged: (value) => setState(() => agreed = value!),
            ),
            SizedBox(height: 24),

            // Кнопка расчета
            ElevatedButton(
              onPressed: () {
                if (initialVelocityController.text.isNotEmpty &&
                    finalVelocityController.text.isNotEmpty &&
                    timeController.text.isNotEmpty &&
                    agreed) {
                  
                  double v0 = double.parse(initialVelocityController.text);
                  double v = double.parse(finalVelocityController.text);
                  double t = double.parse(timeController.text);
                  
                  Navigator.push(context, MaterialPageRoute(builder: (context) => 
                    ResultsScreen(
                      initialVelocity: v0,
                      finalVelocity: v,
                      time: t,
                    )));
                }
              },
              child: Text('Рассчитать ускорение'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  final double initialVelocity;
  final double finalVelocity;
  final double time;

  const ResultsScreen({
    required this.initialVelocity,
    required this.finalVelocity,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    // Расчет ускорения по формуле: a = (v - v0) / t
    double acceleration = (finalVelocity - initialVelocity) / time;
    
    // Определение характера движения
    String movementType = acceleration > 0 
        ? 'Ускоренное движение' 
        : acceleration < 0 
            ? 'Замедленное движение' 
            : 'Равномерное движение';

    return Scaffold(
      appBar: AppBar(title: Text('Результаты расчета')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Входные параметры:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('Начальная скорость: ${initialVelocity.toStringAsFixed(2)} м/с', 
                   style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Конечная скорость: ${finalVelocity.toStringAsFixed(2)} м/с', 
                   style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Время: ${time.toStringAsFixed(2)} секунд', 
                   style: TextStyle(fontSize: 16)),
              
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 16),
              
              Text(
                'Результаты:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              
              Text('Ускорение:', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                '${acceleration.toStringAsFixed(2)} м/с²',
                style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              
              Text(
                movementType,
                style: TextStyle(
                  fontSize: 18,
                  color: acceleration > 0 ? Colors.green : 
                         acceleration < 0 ? Colors.orange : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Назад к расчету'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}