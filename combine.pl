combine2([], [], []).
combine2([H1|T1], [H2|T2], [H1, H2|Rest]) :- 
    combine2(T1, T2, Rest).


% This function should add one to each element in a list
% map (+1) v in Haskell

addone([], []).
addone([H|T], [H1|T1]) :- 
    H1 is H + 1,
    addone(T, T1).


accRev([H|T],A,R):- accRev(T,[H|A],R).
accRev([],A,A).

rev(L,R):- accRev(L,[],R).