#!/bin/bash
# Script pour télécharger Flutter et compiler l'application sur Vercel

echo "🔧 Téléchargement du SDK Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "✅ Vérification de l'installation Flutter..."
flutter --version

echo "📦 Téléchargement des dépendances..."
flutter pub get

echo "🚀 Compilation de l'application Web..."
flutter build web --release

echo "✨ Compilation terminée avec succès !"
