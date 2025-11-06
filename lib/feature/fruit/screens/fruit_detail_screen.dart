import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/fruit_bloc.dart';
import '../blocs/fruit_event.dart';
import '../blocs/fruit_state.dart';
import '../repositories/fruit_repository.dart';

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
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            fruitName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
        ),
        body: BlocBuilder<FruitBloc, FruitState>(
          builder: (context, state) {
            if (state is FruitInitial) {
              context.read<FruitBloc>().add(LoadFruitDetail(fruitName));
            }
            if (state is FruitDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FruitDetailSuccess) {
              final fruit = state.fruit;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Card
                    Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.green.shade100,
                                  child: Text(
                                    fruit.name[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    fruit.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 12),
                            _buildInfoRow(Icons.category, 'Family', fruit.family),
                            const SizedBox(height: 12),
                            _buildInfoRow(Icons.local_florist, 'Order', fruit.order),
                            const SizedBox(height: 12),
                            _buildInfoRow(Icons.eco, 'Genus', fruit.genus),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nutritional Information Card
                    Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.restaurant, color: Colors.orange.shade700),
                                const SizedBox(width: 8),
                                const Text(
                                  'Nutritional Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildNutritionRow(
                              'Calories',
                              '${fruit.nutritions.calories}',
                              'kcal',
                              Colors.orange,
                            ),
                            const SizedBox(height: 12),
                            _buildNutritionRow(
                              'Carbohydrates',
                              '${fruit.nutritions.carbohydrates}',
                              'g',
                              Colors.blue,
                            ),
                            const SizedBox(height: 12),
                            _buildNutritionRow(
                              'Protein',
                              '${fruit.nutritions.protein}',
                              'g',
                              Colors.red,
                            ),
                            const SizedBox(height: 12),
                            _buildNutritionRow(
                              'Fat',
                              '${fruit.nutritions.fat}',
                              'g',
                              Colors.purple,
                            ),
                            const SizedBox(height: 12),
                            _buildNutritionRow(
                              'Sugar',
                              '${fruit.nutritions.sugar}',
                              'g',
                              Colors.pink,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is FruitDetailFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${state.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FruitBloc>().add(LoadFruitDetail(fruitName));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionRow(String name, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            '$value $unit',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}