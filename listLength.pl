listLength([], 0).
listLength([_ | T], N) :-
    listLength(T, NT),
    N is NT + 1.