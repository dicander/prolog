% läser (S, K): studenten S läser kursen K.
läser(anna, logik).
läser(anna, algoritmer).
läser(bo, logik).
% undervisar (L, K): läraren L undervisar på kursen K.
undervisar(lena, logik).
undervisar(omar, algoritmer).
% har_lärare(S, L): studenten S har L som lärare.
har_lärare(S, L) :- läser(S, K), undervisar(L, K).
