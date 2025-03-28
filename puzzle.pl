nationalities([spanish, english, japanese]).
colors([red, blue, green]).
pets([jaguar, snail, zebra]).

% nationality(spanish).
% nationality(english).
% nationality(japanese).
% 
% color(red).
% color(blue).
% 
% pet(jaguar).
% pet(snail).
% pet(zebra).
% 
% 
% left_of(X, Y):-
%     X = house(N1,_,_,_),
%     Y = house(N2,_,_,_),
%     N1 < N2.
% right_of(X, Y):- left_of(Y, X).
% 
% 
% house(1).
% house(2).
% house(3).

left_of_pet_color(Houses, Pet, Color) :-
    member(house(N1, _, _, Pet), Houses),
    member(house(N2, _, Color, _), Houses),
    N1 < N2.
    
right_of_nat_pet(Houses, Nat, Pet) :-
    member(house(N1, Nat, _, _), Houses),
    member(house(N2, _, _, Pet), Houses),
    N1 > N2.

solution(Houses) :-
    Houses = [house(1,N1,C1,P1), house(2,N2,C2,P2), house(3,N3,C3,P3)],
    
    nationalities(Nationalities),
    permutation(Nationalities, [N1,N2,N3]),
    
    colors(Colors),
    permutation(Colors, [C1,C2,C3]),
    
    pets(Pets),
    permutation(Pets, [P1,P2,P3]),
    
    member(house(_, english, red, _), Houses),
    member(house(_, spanish, _, jaguar), Houses),
    left_of_pet_color(Houses, snail, blue),
    right_of_nat_pet(Houses, japanese, snail).

owns_zebra(Nationality) :-
    solution(Houses),
    member(house(_, Nationality, _, zebra), Houses).