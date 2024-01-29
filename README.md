# Rendu du Projet Développement Mobile Flutter

## Auteur
Corentin LIZY

## Fonctionnalités Développées

### 1. Authentification

- Utilisation de l'authentification pour permettre aux utilisateurs de se connecter à l'application.
- Lien entre l'e-mail de l'utilisateur dans Firestore Database et l'authentification pour connecter l'utilisateur à l'application.

   Identifiant : clizy
   Mot de passe : Test12

### 2. Panier

- Affichage du panier avec le prix total en haut.
- Possibilité de voir les articles présents dans le panier.
- Fonctionnalité de suppression des articles du panier si nécessaire.

### 3. Profil

- Possibilité de modifier les informations de l'utilisateur.
- Tous les champs sont requis par défaut pour la validation du formulaire de modification.
- Bouton de déconnexion dans l'action en haut pour déconnecter l'utilisateur.

### 4. Activité

- Liste les activités avec une flèche pour voir les détails.
- Animation lors de la transition vers les détails de l'activité.
- Animation lorsque l'on ajoute l'activité au panier.
- Bouton "+" dans l'action de l'app bar navigation pour ajouter une activité.

### 5. Ajout d'une Activité

- Possibilité d'ajouter une activité avec les catégories : Boxe, Tennis, Cyclisme, Lecture.
- Lors de l'ajout d'une photo, un modèle TensorFlow Lite (créé avec Teachable Machine) réalise une prédiction pour déterminer la catégorie, qui est automatiquement remplie si elle est reconnue.
- Tous les autres champs sont requis pour ajouter l'activité.
- Redirection vers la page des activités après l'ajout.

### Problème Connus

- Les activités ne se mettent pas à jour au retour.
