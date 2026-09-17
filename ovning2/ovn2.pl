:- encoding(utf8).
% Övning 2, DD1351: hjälppredikaten från uppgiftsbladet och uppgift 3.
% (Oförändrat i sak sedan repot; radsluten är LF och removelast2/2 är tillagd.)

append([], L, L).
append([H|T], L, [H|R]) :-
    append(T, L, R).

select(X, [X|T], T).
select(X, [Y|T], [Y|R]) :-
    select(X, T, R).

member(X, L) :-
    select(X, L, _).
memberchk(X, L) :-
    select(X, L, _), !.

% Uppgift 3: ta bort sista elementet.
% Basfallet är listan med ett element, inte den tomma listan:
% removelast([], R) ska misslyckas eftersom det inte finns något att ta bort.
removelast([_], []).
removelast([H|T], [H|R]) :-
    removelast(T, R).

% Samma relation uttryckt med append/3: L är R följt av en lista med exakt ett element.
removelast2(L, R) :-
    append(R, [_], L).
