Compilateur Pascal => C
=======================
Compilation:
  make

Lancement:
  ./prog [fichier source] [options]
  ou bien make run (équivalent à ./prog test.pas, sans arguments)
  Exemple de ligne de commande:
    ./prog test.pas -noCPrint

Arguments optionnels:
    -noTable    supprime l’affichage de la table des symboles
    -noCPrint   supprime l’affichage de la traduction (le fichier .c est tout de même produit)
    -noCFile    supprime la production d’un fichier .c contenant la traduction

Résultat d'exécution:
  Le programme affiche le code source traduit en C, suivi de la table des symbole à la fin de l'exécution.
  On produit également un fichier .c du même nom que le fichier pascal d'entrée, contenant la traduction du programme.
    Ce fichier peut alors être compilé manuellement avec gcc, en se conformant au standard c99.
