:- encoding(utf8).
% Uppgift 5: permutationer.

% Version 1 (den som uppgiftsbladet leder till, via select/3):
% en permutation av L är något element X ur L följt av en permutation av resten.
permute([], []).
permute(L, [X|P]) :-
    select(X, L, R),
    permute(R, P).

% Version 2 (repots ursprungliga): permutera svansen, stoppa in huvudet på varje plats.
permutation([], []).
permutation([E|Xs], Ys) :-
    permutation(Xs, Ps),          % Ps är en permutation av svansen Xs
    append(Front, Back, Ps),      % dela Ps i alla par prefix/suffix
    append(Front, [E|Back], Ys).  % stoppa in E mellan dem

% Båda ger n! svar vid backtracking, i olika ordning:
% ?- permute([1,2,3], F).       F = [1,2,3] ; [1,3,2] ; [2,1,3] ; [2,3,1] ; [3,1,2] ; [3,2,1].
% ?- permutation([1,2,3], F).   F = [1,2,3] ; [2,1,3] ; [2,3,1] ; [1,3,2] ; [3,1,2] ; [3,2,1].
