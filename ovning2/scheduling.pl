:- encoding(utf8).
/* Uppgift 7, DD1351 övning 2: skolschema som databas.
   Ändrat 2026-09-17: student_mandatory_types/3 och student_requirements/2 är
   rättade (fria variabler i setof), se kommentaren vid dem. Verifierade svar
   finns längst ner i filen.

   ------------------ DATA MODELL ------------------

Core entities:
  - teacher/1, student/2, program/1 (optional)
  - course/2            : CourseId, CourseName
  - teaches/2           : Teacher, Course
  - enrolled/2          : Student, Course
  - session/7           : Course, SessId, Day, StartMin, EndMin, Type, Mandatory
                          Day ∈ {mon,tue,wed,thu,fri}, time in minutes since 00:00
                          Type is an atom (e.g., lecture, lab1, exam)
                          Mandatory ∈ {yes,no}

Constraints/queries we want:
  - Teachers cannot teach overlapping sessions across their courses
  - Students may be enrolled in overlapping courses, BUT:
      For each mandatory "Type" in each enrolled course, a student must be able
      to attend at least one offering without clashing with all other chosen mandatory sessions.

--------------------------------------------------- */

% ---- Example domain data ----------------------------------------------
teacher(t_alice). teacher(t_bob). teacher(t_caro).

program(cs). program(math).

student(s_marcus, cs).
student(s_ella,   math).

course(da101, 'Declarative Programming').
course(ma201, 'Math Structures').
course(pr301, 'Programming 3').

teaches(t_alice, da101).
teaches(t_bob,   ma201).
teaches(t_caro,  pr301).

enrolled(s_marcus, da101).
enrolled(s_marcus, ma201).
enrolled(s_marcus, pr301).
enrolled(s_ella,   ma201).

% session(Course, SessId, Day, StartMin, EndMin, Type, Mandatory).
% DA101 has two alternative mandatory labs, plus lectures (not mandatory), and one exam (mandatory)
session(da101, lab1a, tue,  10*60, 12*60, lab1,   yes).
session(da101, lab1b, wed,  14*60, 16*60, lab1,   yes).
session(da101, lect1, mon,   9*60, 11*60, lecture, no).
session(da101, exam,  fri,  13*60, 16*60, exam,   yes).

% MA201 has a mandatory exam; two optional help sessions
session(ma201, exam,  thu,  13*60, 15*60, exam,   yes).
session(ma201, help1, tue,  10*60, 11*60, help,   no).
session(ma201, help2, wed,  10*60, 11*60, help,   no).

% PR301 has a mandatory demo, offered twice (choose one)
session(pr301, demo1, tue,  11*60+30, 12*60+30, demo, yes).
session(pr301, demo2, thu,  15*60,    16*60,    demo, yes).

% ---- Time overlap helper ----------------------------------------------
overlap(Day, S1, E1, Day, S2, E2) :- S1 < E2, S2 < E1.

% ---- (1) Teacher conflict check ---------------------------------------
teacher_conflict(Teacher, C1-Sess1, C2-Sess2) :-
    teaches(Teacher, C1),
    teaches(Teacher, C2),
    C1 \= C2,
    session(C1, Sess1, D, A, B, _, _),
    session(C2, Sess2, D, C, E, _, _),
    overlap(D, A, B, D, C, E).
% Varje krock ges åt båda hållen (C1,C2) och (C2,C1). Vill man lista varje krock
% en gång: byt C1 \= C2 mot C1 @< C2.

no_teacher_conflicts :-
    \+ (teacher_conflict(_, _, _)).

% ---- (2) Student mandatory feasibility --------------------------------
% For each enrolled course, collect mandatory "types" and require the student
% to pick exactly one session per (Course,Type) with NO time clashes overall.

mandatory_offer(Course, Type, SessId) :-
    session(Course, SessId, _, _, _, Type, yes).

% Ändrat 2026-09-17. De gamla versionerna skrev session/7 direkt inne i setof
% med anonyma variabler (_) för dag, start och slut. Anonyma variabler är fria
% variabler för setof, så svaren grupperades per (dag, start, slut) och det
% avslutande snittet behöll bara första gruppen: student_requirements(s_marcus, R)
% gav [da101-exam] i stället för fyra krav. Lösningen är att lägga målet i ett
% eget predikat, så att hjälpvariablerna inte syns för setof.

