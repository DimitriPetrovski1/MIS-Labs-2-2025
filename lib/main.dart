import 'package:flutter/material.dart';
import 'package:mis_labs_2_2025/screens/category_meals.dart';
import 'package:mis_labs_2_2025/screens/details.dart';
import 'package:mis_labs_2_2025/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const MyHomePage(title: 'Рецепти'),
        "/categoryMeals": (context) => const CategoryMealsPage(),
        "/details": (context) => const DetailsPage(),
      },
    );
  }
}

