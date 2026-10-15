import 'package:flutter/material.dart';

// Point d'entrée de l'application
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulaire Flutter',
      home: MonFormulairePage(),
    );
  }
}

// PARTIE 1 : la page du formulaire (StatefulWidget car les données
// changent selon les interactions de l'utilisateur)
class MonFormulairePage extends StatefulWidget {
  const MonFormulairePage({super.key});

  @override
  State<MonFormulairePage> createState() => _MonFormulairePageState();
}

class _MonFormulairePageState extends State<MonFormulairePage> {
  // --- Les éléments qui ont un état dynamique ---

  // Approche 1 du TextField : TextEditingController
  final _nomController = TextEditingController();

  // Approche 2 du TextField : onChanged (on stocke la valeur dans une variable)
  // (on garde aussi un contrôleur pour pouvoir vider le champ au "Réinitialiser")
  final _emailController = TextEditingController();
  String _email = '';

  bool _notifications = false; // état du Switch

  // état des CheckBox : centre d'intérêt -> coché ou non
  final Map<String, bool> _interets = {
    'Sport': false,
    'Musique': false,
    'Lecture': false,
  };

  @override
  void initState() {
    super.initState();
    // Le contrôleur prévient quand le texte change -> on rafraîchit le résumé
    _nomController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Liste des centres d'intérêt cochés
  List<String> get _interetsChoisis =>
      _interets.entries.where((e) => e.value).map((e) => e.key).toList();

  // Bouton "Réinitialiser" : remet tout à zéro
  void _reinitialiser() {
    setState(() {
      _nomController.clear();
      _emailController.clear();
      _email = '';
      _notifications = false;
      _interets.updateAll((key, value) => false);
    });
  }

  // Bouton "Valider" / flèche : vérifie la saisie puis va à la page 2
  void _allerPage2() {
    if (_nomController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir votre nom')),
      );
      return;
    }
    // Navigator.push + transmission des données via le constructeur
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          nom: _nomController.text.trim(),
          email: _email.trim(),
          notifications: _notifications,
          interets: _interetsChoisis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon formulaire'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Flèche de navigation vers la page 2
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            tooltip: 'Page suivante',
            onPressed: _allerPage2,
          ),
        ],
      ),
      body: Column(
        children: [
          // Le formulaire occupe l'espace disponible et défile si besoin
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextField avec contrôleur
                  TextField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TextField avec onChanged
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => setState(() => _email = value),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Row : texte à gauche, Switch à droite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recevoir les notifications',
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: _notifications,
                        onChanged: (value) =>
                            setState(() => _notifications = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Centres d\'intérêt',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // Une ligne par CheckBox
                  ..._interets.keys.map(
                    (nom) => Row(
                      children: [
                        Checkbox(
                          value: _interets[nom],
                          onChanged: (value) =>
                              setState(() => _interets[nom] = value ?? false),
                        ),
                        Text(nom),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Deux boutons côte à côte
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _reinitialiser,
                          child: const Text('Réinitialiser'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _allerPage2,
                          child: const Text('Valider'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Zone de synthèse en bas de l'écran (mise à jour en direct)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Synthèse',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Nom : ${_nomController.text}'),
                Text('Email : $_email'),
                Text('Notifications : ${_notifications ? 'Oui' : 'Non'}'),
                Text('Intérêts : ${_interetsChoisis.join(', ')}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// PARTIE 2 : la page qui affiche les données reçues de la page 1
// (StatelessWidget : elle ne fait qu'afficher, rien ne change)

class DetailsPage extends StatelessWidget {
  // Les données arrivent par le constructeur
  final String nom;
  final String email;
  final bool notifications;
  final List<String> interets;

  const DetailsPage({
    super.key,
    required this.nom,
    required this.email,
    required this.notifications,
    required this.interets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Flutter ajoute automatiquement la flèche de retour dans l'AppBar
      appBar: AppBar(
        title: const Text('Récapitulatif'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Nom'),
                    subtitle: Text(nom),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(email.isEmpty ? 'Non renseigné' : email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    subtitle: Text(notifications ? 'Activées' : 'Désactivées'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text('Centres d\'intérêt'),
                    subtitle: Text(
                      interets.isEmpty ? 'Aucun' : interets.join(', '),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Bouton pour revenir à la page 1
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour au formulaire'),
            ),
          ],
        ),
      ),
    );
  }
}
