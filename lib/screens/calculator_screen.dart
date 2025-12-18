import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/history_service.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);
  
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _inputController = TextEditingController();
  double _result = 0.0;
  String _selectedUnit = 'm/s_to_km/h';
  final HistoryService _historyService = HistoryService();
  List<ConversionRecord> _conversionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final history = await _historyService.getConversionHistory();
    setState(() {
      _conversionHistory = history;
    });
  }

  void _calculate() {
    final inputText = _inputController.text;
    
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите значение для расчета')),
      );
      return;
    }
    
    final inputValue = double.tryParse(inputText);
    
    if (inputValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректное число')),
      );
      return;
    }

    late double result;
    late String inputUnit, outputUnit;

    if (_selectedUnit == 'm/s_to_km/h') {
      result = inputValue * 3.6;
      inputUnit = 'м/с';
      outputUnit = 'км/ч';
    } else {
      result = inputValue / 3.6;
      inputUnit = 'км/ч';
      outputUnit = 'м/с';
    }

    final record = ConversionRecord(
      inputValue: inputValue,
      inputUnit: inputUnit,
      outputValue: result,
      outputUnit: outputUnit,
      timestamp: DateTime.now(),
    );

    _historyService.saveConversionRecord(record);
    
    setState(() {
      _result = result;
    });
    
    _loadHistory();
    _inputController.clear();
    FocusScope.of(context).unfocus();
  }

  void _clearHistory() async {
    await _historyService.clearConversionHistory();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конвертер скорости ветра'),
        actions: [
          if (_conversionHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _clearHistory,
              tooltip: 'Очистить историю',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Введите значение',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.speed),
                        hintText: 'Например: 10.5',
                      ),
                      onSubmitted: (_) => _calculate(),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedUnit = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Направление конвертации',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'm/s_to_km/h',
                          child: Text('метры в секунду → километры в час'),
                        ),
                        DropdownMenuItem(
                          value: 'km/h_to_m/s',
                          child: Text('километры в час → метры в секунду'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    ElevatedButton(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Рассчитать',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[100]!),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Результат:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _result.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            _selectedUnit == 'm/s_to_km/h' ? 'км/ч' : 'м/с',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'История расчетов:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '(${_conversionHistory.length})',
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
              child: _conversionHistory.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calculate,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'История расчетов пуста',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _conversionHistory.length,
                      itemBuilder: (context, index) {
                        final record = _conversionHistory[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.autorenew, color: Colors.green),
                            title: Text(
                              '${record.inputValue.toStringAsFixed(2)} ${record.inputUnit}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '= ${record.outputValue.toStringAsFixed(2)} ${record.outputUnit}',
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
    );
  }
}