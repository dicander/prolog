concatenate([], Y, Y).
concatenate([HX | TX], Y, [HX | TZ]) :-
    concatenate(TX, Y, TZ).