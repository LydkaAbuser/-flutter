import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenInitial());

  void calculateAcceleration({
    required double initialVelocity,
    required double finalVelocity,
    required double time,
  }) {
    try {
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

  void reset() {
    emit(MainScreenInitial());
  }
}