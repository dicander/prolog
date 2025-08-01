directTrain(forbach,saarbruecken).
directTrain(freyming,forbach).
directTrain(fahlquemont,stAvold).
directTrain(stAvold,forbach).
directTrain(saarbruecken,dudweiler).
directTrain(metz,fahlquemont).
directTrain(nancy,metz).

connected(X,Y) :- directTrain(X,Y).
connected(X,Y) :- directTrain(Y,X).

travelbetween(X,Y) :-
    travelbetween(X,Y,[X]).

travelbetween(X,Y,_) :-
    connected(X,Y).

travelbetween(X,Y,Visited) :-
    connected(X,Z),
    \+ member(Z,Visited),
    travelbetween(Z,Y,[Z|Visited]).