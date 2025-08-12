permsort(In, Out) :-
    permutation(In, Out),
    sorted(Out).


my_permutation([], []).
my_permutation([H|T], P) :-
    my_permutation(T, PT),
    select(H, P, PT).

my_sorted([]).
my_sorted([_]).
my_sorted([A, B | Rest]) :-
    A =< B,
    my_sorted([B | Rest]).