Compilateur Pascal => C
=======================
Compilation:
  make

Lancement:
  ./prog [fichier source]
  ou bien make run

Résultat d'exécution:
  Le programme affiche le code source traduit en C, suivi de la table des symbole à la fin de l'exécution.
  On produit également un fichier .c du même nom que le fichier pascal d'entrée, contenant la traduction du programme.
    Ce fichier peut alors être compilé manuellement avec gcc, en se conformant au standard c99.