% mandatory_type(Course, Type): Type är ett obligatoriskt moment i Course.
mandatory_type(Course, Type) :-
    session(Course, _, _, _, _, Type, yes).

student_mandatory_types(Student, Course, Types) :-
    enrolled(Student, Course),
    setof(Type, mandatory_type(Course, Type), Types), !.
student_mandatory_types(_, _, []).

% requirement(Student, Course-Type): studenten läser Course, som har det
% obligatoriska momentet Type.
requirement(Student, Course-Type) :-
    enrolled(Student, Course),
    mandatory_type(Course, Type).

% collect all (Course,Type) pairs the student must cover
student_requirements(Student, Reqs) :-
    setof(CT, requirement(Student, CT), Reqs), !.
student_requirements(_, []).

% choose one offering for each required (Course,Type), with global non-overlap
feasible_mandatory_schedule(Student, ChoiceSet) :-
    student_requirements(Student, Reqs),
    choose_nonoverlapping(Student, Reqs, [], ChoiceSet).

choose_nonoverlapping(_, [], Acc, Acc).
choose_nonoverlapping(Student, [Course-Type|Rs], Acc, Out) :-
    mandatory_offer(Course, Type, SessId),
    session(Course, SessId, D, A, B, _, yes),
    % check against Acc for overlap
    \+ ( member(_C2- _T2 - sess(D2,A2,B2,_Sess2), Acc),
         overlap(D, A, B, D2, A2, B2)
       ),
    choose_nonoverlapping(Student, Rs, [Course-Type-sess(D,A,B,SessId)|Acc], Out).

% Convenience: Yes/No answer
student_ok(Student) :-
    feasible_mandatory_schedule(Student, _ChoiceSet).

% To list the teacher conflicts
list_teacher_conflicts :-
    teacher_conflict(T, C1-S1, C2-S2),
    format('~w: ~w/~w overlaps ~w/~w~n', [T,C1,S1,C2,S2]),
    fail ; true.

/* ------------------ HOW TO USE ----------------------------------------

1) Teacher conflicts:
?- teacher_conflict(T, C1-S1, C2-S2).
   % lists any overlapping sessions for a given teacher (if data has conflicts)

?- no_teacher_conflicts.
   % succeeds iff there are no clashes among all teachers

2) Student mandatory feasibility:
?- student_requirements(s_marcus, Reqs).
   % lists required (Course,Type) pairs Marcus must cover

?- feasible_mandatory_schedule(s_marcus, ChoiceSet).
   % returns one valid set of non-overlapping mandatory sessions (backtracks for more)

?- student_ok(s_marcus).
   % yes/no if such a selection exists

You can extend:
- Add more session "Type"s (lab2, project_demo, re_exam, etc.)
- Add parallel offerings by duplicating session/7 with same (Course,Type) at different times
- Add rooms and room_conflict/… if you want to prevent double-booking rooms
- Add program/1 links (e.g., course_program/2) if you need program-specific queries

----------------------------------------------------------------------- */

% More examples:
% feasible_mandatory_schedule(s_marcus, Cs), member(_C-_-sess(D,_,_,_), Cs).

/* Verifierade svar (SWI-Prolog 9, 2026-09-17):

?- student_requirements(s_marcus, Reqs).
Reqs = [da101-exam, da101-lab1, ma201-exam, pr301-demo].

?- feasible_mandatory_schedule(s_marcus, Cs).
Cs = [pr301-demo-sess(thu,15*60,16*60,demo2), ma201-exam-sess(thu,13*60,15*60,exam),
      da101-lab1-sess(tue,10*60,12*60,lab1a), da101-exam-sess(fri,13*60,16*60,exam)] ;
Cs = [pr301-demo-sess(tue,11*60+30,12*60+30,demo1), ma201-exam-sess(thu,13*60,15*60,exam),
      da101-lab1-sess(wed,14*60,16*60,lab1b), da101-exam-sess(fri,13*60,16*60,exam)] ;
Cs = [pr301-demo-sess(thu,15*60,16*60,demo2), ma201-exam-sess(thu,13*60,15*60,exam),
      da101-lab1-sess(wed,14*60,16*60,lab1b), da101-exam-sess(fri,13*60,16*60,exam)] ;
false.

?- no_teacher_conflicts.
true.

Lägger man till teaches(t_alice, ma201) får man:
?- teacher_conflict(T, A, B).
T = t_alice, A = da101-lab1a, B = ma201-help1 ;
T = t_alice, A = ma201-help1, B = da101-lab1a.
*/