import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fruit.dart';

class FruitRepository {
  static const String _baseUrl = 'https://www.fruityvice.com/api/fruit';
  static const String _allFruitsKey = 'all_fruits_cache';
  static const String _fruitDetailKey = 'fruit_detail_cache_';

  // Get all fruits
  Future<List<Fruit>> getAllFruits() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/all'));
      
      if (response.statusCode == 200) {
        // Cache the response
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_allFruitsKey, response.body);
        
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Fruit.fromJson(json)).toList();
      } else {
        // Try to get from cache if API fails
        return _getCachedAllFruits();
      }
    } catch (e) {
      // Return cached data if available
      return _getCachedAllFruits();
    }
  }

  // Get a specific fruit by name
  Future<Fruit> getFruitByName(String name) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$name'));
      
      if (response.statusCode == 200) {
        // Cache the response
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('$_fruitDetailKey$name', response.body);
        
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Fruit.fromJson(jsonData);
      } else {
        // Try to get from cache if API fails
        return _getCachedFruitByName(name);
      }
    } catch (e) {
      // Return cached data if available
      return _getCachedFruitByName(name);
    }
  }

  // Get cached list of all fruits
  Future<List<Fruit>> _getCachedAllFruits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_allFruitsKey);
      
      if (cachedData != null) {
        final List<dynamic> jsonList = json.decode(cachedData);
        return jsonList.map((json) => Fruit.fromJson(json)).toList();
      }
    } catch (e) {
      // If parsing fails, rethrow
      throw Exception('Failed to load fruit data');
    }

    throw Exception('Failed to load fruit data');
  }

  // Get cached fruit by name
  Future<Fruit> _getCachedFruitByName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('$_fruitDetailKey$name');
      
      if (cachedData != null) {
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        return Fruit.fromJson(jsonData);
      }
    } catch (e) {
      // If parsing fails, rethrow
      throw Exception('Failed to load fruit data');
    }
    
    throw Exception('Failed to load fruit data');
  }
}