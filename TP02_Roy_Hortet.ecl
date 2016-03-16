:- lib(ic).
:- lib(ic_symbolic).

%%%%%%%%%%%%%%%%

%%% QUESTION 2.1
:- local domain(color(red,green,white,yellow,blue)).
:- local domain(country(england,spain,ukrain,japan,norway)).
:- local domain(drink(tea,milk,orangejuice,water,coffee)).
:- local domain(pet(dog,snake,fox,horse,zebra)).
:- local domain(car(bmw,toyota,ford,datsun,honda)).


%%% QUESTION 2.2
domaines_maison(m(Pays,Couleur,Boisson,Voiture,Animal,Numero)) :-
  Numero #:: 1..5,
  Pays &:: country,
  Couleur &:: color,
  Boisson &:: drink,
  Voiture &:: car,
  Animal &:: pet.
  

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

% resoude(?Rue)
resoudre(Rue):-
	rue(Rue),
	getVarList(Rue,List),
	contraintes(Rue),
	(foreach(m(_P,C,_B,_V,_A,N),Rue), param(Rue) do
	(
		(foreach(m(_P1,C1,_B1,_V1,_A1,N1),Rue),
			param(N,C) do
			(C1 &= green) and (C &= white) => (N1 #= N+1)
		)
	)
	),
	(foreach(m(_P,_C,_B,V,_A,N),Rue), param(Rue) do
	(
		(foreach(m(_P1,_C1,_B1,_V1,A1,N1),Rue),
			param(N,V) do
			(V &= ford) and (A1 &= fox) => ((N #= N1+1) or( N #= N1-1))
		)
	)
	),
	(foreach(m(_P,_C,_B,V,_A,N),Rue), param(Rue) do
	(
		(foreach(m(_P1,_C1,_B1,_V1,A1,N1),Rue),
			param(N,V) do 
			(V &= toyota) and (A1 &= horse) => ((N #= N1+1) or( N #= N1-1))
		)
	)
	),
	(foreach(m(P,_C,_B,_V,_A,N),Rue), param(Rue) do
	(
		(foreach(m(_P1,C1,_B1,_V1,_A1,N1),Rue),
			param(P,N) do
			(P &= norway) and (C1 &= blue) => ((N #= N1+1) or( N #= N1-1))
		)
	)
	),
	labeling_symbolic(List),
	ecrit_maisons(Rue).

	
%%% QUESTION 2.7

contraintes(Rue) :-
	(foreach(m(P,C,B,V,A,N),Rue) do 
    (
	(P &= england) #= (C &= red),		%Contrainte A
	(P &= spain) #=  (A &= dog),       %Contrainte B
	(C &= green) #= (B &= coffee),		%Contrainte C
	(P &= ukrain) #= (B &= tea),		%Contrainte D
	(V &= bmw) #= (A &= snake),		%Contrainte F
	(C &= yellow) #= (V &= toyota),		%Contrainte G
	(B &= milk) #= (N #= 3),		%Contrainte H
	(P &= norway) #=(N #= 1),		%Contrainte I
	(V &= honda) #=(B &= orangejuice),	%Contrainte L
	(V &= datsun) #=(P &= japan)	        %Contrainte M
    )
).
	

%%% QUESTION 2.8

/*

[eclipse 54]: resoudre([A,B,C,D,F]).
m(norway, yellow, water, toyota, fox, 1)
m(ukrain, blue, tea, ford, horse, 2)
m(england, red, milk, bmw, snake, 3)
m(spain, white, orangejuice, honda, dog, 4)
m(japan, green, coffee, datsun, zebra, 5)

A = m(norway, yellow, water, toyota, fox, 1)
B = m(ukrain, blue, tea, ford, horse, 2)
C = m(england, red, milk, bmw, snake, 3)
D = m(spain, white, orangejuice, honda, dog, 4)
F = m(japan, green, coffee, datsun, zebra, 5)

*/

% Le zèbre est possédé par le Japonais, et le Norvégien boit de l'eau.


