% Slow, but pedagogically useful that uses append/3.
% Do not use this in production code.

revappend([], []).
revappend([H|T], Answer) :-
    revappend(T, RevT),
    append(RevT, [H], Answer).
    

rev(List, Reversed) :-
    reverse_helper(List, [], Reversed).

reverse_helper([], Acc, Acc):-!.
reverse_helper([H|T], Acc, Reversed) :-
    reverse_helper(T, [H|Acc], Reversed).


