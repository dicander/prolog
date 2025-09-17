maxFail(X, Y, Z) :- X>Y, Z=X.
maxFail(X, Y, Z) :- Z=Y.

maxCut(X, Y, Z) :- X>Y, !, Z=X.
maxCut(X, Y, Z) :- Z=Y.