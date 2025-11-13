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
