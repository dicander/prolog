

max(X, Y, X) :- 
    Y<X.


max(X, Y, Y).
height(leaf, 0).
height(branch(TL, TR), N) :-
    height(TL, NL),
    height(TR, NR),
    max(NL, NR, M),
    N is M+1.

complete(leaf).
complete(branch(TL, TR)) :-
    complete(TL),
    complete(TR),
    height(TL, N),
    height(TR, N).

lookup(D, leaf(D)).
lookup(D, branch(D, _, _)).
lookup(D, branch(_, TL, _)) :- lookup(D, TL).
lookup(D, branch(_, _, TR)) :- lookup(D, TR).

treesum(leaf(N), N).
treesum(branch(N, TL, TR), N1) :-
treesum(TL, NL),
treesum(TR, NR),
N1 is NL+NR+N.