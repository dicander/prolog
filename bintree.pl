% treesum(branch(1, branch(2, leaf(3), leaf(4)), branch(5, nil, branch(6, leaf(7), leaf(8)))),N).

:- nb_setval(tree, branch(1, branch(2, leaf(3), leaf(4)), branch(5, nil, branch(6, leaf(7), leaf(8))))).
% The above makes this possible:
%  nb_getval(tree, T), treesum(T, N).

treesum(leaf(X), X) :-
    !.
treesum(nil, 0) :-
    !.
treesum(branch(X, L, R), S) :-
    treesum(L, SL),
    treesum(R, SR),
    S is X + SL + SR.


max(X, Y, X) :-
    X >= Y,
    !.
max(X, Y, Y) :-
    X < Y,
    !.


treeheight(leaf(_), 1) :-
    !.
treeheight(nil, 0) :-
    !.
treeheight(branch(_, L, R), H) :-
    treeheight(L, HL),
    treeheight(R, HR),
    max(HL, HR, TallestBranch),
    H is TallestBranch + 1.


