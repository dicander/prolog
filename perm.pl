permutation([], []).
permutation([E|Xs], Ys) :-
    permutation(Xs, Ps),      % Ps is a permutation of the tail Xs
    append(Front, Back, Ps),  % split Ps into all possible prefix/suffix pairs
    append(Front, [E|Back], Ys). % insert E between Front and Back