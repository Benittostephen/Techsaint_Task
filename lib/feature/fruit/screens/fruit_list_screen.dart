import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_world/feature/fruit/blocs/fruit_bloc.dart';
import 'package:fruit_world/feature/fruit/blocs/fruit_event.dart';
import 'package:fruit_world/feature/fruit/blocs/fruit_state.dart';
import 'package:fruit_world/feature/fruit/models/fruit.dart';
import 'fruit_detail_screen.dart';

class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Fruit World',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        // backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: BlocBuilder<FruitBloc, FruitState>(
        builder: (context, state) {
          if (state is FruitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FruitLoadSuccess) {
            return _buildFruitList(state.fruits, context);
          } else if (state is FruitLoadFailure) {
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
                      context.read<FruitBloc>().add(LoadAllFruits());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            if (state is FruitInitial) {
              context.read<FruitBloc>().add(LoadAllFruits());
            }
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildFruitList(List<Fruit> fruits, BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Text(
                  fruit.name[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                fruit.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '${fruit.family} • ${fruit.genus}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${fruit.nutritions.calories} kcal',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FruitDetailScreen(fruitName: fruit.name),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}