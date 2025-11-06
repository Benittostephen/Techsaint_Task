import 'package:equatable/equatable.dart';

abstract class FruitEvent extends Equatable {
  const FruitEvent();

  @override
  List<Object> get props => [];
}

class LoadAllFruits extends FruitEvent {}

class LoadFruitDetail extends FruitEvent {
  final String fruitName;

  const LoadFruitDetail(this.fruitName);

  @override
  List<Object> get props => [fruitName];
}