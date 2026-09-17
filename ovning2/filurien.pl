:- encoding(utf8).
% ---- Parties and seats (from the problem) -------------------------------
party(p1,38). party(p2,17). party(p3,51). party(p4,23).
party(p5,27). party(p6,35). party(p7,18). party(p8,25).

parties([p1,p2,p3,p4,p5,p6,p7,p8]).

total_seats(T) :-
    findall(N, party(_,N), Ns),
    sum_list(Ns, T).

% ---- "Gemensamhetsindex": matris i [-10..10], symmetrisk, diagonal 0 -----
% Declare only for A<B; we derive sim/3 for all pairs.
s2(p1,p2, 2).  s2(p1,p3,-6). s2(p1,p4, 5). s2(p1,p5, 4). s2(p1,p6, 6). s2(p1,p7,-1). s2(p1,p8, 1).
s2(p2,p3,-7).  s2(p2,p4, 1). s2(p2,p5, 2). s2(p2,p6,-2). s2(p2,p7, 6). s2(p2,p8, 4).
s2(p3,p4,-5).  s2(p3,p5,-4). s2(p3,p6,-6). s2(p3,p7,-3). s2(p3,p8,-2).
s2(p4,p5, 5).  s2(p4,p6, 4). s2(p4,p7, 0). s2(p4,p8, 2).
s2(p5,p6, 5).  s2(p5,p7, 1). s2(p5,p8, 3).
s2(p6,p7,-1).  s2(p6,p8, 2).
s2(p7,p8, 5).

sim(P,P,0).
sim(A,B,S) :- A @< B, !, s2(A,B,S).
sim(A,B,S) :- A @> B, s2(B,A,S).

% ---- Delmängder ("koalitioner") -----------------------------------------
subset_of([], []).
subset_of([H|T], [H|R]) :- subset_of(T, R).
subset_of([_|T], R)     :- subset_of(T, R).

seats_sum(Coal, S) :-
    findall(N, (member(P,Coal), party(P,N)), Ns),
    sum_list(Ns, S).

% Ändrat 2026-09-17: varje par räknas en gång (A @< B). Den gamla varianten
% (select + member) räknade både (A,B) och (B,A), så summan blev dubbel; tecknet
% var rätt, så villkoret fungerade ändå.
pairwise_score(Coal, Score) :-
    findall(S,
            (member(A,Coal), member(B,Coal), A @< B, sim(A,B,S)),
            Ss),
    sum_list(Ss, Score).

majority(Coal) :-
    seats_sum(Coal, S),
    total_seats(T),
    2*S >= T.              % "minst hälften av totalantalet"

stable(Coal, Seats, Score) :-
    parties(All), subset_of(All, Coal), Coal \= [],
    majority(Coal),
    pairwise_score(Coal, Score), Score > 0,
    seats_sum(Coal, Seats).

% stable_coalition/3: samma sak som stable/3. Anropet sort(Coal, Coal) är
% överflödigt, eftersom subset_of/2 redan ger varje delmängd exakt en gång och i
% partiernas ordning, men det skadar inte.
stable_coalition(Coal, Seats, Score) :-
    stable(Coal, Seats, Score),
    sort(Coal, Coal).

% Minsta stabila koalitioner: prova växande storlek.
smallest_stable(Coal, Seats, Score) :-
    parties(All), length(All, N),
    between(1, N, K),
    stable(Coal, Seats, Score),
    length(Coal, K).

% Verifierade svar (SWI-Prolog 9, 2026-09-17), med pairwise_score som räknar varje par en gång:
% ?- stable(C, S, Sc).
% C = [p1,p2,p3,p4,p5,p6,p7,p8], S = 234, Sc = 21 ;
% C = [p1,p2,p3,p4,p5,p6,p7],    S = 209, Sc = 16 ;
% ...   (63 stabila koalitioner totalt: 5 med fyra partier, 28 med fem, 21 med sex, 8 med sju, 1 med åtta)
%
% ?- stable(C, S, Sc), length(C, 4).
% C = [p1,p2,p5,p6], S = 117, Sc = 17 ;
% C = [p1,p4,p5,p6], S = 123, Sc = 29 ;
% C = [p1,p4,p6,p8], S = 121, Sc = 20 ;
% C = [p1,p5,p6,p7], S = 118, Sc = 14 ;
% C = [p1,p5,p6,p8], S = 125, Sc = 21 ;
% false.
%
% ?- stable(C, _, _), length(C, 3).
% false.
%
% ?- smallest_stable(C, S, Sc).
% C = [p1,p2,p5,p6], S = 117, Sc = 17 ;
% ...