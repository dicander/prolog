:- encoding(utf8).
% Kör: swipl -q -g run_tests -t halt test_ovn2.pl
% Testar alla lösningar till DD1351 övning 2 (uppgift 3-7).
:- use_module(library(plunit)).

:- begin_tests(ovn2).

test(removelast) :- consult(ovn2),
    removelast([1,2,3], [1,2]), removelast([7], []), \+ removelast([], _),
    removelast2([1,2,3], [1,2]).

test(bintree, [nondet]) :- consult(bintree),
    nb_getval(tree, T), treesum(T, 36), treeheight(T, 4),
    treeheight(nil, 0), treeheight(leaf(9), 1).

test(perm) :- consult(perm),
    findall(F, permute([1,2,3], F), Fs), length(Fs, 6),
    msort(Fs, [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]),
    findall(F, permutation([1,2,3,4], F), Gs), length(Gs, 24).

test(filurien) :- consult(filurien),
    total_seats(234),
    findall(C, stable(C, _, _), All), length(All, 63),
    findall(C, (member(C, All), length(C, 4)), Four), length(Four, 5),
    \+ ( member(C, All), length(C, 3) ),
    parties(P), pairwise_score(P, 21),
    once(smallest_stable([p1,p2,p5,p6], 117, 17)).

test(scheduling, [nondet]) :- consult(scheduling),
    no_teacher_conflicts,
    student_requirements(s_marcus, [da101-exam, da101-lab1, ma201-exam, pr301-demo]),
    student_requirements(s_ella, [ma201-exam]),
    findall(Cs, feasible_mandatory_schedule(s_marcus, Cs), Sch), length(Sch, 3),
    student_ok(s_marcus).

:- end_tests(ovn2).
