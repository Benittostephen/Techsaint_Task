import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_world/feature/fruit/blocs/fruit_bloc.dart';
import 'package:fruit_world/feature/fruit/repositories/fruit_repository.dart';
import 'package:fruit_world/feature/fruit/screens/fruit_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FruitRepository(),
      child: BlocProvider(
        create: (context) => FruitBloc(
          fruitRepository: RepositoryProvider.of<FruitRepository>(context),
        ),
        child: MaterialApp(
          title: 'Fruit World',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            scaffoldBackgroundColor: Colors.grey.shade100,
            useMaterial3: true,
          ),
          home: const FruitListScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
