:- lib(ic).
:- lib(ic_symbolic).

%%%%%%%%%%%%%%%%

%%% QUESTION 2.1
:- local domain(color(red,green,white,yellow,blue)).
:- local domain(country(england,spain,ukraine,japan,norway)).
:- local domain(drink(tea,milk,orangejuice,water,coffee)).
:- local domain(pet(dog,snake,fox,horse,zebra)).
:- local domain(car(bmw,toyota,ford,datsun,honda)).


%%% QUESTION 2.2
domaines_maison(m(Pays,Couleur,Boisson,Voiture,Animal,Numero)) :-
  Numero #:: 1..5,
  Pays &:: country, ic_symbolic:indomain(Pays),
  Couleur &:: color, ic_symbolic:indomain(Couleur),
  Boisson &:: drink, ic_symbolic:indomain(Boisson),
  Voiture &:: car, ic_symbolic:indomain(Voiture),
  Animal &:: pet, ic_symbolic:indomain(Animal).
  

%%% QUESTION 2.3

% rue(?Rue) 
rue([M1,M2,M3,M4,M5]) :-
  M1 = m(P1, C1, B1, V1, A1, 1),
	M2 = m(P2, C2, B2, V2, A2, 2),
	M3 = m(P3, C3, B3, V3, A3, 3),
	M4 = m(P4, C4, B4, V4, A4, 4),
	M5 = m(P5, C5, B5, V5, A5, 5),
	domaines_maison(M1),
	domaines_maison(M2),
	domaines_maison(M3),
	domaines_maison(M4),
	domaines_maison(M5),
	ic_symbolic:alldifferent([P1, P2, P3, P4, P5]),
	ic_symbolic:alldifferent([C1, C2, C3, C4, C5]),
	ic_symbolic:alldifferent([B1, B2, B3, B4, B5]),
	ic_symbolic:alldifferent([V1, V2, V3, V4, V5]),
	ic_symbolic:alldifferent([A1, A2, A3, A4, A5]).
  
%%% QUESTION 2.4

% ecrit_maisons(?Rue)
ecrit_maisons(Rue) :-
  (foreach(R, Rue)
    do
      writeln(R)
  ). 
  
%%% QUESTION 2.5

% getVarList(?Rue, ?Liste)
getVarList([],[]).
getVarList([m(P,C,B,V,A,_)|Rue],[P,C,B,V,A|Liste]):-
  getVarList(Rue,Liste).
      
% labeling_symbolic(+Liste)
labeling_symbolic([]).
labeling_symbolic([Var|List]) :-
  ic_symbolic:indomain(Var),
  labeling_symbolic(List).
  
  
%%% QUESTION 2.6

resoudre(Rue) :-
  rue(Rue),
  getVarList(Rue, List).


%%% QUESTION 2.7


