Voici une **documentation technique structurée, claire et professionnelle** pour ton projet **Smart Tasks (Flutter Web)**. Elle est organisée comme dans un **vrai projet logiciel** (utile pour GitHub, portfolio ou rapport).

* * *

Smart Tasks — Documentation Technique
=====================================

**Application Web de Gestion de Tâches avec Flutter**

* * *

1\. Introduction
================

**Smart Tasks** est une application web monopage (Single Page Application - SPA) développée avec **Flutter Web**. Elle permet aux utilisateurs de gérer efficacement leurs tâches quotidiennes à travers une interface moderne, fluide et responsive.

L’objectif principal de l’application est d’offrir une expérience de gestion de tâches **simple, rapide et élégante**, tout en exploitant les capacités modernes du framework Flutter sur le Web.

L’application propose plusieurs fonctionnalités essentielles comme :

*   création et modification de tâches
    
*   suppression de tâches
    
*   marquage de tâches comme terminées
    
*   filtrage et recherche en temps réel
    
*   persistance des données dans le navigateur
    
*   interface responsive adaptée aux écrans desktop, tablette et mobile
    

Le design de l’application est basé sur **Material Design 3**, ce qui garantit une expérience visuelle moderne et cohérente.

* * *

2\. Stack Technologique
=======================

Le projet repose sur une stack technologique moderne et robuste adaptée au développement Flutter Web.

2.1 Framework
-------------

**Flutter SDK (>= 3.0.0)**

Flutter est un framework open-source développé par Google permettant de créer des applications multiplateformes avec un seul code source.

Dans ce projet :

*   Flutter est utilisé en **mode Web**
    
*   **Material Design 3** est activé
    
*   l’application fonctionne comme une **Single Page Application (SPA)**
    

Avantages :

*   performance élevée
    
*   rendu graphique fluide
    
*   interface moderne
    
*   support multiplateforme
    

* * *

2.2 Langage de programmation
----------------------------

**Dart**

Dart est le langage principal utilisé par Flutter.

Caractéristiques :

*   typage fort
    
*   programmation orientée objet
    
*   compilation rapide
    
*   support de la programmation asynchrone
    

* * *

2.3 Gestion d’état
------------------

**Provider (ChangeNotifier)**

Le projet utilise **Provider** pour gérer l’état global de l’application.

Pourquoi Provider ?

*   solution officielle recommandée par Flutter
    
*   architecture simple
    
*   séparation claire entre logique métier et interface
    
*   très performant pour les applications de taille moyenne
    

Le provider principal est :

    TaskProvider
    

Il gère :

*   la liste des tâches
    
*   les opérations CRUD
    
*   les filtres
    
*   la recherche
    
*   la persistance des données
    

* * *

2.4 Stockage local
------------------

**shared\_preferences**

Ce package est utilisé pour stocker les données localement dans le navigateur.

Sur le Web, il utilise :

    LocalStorage
    

Avantages :

*   persistance des données
    
*   aucune base de données nécessaire
    
*   sauvegarde automatique des tâches
    
*   récupération après rechargement de la page
    

Les tâches sont stockées sous forme de **JSON**.

* * *

2.5 Génération d’identifiants
-----------------------------

**uuid**

Chaque tâche possède un identifiant unique généré avec la bibliothèque :

    uuid
    

Avantages :

*   unicité garantie
    
*   évite les collisions d’identifiants
    
*   facilite la gestion des tâches
    

* * *

2.6 Formatage des dates
-----------------------

**intl**

Le package **intl** est utilisé pour formater les dates affichées dans l’interface utilisateur.

Exemple :

    April 12, 2026
    

Cela améliore la lisibilité et l’expérience utilisateur.

* * *

3\. Architecture du Projet
==========================

Le projet adopte une architecture **Feature-based structure**, qui organise le code par fonctionnalité plutôt que par type technique.

Cela rend l’application :

*   plus lisible
    
*   plus maintenable
    
*   plus évolutive
    

Structure principale :

    lib/
    ├── main.dart
    ├── models/
    ├── providers/
    ├── screens/
    ├── theme/
    └── widgets/
    

* * *

4\. Description des Modules
===========================

4.1 main.dart
-------------

Point d’entrée principal de l’application.

Responsabilités :

*   initialiser Flutter
    
*   configurer Provider
    
*   charger le thème
    
*   lancer l’application
    

Exemple simplifié :

    void main() {
      runApp(
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
          child: SmartTasksApp(),
        ),
      );
    }
    

* * *

4.2 models/
-----------

Contient les **modèles de données**.

### task.dart

Représente une tâche.

Attributs principaux :

*   id
    
*   title
    
*   description
    
*   isCompleted
    
*   createdAt
    

Fonctionnalités :

*   sérialisation JSON
    
