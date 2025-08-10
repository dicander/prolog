% Is the left list a subset of the right one
% We have to check if every element has a counterpart in the right one.
mysubset([],_).
mysubset([H1|T1],Right) :-
    member(H1, Right),
    mysubset(T1, Right).


mysuperset(Left, Right) :-
    mysubset(Right, Left).