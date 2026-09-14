filnamn(fil(N),[N]).
filnamn(mapp(_,Innehåll),NL):-
    filnamnLst(Innehåll,NL).
filnamnLst([],[]).
filnamnLst([FS|Rest],NL):-
    filnamn( FS,NL1),
    filnamnLst(Rest,NL2),
    append(NL1,NL2,NL).