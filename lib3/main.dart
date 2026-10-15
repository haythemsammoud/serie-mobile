import 'package:flutter/material.dart';

// Point d'entrée de l'application
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercice 3',
      home: ChampsMultiplesPage(),
    );
  }
}

class ChampsMultiplesPage extends StatelessWidget {
  const ChampsMultiplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercice 3 - Plusieurs champs'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      // SingleChildScrollView : évite le dépassement (overflow) quand le
      // clavier s'ouvre et réduit la hauteur disponible
      body: SingleChildScrollView(
        // Un SEUL Container contient tous les champs de saisie
        child: Container(
          padding: const EdgeInsets.all(16.0), // marge intérieure
          // Column : organise les champs les uns sous les autres
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Entrez le nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              // SizedBox : espace vertical entre deux champs
              const SizedBox(height: 16.0),
              const TextField(
                keyboardType: TextInputType.emailAddress, // clavier adapté
                decoration: InputDecoration(
                  hintText: 'Entrez l\'adresse e-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              const TextField(
                keyboardType: TextInputType.phone, // clavier numérique
                decoration: InputDecoration(
                  hintText: 'Entrez le numéro de téléphone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
