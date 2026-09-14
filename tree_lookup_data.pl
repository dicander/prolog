lookup(D,leaf(D)).
lookup(D,branch(D,_,_)).
lookup(D,branch(_,TL,_)):- 
    lookup(D,TL).
lookup(D,branch(_,_,TR)):- 
    lookup(D,TR).
