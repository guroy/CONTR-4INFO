/* TP08
*
* année 2015 - 2016
* Roy Guillaume - Hortet Florentin
*
*/

:-lib(ic).
:-lib(ic_symbolic).

?- local domain(sexe(femme,homme)).

/* Question 8.1 "les femmes disent toujours la vérité" 
affirme(?S,?A).*/

affirme(S,A):-
        (S &= femme) => (A #=1).

/* Question 8.2 "Les hommes alternent vérité et mensonge" 
affirme(?S,?A1,?A2).*/

affirme(S,A1,A2):-
		(S &= homme) => ((A1 #=1 and A2 #=0) or (A1 #=0 and A2 #=1)).

/* Question 8.3 Domaine et contraintes de domaines*/

domaine_contraint(Parent1,Parent2,Enfant,AffE,AffEselonP1,AffP1,Aff1P2,Aff2P2):-
		Parent1 &:: sexe,
		Parent2 &:: sexe,
		Enfant &:: sexe,
		AffEselonP1 #:: 0..1,
		AffP1 #:: 0..1,
		Aff1P2 #:: 0..1,
		Aff2P2 #:: 0..1,
		AffE #:: 0..1.

/* Question 8.4 contraintes du problème et solveur*/

solve(Parent1,Parent2,Enfant,AffE,AffEselonP1,AffP1,Aff1P2,Aff2P2):-
		domaine_contraint(Parent1,Parent2,Enfant,AffE,AffEselonP1,AffP1,Aff1P2,Aff2P2),
		contraintes(Parent1,Parent2,Enfant,AffE,AffEselonP1,AffP1,Aff1P2,Aff2P2),
		labeling([AffE,AffEselonP1,AffP1,Aff1P2,Aff2P2]),
		labeling_symb([Parent1,Parent2,Enfant]).

contraintes(Parent1,Parent2,Enfant,AffE,AffEselonP1,AffP1,Aff1P2,Aff2P2):-
        (AffEselonP1 #= 1 and AffE #= 1) => (Enfant &= femme),
        AffP1 #= (AffEselonP1 #= AffE),
        Aff1P2 #= (Enfant &= homme),
        Aff2P2 #= (AffE #= 0),
        (Parent1 &\= Parent2),
        affirme(Enfant, AffE),
        affirme(Parent1, AffP1), 
        affirme(Parent2, Aff1P2, Aff2P2),
        affirme(Parent2, Aff1P2),
        affirme(Parent2,Aff2P2).

labeling_symb([]).
labeling_symb([Var|Reste]):-
        ic_symbolic:indomain(Var),
        labeling_symb(Reste).

/* Test 

[eclipse 20]: solve(P1,P2,Enf,AffE,AffEselonP1,AffP1,Aff1P2,Aff2P2).

P1 = homme
P2 = femme
Enf = homme
AffE = 0
AffEselonP1 = 0
AffP1 = 1
Aff1P2 = 1
Aff2P2 = 1
Yes (0.00s cpu, solution 1, maybe more) ? ;



*/