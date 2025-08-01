% Gender of each member
female(victoria).
female(sofia).
female(madeleine).
female(silvia).
female(estelle).
female(ines).
female(leonore).
female(adrienne).
male(carl_gustaf).
male(daniel).
male(carl_philip).
male(chris).
male(oscar).
male(alexander).
male(gabriel).
male(julian).
male(nicholas).

% Parent relationships
parent(carl_gustaf, victoria).
parent(silvia, victoria).
parent(carl_gustaf, carl_philip).
parent(silvia, carl_philip).
parent(carl_gustaf, madeleine).
parent(silvia, madeleine).
parent(victoria, estelle).
parent(daniel, estelle).
parent(victoria, oscar).
parent(daniel, oscar).
parent(carl_philip, alexander).
parent(sofia, alexander).
parent(carl_philip, gabriel).
parent(sofia, gabriel).
parent(carl_philip, julian).
parent(sofia, julian).
parent(carl_philip, ines).
parent(sofia, ines).
parent(madeleine, leonore).
parent(chris, leonore).
parent(madeleine, adrienne).
parent(chris, adrienne).
parent(madeleine, nicholas).
parent(chris, nicholas).

% Define mother
mother(Mother, Child) :-
    female(Mother),
    parent(Mother, Child).

% Define father
father(Father, Child) :-
    male(Father),
    parent(Father, Child).

% Define offspring
offspring(Child, Parent) :-
    parent(Parent, Child).

% Define daughter
daughter(Daughter, Parent) :-
    female(Daughter),
    parent(Parent, Daughter).

% Define son
son(Son, Parent) :-
    male(Son),
    parent(Parent, Son).


% Define grandparent
grandparent(Grandparent, Grandchild) :-
    parent(Grandparent, Parent),
    parent(Parent, Grandchild).

% Define grandmother
grandmother(Grandmother, Child) :-
    female(Grandmother),
    grandparent(Grandmother, Child).

% Define grandfather
grandfather(Grandfather, Child) :-
    male(Grandfather),
    grandparent(Grandfather, Child).

% Define grandchild
grandchild(Grandchild, Grandparent) :-
    grandparent(Grandparent, Grandchild).

% Define sibling. Two people are siblings if they share both parents.
sibling(Sibling1, Sibling2) :-
    father(Parent1, Sibling1),
    father(Parent1, Sibling2),
    mother(Parent2, Sibling1),
    mother(Parent2, Sibling2),
    Sibling1 \= Sibling2.

% Define brother
brother(Sibling1, Sibling2) :-
    sibling(Sibling1, Sibling2),
    male(Sibling1).

% Define sister
sister(Sibling1, Sibling2) :-
    sibling(Sibling1, Sibling2),
    female(Sibling1).