*   conversion depuis JSON
    
*   conversion vers JSON
    

Cela permet de sauvegarder les tâches dans LocalStorage.

* * *

4.3 providers/
--------------

Contient la **logique métier**.

### task\_provider.dart

Responsabilités :

*   CRUD des tâches
    
*   filtrage
    
*   recherche
    
*   tri
    
*   sauvegarde locale
    

Fonctions principales :

*   addTask()
    
*   updateTask()
    
*   deleteTask()
    
*   toggleTaskCompletion()
    
*   filterTasks()
    
*   searchTasks()
    

* * *

4.4 screens/
------------

Contient les écrans principaux.

### home\_screen.dart

C’est l’écran principal de l’application.

Il contient :

*   header
    
*   filtres
    
*   barre de recherche
    
*   liste des tâches
    

Il utilise un **LayoutBuilder** pour adapter l’interface aux différentes tailles d’écran.

* * *

4.5 theme/
----------

Contient la configuration du thème global.

### app\_theme.dart

Définit :

*   palette de couleurs
    
*   typographie
    
*   bordures
    
*   radius
    
*   styles des boutons
    

Cela permet de garder un design cohérent.

* * *

4.6 widgets/
------------

Contient les composants UI réutilisables.

### app\_header.dart

Affiche :

*   le titre de l’application
    
*   les statistiques
    
*   les compteurs animés
    

* * *

### filter\_bar.dart

Permet de filtrer les tâches :

*   Toutes
    
*   En cours
    
*   Terminées
    

* * *

### search\_bar\_widget.dart

Permet la recherche en temps réel.

* * *

### task\_card.dart

Carte affichant une tâche.

Fonctionnalités :

*   animation hover
    
*   boutons modifier / supprimer
    
*   statut visuel
    

* * *

### task\_form\_dialog.dart

Formulaire pour :

*   créer une tâche
    
*   modifier une tâche
    

Inclut :

*   validation
    
*   gestion des erreurs
    

* * *

### delete\_confirm\_dialog.dart

Boîte de confirmation avant suppression.

* * *

### empty\_state.dart

Affiché lorsque :

*   aucune tâche n’existe
    
*   la recherche ne donne aucun résultat
    

* * *

5\. Fonctionnalités Web et Optimisations
========================================

5.1 Responsive Design
---------------------

L’interface utilise **LayoutBuilder**.

Comportement :

### Desktop

Largeur maximale :

    860px
    

Le contenu est centré pour éviter les lignes trop longues.

* * *

### Mobile / Tablette

L’interface utilise toute la largeur disponible.

Les marges s’adaptent automatiquement.

* * *

5.2 Filtrage et Recherche
-------------------------

La méthode principale dans `TaskProvider` :

    filteredTasks
    

Processus :

1.  appliquer le filtre (statut)
    
2.  appliquer la recherche texte
    
3.  trier par date
    

Résultat :

une liste optimisée pour l’affichage.

* * *

5.3 Interactions Web
--------------------

Flutter Web supporte les **MouseRegion**.

Effets ajoutés :

*   hover
    
*   changement de curseur
    
*   ombre dynamique
    
*   animation légère
    

Cela donne une sensation **application desktop native**.

* * *

5.4 Écran de chargement
-----------------------

Pour éviter l’écran blanc initial de Flutter Web :

Le fichier

    web/index.html
    

contient un **loader HTML/CSS**.

Il disparaît lorsque Flutter est prêt.

Événement utilisé :

    flutter-first-frame
    

* * *

6\. Exécution de l’application
==============================

Lancement en développement
--------------------------

    flutter run -d chrome
    

Cela permet :

*   hot reload
    
*   debug rapide
    

* * *

Build de production
-------------------

    flutter build web --release
    

Cette commande :

*   optimise le code
    
*   supprime le code inutile (tree shaking)
    
*   génère un build léger
    

Les fichiers sont générés dans :

    build/web/
    

* * *

7\. Déploiement
===============

L’application peut être hébergée sur :

*   Netlify
    
*   Vercel
    
*   Firebase Hosting
    
*   GitHub Pages
    
*   Nginx
    

Comme il s’agit d’une application statique.

* * *

8\. Conclusion
==============

Smart Tasks démontre comment Flutter peut être utilisé efficacement pour créer des applications web modernes.

Le projet met en avant :

*   une architecture claire
    
*   une interface moderne
    
*   une expérience utilisateur fluide
    
*   une gestion d’état efficace
    
*   une persistance locale fiable
    

Il constitue un excellent exemple d’application Flutter Web moderne.

* * *

Si tu veux, je peux aussi te faire :

*   **un README GitHub professionnel pour ce projet**
    
*   **une architecture Flutter avancée (Clean Architecture)**
    
*   **un diagramme UML de ton application**.
