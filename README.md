# Projet Industriel
Ce projet vise à évaluer, par la pratique, l’intérêt technique à utiliser Matlab/Simulink pour implémenter efficacement une partie très calculatoire d’un algorithme « orienté traitement radar » (partie FFT) en exploitant de façon efficace les ressources d’un FPGA VERSAL AI-ML. Le travail ne consiste pas à comprendre l’algorithme, mais à l’implémenter efficacement sur la cible, et maitriser la chaine outillée d’utilisation des AIE.

Dans le cadre de ce projet, le travail consistera à   
- Installer les outils et licences d’évaluation en amont
- Prendre en main les outils Matlab/Simulink, les outils d’AMD (ModelComposer, VITIS), et la carte FPGA
- Repartir d’un modèle Matlab/Simulink existant (issu d’un stage précédent), et adapter/optimiser le modèle si nécessaire
- Simuler le modèle à l’aide de ModelComposer
- Implémenter, déboguer, et vérifier le code généré sur FPGA VERSAL VE 2302, à l’aide d’une carte d’évaluation VD100 d’ALINX

## 🧰 Commandes Git de base
### Ajouter / commiter des fichiers
```bash
git add <fichier>     # ajoute un fichier spécifique
git add .             # ajoute tous les fichiers non ignorés
git commit -m "Message clair"
```

### Vérifier l’état et les fichiers suivis
```bash
git status
git ls-files          # fichiers suivis
git check-ignore -v <fichier>  # vérifier si un fichier est ignoré
```
### Branches
```bash
git branch <nom>           # créer une branche
git checkout <nom>         # basculer sur une branche
git checkout -b <nom>      # créer + basculer
git merge <branche_source> # fusionner une branche
```

### Dépôt distant
```bash
git push origin <branche>  # pousser vers le dépôt distant
git pull                   # récupérer les modifications du distant
git pull origin <branche>. # récupérer les modifications d'une branche spécifique 
git remote -v              # voir les dépôts distants
```

### Historique et différences
```bash
git log --oneline --graph --all
git diff           # différences non ajoutées
git diff --staged  # différences ajoutées à l'index
```

## 🌿 Arborescence des branches de développement
```
main
└── develop
    └── develop_name
```
## Notes réunion
- Stage Kylian Canivet (ancien enseirb)
- Extrait algo radar civil (avion ou hélicoptère), radar millimétrique (Attention encombrement— - et consommation — -):
- Calcul matriciel, le déployer sur les 32 coeurs vectoriels et potentiellement de la logique programmable
- Suite Vitis(licence d'évaluation) pour supporter du Matlab/Simulink ==> compatibilité version (site AMD : donner le nom de Franck Jeulin en cas de contact avec le support : Ludovic Bacquart, ludovic.bacquart@amd.com)
- Aller chercher de la doc sur AMD, et sur le fournisseur de la carte
- Pouvoir utiliser ce FPGA afin d'éviter d'utiliser des gros processeurs et gros DSP
- Travailler sur les parties de l'algo énergivore
- Entrée(X4) -> FFC -> FFT1 -> FFT2 -> Calcul du max -> sortie(X2)
- Éclater chaque bloc de l'algo sur plusieurs coeurs AIEngine ==> puis une concaténation
- Génération de C depuis le Matlab/Simulink
- Exécution en simulation : Model Composer (fait partie de Vitis) 
- Exécution sur carte : produire des données et les exploiter (entrée + sortie) et vérifier le fonctionnement
- Générer des données d'entrées
- Distribuer les données aux différents AIE
- Effectuer les traitements
- Sortir les données en sortie de l'algo
- Démonstration : montrer les différences de temps d'exécution avant et après ce portage

MONSIEUR JEULIN A DIT : NE COMPRENEZ PAS L'ALGORITHME, PORTAGE DE L'ALGORITHME
