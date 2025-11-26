import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../calculation_model.dart';  
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  Database? _database;
  late SharedPreferences _preferences;
  bool _isDatabaseInitialized = false;
  bool _isPreferencesInitialized = false;

  MainScreenCubit() : super(MainScreenInitial()) {
 
    _initAsync();
  }

  
  Future<void> _initAsync() async {
    try {
      await _initPreferences();
      await _initDatabase();
      
    
      final lastCalc = await getLastCalculation();
      if (lastCalc != null) {
        emit(MainScreenCalculated(
          initialVelocity: lastCalc['initialVelocity'],
          finalVelocity: lastCalc['finalVelocity'],
          time: lastCalc['time'],
          acceleration: lastCalc['acceleration'],
          movementType: lastCalc['movementType'],
        ));
      }
    } catch (e) {
      print('Ошибка инициализации: $e');
    }
  }

  //SharedPreferences
  Future<void> _initPreferences() async {
    if (_isPreferencesInitialized) return;
    
    _preferences = await SharedPreferences.getInstance();
    _isPreferencesInitialized = true;
  }

  //база данных
  Future<void> _initDatabase() async {
    if (_isDatabaseInitialized) return;
    
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'calculations.db');
    
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
    
    _isDatabaseInitialized = true;
  }

  //структура БД
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        initialVelocity REAL NOT NULL,
        finalVelocity REAL NOT NULL,
        time REAL NOT NULL,
        acceleration REAL NOT NULL,
        movementType TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Метод расчета ускорения с сохранением
  Future<void> calculateAcceleration({
    required double initialVelocity,
    required double finalVelocity,
    required double time,
  }) async {
    try {
      // Проверка времени
      if (time <= 0) {
        emit(MainScreenError('Время должно быть больше 0'));
        return;
      }

      // Расчет ускорения по формуле: a = (v - v0) / t
      double acceleration = (finalVelocity - initialVelocity) / time;
      
      // Определение характера движения
      String movementType = acceleration > 0 
          ? 'Ускоренное движение' 
          : acceleration < 0 
              ? 'Замедленное движение' 
              : 'Равномерное движение';

    
      await _ensureInitialized();

      //SQflite
      await _saveToDatabase(
        initialVelocity: initialVelocity,
        finalVelocity: finalVelocity,
        time: time,
        acceleration: acceleration,
        movementType: movementType,
      );

      //SharedPreferences
      await _saveToPreferences(
        initialVelocity: initialVelocity,
        finalVelocity: finalVelocity,
        time: time,
        acceleration: acceleration,
        movementType: movementType,
      );

    
      await _incrementCalculationCount();

  
      emit(MainScreenCalculated(
        initialVelocity: initialVelocity,
        finalVelocity: finalVelocity,
        time: time,
        acceleration: acceleration,
        movementType: movementType,
      ));
    } catch (e) {
      emit(MainScreenError('Ошибка расчета: $e'));
    }
  }


  Future<void> _ensureInitialized() async {
    if (!_isDatabaseInitialized) await _initDatabase();
    if (!_isPreferencesInitialized) await _initPreferences();
  }

  //SQflite
  Future<void> _saveToDatabase({
    required double initialVelocity,
    required double finalVelocity,
    required double time,
    required double acceleration,
    required String movementType,
  }) async {
    await _ensureInitialized();
    
    final calculation = Calculation(
      initialVelocity: initialVelocity,
      finalVelocity: finalVelocity,
      time: time,
      acceleration: acceleration,
      movementType: movementType,
      createdAt: DateTime.now(),
    );

    await _database!.insert(
      'calculations',
      calculation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Сохранение в SharedPreferences
  Future<void> _saveToPreferences({
    required double initialVelocity,
    required double finalVelocity,
    required double time,
    required double acceleration,
    required String movementType,
  }) async {
    await _ensureInitialized();
    
    await _preferences.setDouble('lastInitialVelocity', initialVelocity);
    await _preferences.setDouble('lastFinalVelocity', finalVelocity);
    await _preferences.setDouble('lastTime', time);
    await _preferences.setDouble('lastAcceleration', acceleration);
    await _preferences.setString('lastMovementType', movementType);
    await _preferences.setString('lastCalculationDate', DateTime.now().toIso8601String());
  }


  Future<void> _incrementCalculationCount() async {
    await _ensureInitialized();
    
    int count = _preferences.getInt('totalCalculations') ?? 0;
    await _preferences.setInt('totalCalculations', count + 1);
  }

  //SharedPreferences
  Future<Map<String, dynamic>?> getLastCalculation() async {
    try {
      await _ensureInitialized();
      
      final initialVelocity = _preferences.getDouble('lastInitialVelocity');
      
      if (initialVelocity == null) {
        return null;
      }

      return {
        'initialVelocity': initialVelocity,
        'finalVelocity': _preferences.getDouble('lastFinalVelocity') ?? 0,
        'time': _preferences.getDouble('lastTime') ?? 0,
        'acceleration': _preferences.getDouble('lastAcceleration') ?? 0,
        'movementType': _preferences.getString('lastMovementType') ?? '',
        'date': _preferences.getString('lastCalculationDate') ?? DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Ошибка получения последнего расчета: $e');
      return null;
    }
  }

  
  Future<int> getTotalCalculations() async {
    try {
      await _ensureInitialized();
      return _preferences.getInt('totalCalculations') ?? 0;
    } catch (e) {
      print('Ошибка получения количества расчетов: $e');
      return 0;
    }
  }

  
  Future<List<Calculation>> getAllCalculations() async {
    try {
      await _ensureInitialized();
      
      if (_database == null) {
        throw Exception('База данных не инициализирована');
      }
      
      final List<Map<String, dynamic>> maps = 
          await _database!.query(
            'calculations',
            orderBy: 'createdAt DESC',
          );
      
      return List.generate(maps.length, (i) {
        return Calculation.fromMap(maps[i]);
      });
    } catch (e) {
      print('Ошибка получения всех расчетов: $e');
      return [];
    }
  }

  
  Future<void> deleteCalculation(int id) async {
    try {
      await _ensureInitialized();
      
      await _database!.delete(
        'calculations',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Ошибка удаления расчета: $e');
      rethrow; 
    }
  }

  // Очистка SharedPreferences
  Future<void> clearPreferences() async {
    try {
      await _ensureInitialized();
      
      await _preferences.remove('lastInitialVelocity');
      await _preferences.remove('lastFinalVelocity');
      await _preferences.remove('lastTime');
      await _preferences.remove('lastAcceleration');
      await _preferences.remove('lastMovementType');
      await _preferences.remove('lastCalculationDate');
    } catch (e) {
      print('Ошибка очистки SharedPreferences: $e');
    }
  }

  // Очистка базы данных
  Future<void> clearDatabase() async {
    try {
      await _ensureInitialized();
      
      await _database!.delete('calculations');
    } catch (e) {
      print('Ошибка очистки базы данных: $e');
    }
  }

  // Сброс состояния
  void reset() {
    emit(MainScreenInitial());
  }
}