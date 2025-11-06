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
      appBar: AppBar(
        title: const Text('Fruit World'),
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<FruitBloc, FruitState>(
        builder: (context, state) {
          if (state is FruitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FruitLoadSuccess) {
            if (state.fruits.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildFruitList(state.fruits, context);
          } else if (state is FruitLoadFailure) {
            return _buildErrorState(context, state.error);
          } else {
            // Initial state - load fruits
            if (state is FruitInitial) {
              context.read<FruitBloc>().add(LoadAllFruits());
            }
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_food_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No fruits available',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please check your internet connection and try again',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
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
            'Failed to load fruits',
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
              context.read<FruitBloc>().add(LoadAllFruits());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFruitList(List<Fruit> fruits, BuildContext context) {
    return ListView.builder(
      itemCount: fruits.length,
      itemBuilder: (context, index) {
        final fruit = fruits[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(fruit.name),
            subtitle: Text('${fruit.family} - ${fruit.genus}'),
            trailing: Text('${fruit.nutritions.calories} kcal'),
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
    );
  }
}