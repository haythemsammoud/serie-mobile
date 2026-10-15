import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Point d'entrée de l'application
void main() => runApp(const MyApp());

// Classe MyApp (StatelessWidget) : initialise l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // masque la bande de débogage
      title: 'Calculatrice',
      home: AverageCalculator(),
    );
  }
}

// Classe AverageCalculator (StatefulWidget) : interface de l'application
class AverageCalculator extends StatefulWidget {
  const AverageCalculator({super.key});

  @override
  State<AverageCalculator> createState() => _AverageCalculatorState();
}

class _AverageCalculatorState extends State<AverageCalculator> {
  // Contrôleurs des deux champs de texte
  final _firstNumberController = TextEditingController();
  final _secondNumberController = TextEditingController();

  // Résultats affichés (0 au départ)
  double _average = 0;
  double _sum = 0;
  double _product = 0;
  double _substraction = 0;

  // Convertit le texte d'un contrôleur en nombre (null si invalide)
  double? _parse(TextEditingController controller) {
    return double.tryParse(controller.text);
  }

  // Affiche 5 au lieu de 5.0, et limite les décimales à 2 chiffres
  String _format(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  // Calcule la moyenne des deux nombres et met à jour l'état
  void _calculateAverage() {
    final a = _parse(_firstNumberController);
    final b = _parse(_secondNumberController);
    if (a == null || b == null) return;
    setState(() => _average = (a + b) / 2);
  }

  // Calcule la somme des deux nombres et met à jour l'état
  void _calculateSum() {
    final a = _parse(_firstNumberController);
    final b = _parse(_secondNumberController);
    if (a == null || b == null) return;
    setState(() => _sum = a + b);
  }

  // Calcule le produit des deux nombres et met à jour l'état
  void _calculateProduct() {
    final a = _parse(_firstNumberController);
    final b = _parse(_secondNumberController);
    if (a == null || b == null) return;
    setState(() => _product = a * b);
  }

  // Calcule la soustraction (premier - deuxième) et met à jour l'état
  void _calculateSubstruction() {
    final a = _parse(_firstNumberController);
    final b = _parse(_secondNumberController);
    if (a == null || b == null) return;
    setState(() => _substraction = a - b);
  }

  // Initialise le travail : vide les champs et remet les résultats à 0
  void _clearFields() {
    setState(() {
      _firstNumberController.clear();
      _secondNumberController.clear();
      _average = 0;
      _sum = 0;
      _product = 0;
      _substraction = 0;
    });
  }

  // Lance les 4 calculs (avec vérification de la saisie)
  void _calculateAll() {
    if (_parse(_firstNumberController) == null ||
        _parse(_secondNumberController) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir deux nombres valides')),
      );
      return;
    }
    _calculateAverage();
    _calculateSum();
    _calculateProduct();
    _calculateSubstruction();
  }

  @override
  void dispose() {
    // Libère la mémoire des contrôleurs
    _firstNumberController.dispose();
    _secondNumberController.dispose();
    super.dispose();
  }

  // Champ de texte qui n'accepte que des nombres (décimaux et négatifs inclus)
  Widget _numberField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      inputFormatters: [
        // Autorise seulement : un "-" optionnel, des chiffres, un "." optionnel
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Texte de résultat coloré
  Widget _resultText(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        '$label : ${_format(value)}',
        style: TextStyle(color: color, fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple, // arrière-plan bleu
        // Icône de calculatrice à gauche
        leading: const Icon(Icons.calculate, color: Colors.white),
        // Titre en blanc
        title: const Text('Opération', style: TextStyle(color: Colors.white)),
        // Bouton d'action à droite : efface les champs et remet les résultats à 0
        actions: [
          IconButton(
            onPressed: _clearFields,
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _numberField(_firstNumberController, 'Premier nombre'),
            const SizedBox(height: 16),
            _numberField(_secondNumberController, 'Deuxième nombre'),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _calculateAll,
                child: const Text('Calculer'),
              ),
            ),
            // Résultats avec les couleurs demandées
            _resultText('La moyenne est', _average, Colors.green),
            _resultText('La somme est', _sum, Colors.blue),
            _resultText('Le produit est', _product, Colors.pink),
            _resultText('La soustraction est', _substraction, Colors.brown),
          ],
        ),
      ),
    );
  }
}
