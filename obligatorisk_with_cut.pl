obligatorisk(logik).
valfri(K):-obligatorisk(K),!,fail.
valfri(_).