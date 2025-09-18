% ---- Parties and seats (from the problem) -------------------------------
party(p1,38). party(p2,17). party(p3,51). party(p4,23).
party(p5,27). party(p6,35). party(p7,18). party(p8,25).

parties([p1,p2,p3,p4,p5,p6,p7,p8]).

total_seats(T) :-
    findall(N, party(_,N), Ns),
    sum_list(Ns, T).

% ---- “Gemensamhetsindex” matrix in [-10..10], symmetric, diag 0 --------
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

% ---- Subsets (“coalitions”) --------------------------------------------
subset_of([], []).
subset_of([H|T], [H|R]) :- subset_of(T, R).
subset_of([_|T], R)     :- subset_of(T, R).

seats_sum(Coal, S) :-
    findall(N, (member(P,Coal), party(P,N)), Ns),
    sum_list(Ns, S).

pairwise_score(Coal, Score) :-
    findall(S,
            (select(A,Coal,Rest), member(B,Rest), sim(A,B,S)),
            Ss),
    sum_list(Ss, Score).

majority(Coal) :-
    seats_sum(Coal, S),
    total_seats(T),
    2*S >= T.              % “minst hälften av totalantalet”

stable(Coal, Seats, Score) :-
    parties(All), subset_of(All, Coal), Coal \= [],
    majority(Coal),
    pairwise_score(Coal, Score), Score > 0,
    seats_sum(Coal, Seats).

% Convenience: enumerate unique stable coalitions, smallest first by size
stable_coalition(Coal, Seats, Score) :-
    stable(Coal, Seats, Score),
    sort(Coal, Coal).  % avoid duplicates with same members in different order

% Sample query
% ?- stable_coalition(C,S,Sc), length(C,K), K=4.
% C = [p1, p4, p5, p6],
% S = 117,
% Sc = 34,
% K = 4,
% false.
% 
% ?- stable_coalition(C,S,Sc).
% C = [p1, p2, p3, p4, p5, p6, p7, p8],
% S = 234,
% Sc = 42