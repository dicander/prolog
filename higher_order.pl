use_module(library(apply)).


factorial(N, F) :-
    numlist(1, N, V),
    foldl([X,Acc0, Acc]>>(Acc is Acc0*X), V, 1, F).


squares(Unsquared, Squared) :-
    maplist([X, Y]>>(Y is X*X), Unsquared, Squared).
