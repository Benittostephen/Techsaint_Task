import 'package:equatable/equatable.dart';
import '../models/fruit.dart';

abstract class FruitState extends Equatable {
  const FruitState();

  @override
  List<Object> get props => [];
}

class FruitInitial extends FruitState {}

class FruitLoading extends FruitState {}

class FruitLoadSuccess extends FruitState {
  final List<Fruit> fruits;

  const FruitLoadSuccess(this.fruits);

  @override
  List<Object> get props => [fruits];
}

class FruitLoadFailure extends FruitState {
  final String error;

  const FruitLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class FruitDetailLoading extends FruitState {}

class FruitDetailSuccess extends FruitState {
  final Fruit fruit;

  const FruitDetailSuccess(this.fruit);

  @override
  List<Object> get props => [fruit];
}

class FruitDetailFailure extends FruitState {
  final String error;

  const FruitDetailFailure(this.error);

  @override
  List<Object> get props => [error];
}