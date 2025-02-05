// ignore_for_file: camel_case_types

import 'dart:io';

class Aventurier {
  // Attributs
  String nom;
  int nombreVie;

  // Constructeur
  Aventurier(this.nom, {this.nombreVie = 3});

  // Methodes
  void perdreVie() {
    if (nombreVie > 0) {
      nombreVie--;

      if (nombreVie > 0) {
        print("Oups !!! Il vous reste $nombreVie vie(s).");
      } else {
        print("Oups !!! Il vous reste aucune vie, la partie est terminée.");
      }
    } else {
      print("La partie est terminée pour $nom.");
    }
  }
}

// Classe abstraite obstacle
abstract class obstacle {
  Future<void> affronter(Aventurier joueur);
}

// Sous classe enigmes
class enigme extends obstacle {
  String question;
  String reponseCorrecte;

  // Constructeur
  enigme(this.question, this.reponseCorrecte);

  @override
  Future<void> affronter(Aventurier joueur) async {
    while (true) {
      print("enigme : $question");
      stdout.write(" Reponse ");
      String? reponseCorrecte = stdin.readLineSync()?.trim().toLowerCase();

      if (reponseCorrecte == reponseCorrecte?.toLowerCase()) {
        print("Bonne reponse !");
        break;
      } else {
        print(" Mauvaise reponse !");
        joueur.perdreVie();
        if (joueur.nombreVie == 0) return;
      }
    }
  }
}

// Sous classe piège
class piege extends obstacle {
  @override
  Future<void> affronter(Aventurier joueur) async {
    print("Un piège se déclenche...");
    await Future.delayed(Duration(seconds: 2));

    bool succes = random().nextbool();
    if (succes) {
      print("Tu as reussi à éviter le piège !");
    } else {
      print("Aie !!! Tu as échoué à éviter le piège !");
      joueur.perdreVie();
    }
  }

  random() {}
}

// Sous classe gardien
class gardien extends obstacle {
  @override
  Future<void> affronter(Aventurier joueur) async {
    print("Un gardien bloque le passage !");
    stdout.write("Que fais-tu ? (combattre/négocier)");
    String? choix = stdin.readLineSync()?.trim().toLowerCase();
    if (choix == "Combattre") {
      bool victoire = random().nextBool();
      await Future.delayed(Duration(seconds: 2));
      if (victoire) {
        print("Tu as vaincu le gardien !");
      } else {
        print("Tu as été vaincu par le gardien !");
        joueur.perdreVie();
      }
    } else {
      print("Tu as négocier avec le gardien et tu as gagné !");
    }
  }

  random() {}
}

// Classe lieu
class lieu {
  String nom;
  List<obstacle> obstacles;

  // Constructeur
  lieu(this.nom, this.obstacles);

  // Methodes 
  Future<void> explorer(Aventurier joueur) async {
    print("Bienvenue à $nom");
    for (var obstacle in obstacles) {
      await obstacle.affronter(joueur);
      if (joueur.nombreVie == 0) return;
    }
    print("Félicitations, tu as terminé le jeu  $nom !");
  }
}

void main() async {
  stdout.write("Quel est ton nom, aventurier ? ");
  String? nom = stdin.readLineSync();
  Aventurier joueur = Aventurier(nom ?? "Héros");

  lieu foretMystique = lieu("Forêt Mystique", [
    enigme("Je suis toujours devant toi, mais tu ne peux jamais me voir. Qui suis-je ?", "Le futur"),
    piege(),
    gardien(),
  ]);

  lieu templeAncien = lieu("Temple Ancien", [
    piege(),
    enigme("Plus tu en prends, plus tu en laisses derrière toi. Que suis-je ?", "Des pas"),
    gardien(),
  ]);

  List<lieu> lieux = [foretMystique, templeAncien];

  print("\n L'aventure commence !");
  for (var lieu in lieux) {
    await lieu.explorer(joueur);
  }

  print("\n BRAVO ! Tu as terminé l'aventure !");
}
