:- encoding(utf8).
% Uppgift 4: binära träd.
%
% Representation:
%   nil                      tomt träd
%   leaf(V)                  löv med värde V
%   branch(V, Left, Right)   nod med värde V och två delträd
%
% Exempelträdet från uppgiften:
%   branch(1, branch(2, leaf(3), leaf(4)),
%             branch(5, nil, branch(6, leaf(7), leaf(8))))
%
% Ändrat 2026-09-17: snitten (!) är borttagna. De ändrade inga svar, eftersom
% funktorerna nil/leaf/branch utesluter varandra och SWI-Prolog indexerar på
% första argumentet; de var gröna snitt och därmed överflödiga.

:- nb_setval(tree, branch(1, branch(2, leaf(3), leaf(4)),
                             branch(5, nil, branch(6, leaf(7), leaf(8))))).
% Gör det möjligt att skriva:  ?- nb_getval(tree, T), treesum(T, S).

% sum/2 i uppgiften: summan av alla värden.
treesum(nil, 0).
treesum(leaf(V), V).
treesum(branch(V, L, R), S) :-
    treesum(L, SL),
    treesum(R, SR),
    S is V + SL + SR.

max(X, Y, X) :- X >= Y.
max(X, Y, Y) :- X < Y.

% height/2 i uppgiften. Här räknas noder på den längsta vägen från roten till
% ett löv: ett löv har höjd 1 och exempelträdet höjd 4. Vill man räkna kanter
% ("avstånd") byter man basfallet till treeheight(leaf(_), 0); svaret blir då 3.
treeheight(nil, 0).
treeheight(leaf(_), 1).
treeheight(branch(_, L, R), H) :-
    treeheight(L, HL),
    treeheight(R, HR),
    max(HL, HR, M),
    H is M + 1.

% Namnen från uppgiftsbladet, för den som vill fråga med dem:
sum(T, S) :- treesum(T, S).
height(T, H) :- treeheight(T, H).
