permSort(X,Y):-
    permutation(X,Y), % generera en permutation
    sorted(Y). % testa om sorterad
sorted([]).
sorted([_]).
sorted([X,Y|L]) :-
    X =< Y ,
sorted([Y|L]).