import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_world/feature/fruit/blocs/fruit_bloc.dart';
import 'package:fruit_world/feature/fruit/blocs/fruit_event.dart';
import 'package:fruit_world/feature/fruit/blocs/fruit_state.dart';
import 'package:fruit_world/feature/fruit/repositories/fruit_repository.dart';

class FruitDetailScreen extends StatelessWidget {
  final String fruitName;

  const FruitDetailScreen({super.key, required this.fruitName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FruitBloc(
        fruitRepository: RepositoryProvider.of<FruitRepository>(context),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(fruitName),
          backgroundColor: Colors.green,
        ),
        body: BlocBuilder<FruitBloc, FruitState>(
          builder: (context, state) {
            // Load fruit details when screen is opened
            if (state is FruitInitial) {
              context.read<FruitBloc>().add(LoadFruitDetail(fruitName));
            }
            
            if (state is FruitDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FruitDetailSuccess) {
              final fruit = state.fruit;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fruit.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text('Family: ${fruit.family}'),
                            Text('Order: ${fruit.order}'),
                            Text('Genus: ${fruit.genus}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nutritional Information',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            _buildNutritionRow('Calories', fruit.nutritions.calories),
                            _buildNutritionRow('Fat', fruit.nutritions.fat),
                            _buildNutritionRow('Sugar', fruit.nutritions.sugar),
                            _buildNutritionRow('Carbohydrates', fruit.nutritions.carbohydrates),
                            _buildNutritionRow('Protein', fruit.nutritions.protein),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is FruitDetailFailure) {
              return _buildErrorState(context, state.error);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load fruit details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Reload the fruit details
              BlocProvider.of<FruitBloc>(context).add(LoadFruitDetail(fruitName));
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String name, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text('$value'),
        ],
      ),
    );
  }
}