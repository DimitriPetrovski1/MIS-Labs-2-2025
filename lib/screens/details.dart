import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final ApiService _api = ApiService();
  MealDetail? _meal;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg is MealDetail) {
      _meal = arg;
      _isLoading = false;
    } else if (arg is MealSummary) {
      _loadDetail(arg.idMeal);
    } else if (arg is String) {
      _loadDetail(arg);
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadDetail(String id) async {
    final detail = await _api.lookupMeal(id);
    setState(() {
      _meal = detail;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_meal?.strMeal ?? 'Детали'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _meal == null
          ? const Center(child: Text('Нема податоци'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(_meal!.strMealThumb, height: 220, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(_meal!.strMeal, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${_meal!.strCategory} • ${_meal!.strArea}'),
            const SizedBox(height: 16),
            const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ..._meal!.ingredients.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• ${e.key} — ${e.value}'),
            )),
            const SizedBox(height: 16),
            const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(_meal!.strInstructions),
            const SizedBox(height: 16),
            if (_meal!.strYoutube != null && _meal!.strYoutube!.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(_meal!.strYoutube!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Open YouTube'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}