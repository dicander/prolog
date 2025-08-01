tran(eins,one).
tran(zwei,two).
tran(drei,three).
tran(vier,four).
tran(fuenf,five).
tran(sechs,six).
tran(sieben,seven).
tran(acht,eight).
tran(neun,nine).

listtran([], []).

listtran([H|T], [EnglishWord|Rest]) :-
    tran(H,EnglishWord),
    listtran(T, Rest).