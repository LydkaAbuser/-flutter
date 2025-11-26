import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/main_screen_cubit.dart';
import 'cubit/main_screen_state.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _initialVelocityController = TextEditingController();
  final TextEditingController _finalVelocityController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Лабораторная работа - Прокопенко Илья Андреевич'),
        backgroundColor: Color.fromARGB(255, 98, 139, 173),
      ),
      body: BlocBuilder<MainScreenCubit, MainScreenState>(
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _buildContent(state, context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(MainScreenState state, BuildContext context) {
    if (state is MainScreenInitial) {
      return _buildInputForm(context);
    } else if (state is MainScreenCalculated) {
      return _buildResults(state, context);
    } else if (state is MainScreenError) {
      return _buildError(state, context);
    } else {
      return _buildInputForm(context);
    }
  }

  Widget _buildInputForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _initialVelocityController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Начальная скорость (м/с)',
            border: OutlineInputBorder(),
            hintText: '0.0',
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _finalVelocityController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Конечная скорость (м/с)',
            border: OutlineInputBorder(),
            hintText: '10.0',
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _timeController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Время (секунды)',
            border: OutlineInputBorder(),
            hintText: '5.0',
          ),
        ),
        SizedBox(height: 16),
        CheckboxListTile(
          title: Text('Согласен на обработку данных'),
          value: _agreed,
          onChanged: (value) => setState(() => _agreed = value!),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            if (_initialVelocityController.text.isNotEmpty &&
                _finalVelocityController.text.isNotEmpty &&
                _timeController.text.isNotEmpty &&
                _agreed) {
              
              double v0 = double.parse(_initialVelocityController.text);
              double v = double.parse(_finalVelocityController.text);
              double t = double.parse(_timeController.text);
              
              context.read<MainScreenCubit>().calculateAcceleration(
                initialVelocity: v0,
                finalVelocity: v,
                time: t,
              );
            }
          },
          child: Text('Рассчитать ускорение'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(MainScreenCalculated state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Результаты расчета:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text('Начальная скорость: ${state.initialVelocity.toStringAsFixed(2)} м/с', 
             style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text('Конечная скорость: ${state.finalVelocity.toStringAsFixed(2)} м/с', 
             style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text('Время: ${state.time.toStringAsFixed(2)} секунд', 
             style: TextStyle(fontSize: 16)),
        
        SizedBox(height: 24),
        Divider(),
        SizedBox(height: 16),
        
        Text('Ускорение:', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text(
          '${state.acceleration.toStringAsFixed(2)} м/с²',
          style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        
        Text(
          state.movementType,
          style: TextStyle(
            fontSize: 18,
            color: state.acceleration > 0 ? Colors.green : 
                   state.acceleration < 0 ? Colors.orange : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 32),
        
        ElevatedButton(
          onPressed: () => context.read<MainScreenCubit>().reset(),
          child: Text('Новый расчет'),
        ),
      ],
    );
  }

  Widget _buildError(MainScreenError state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Colors.red, size: 64),
        SizedBox(height: 16),
        Text(
          'Ошибка',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
        SizedBox(height: 16),
        Text(state.message, style: TextStyle(fontSize: 16)),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => context.read<MainScreenCubit>().reset(),
          child: Text('Вернуться к расчету'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _initialVelocityController.dispose();
    _finalVelocityController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}