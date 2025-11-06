import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/fruit_repository.dart';
import '../models/fruit.dart';
import 'fruit_event.dart';
import 'fruit_state.dart';

class FruitBloc extends Bloc<FruitEvent, FruitState> {
  final FruitRepository fruitRepository;

  FruitBloc({required this.fruitRepository}) : super(FruitInitial()) {
    on<LoadAllFruits>(_onLoadAllFruits);
    on<LoadFruitDetail>(_onLoadFruitDetail);
  }

  Future<void> _onLoadAllFruits(
    LoadAllFruits event,
    Emitter<FruitState> emit,
  ) async {
    emit(FruitLoading());
    try {
      final List<Fruit> fruits = await fruitRepository.getAllFruits();
      emit(FruitLoadSuccess(fruits));
    } catch (e) {
      emit(FruitLoadFailure(e.toString()));
    }
  }

  Future<void> _onLoadFruitDetail(
    LoadFruitDetail event,
    Emitter<FruitState> emit,
  ) async {
    emit(FruitDetailLoading());
    try {
      final Fruit fruit = await fruitRepository.getFruitByName(event.fruitName);
      emit(FruitDetailSuccess(fruit));
    } catch (e) {
      emit(FruitDetailFailure(e.toString()));
    }
  }
}