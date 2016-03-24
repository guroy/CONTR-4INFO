:-lib(ic).
:-lib(ic_symbolic).
:-lib(branch_and_bound).

%% 1. Partie données %%%%%%%%%%%%%%%%%%%%%
valeurs(Technicien, Quantite, Benefice) :-
  Technicien = [](5,7,2,6,9,3,7,5,3),
  Quantite = [](140,130,60,95,70,85,100,30,45),
  Benefice = [](4,5,8,5,6,4,7,10,11).
  
fabriquer(Vecteur) :-
  dim(Vecteur, [9]),
  Vecteur #:: 0..1.
  
  
%% 2. Partie prédicats de service %%%%%%%%
produitVectoriel(V1, V2, Res) :-
        dim(V1, Dim),
        dim(Res,Dim),
        (foreacharg(X, V1), foreacharg(Y, V2), foreacharg(Z, Res) do
            Z #=  X * Y).

sommeVecteur(V, Res) :-
        (foreacharg(X,V), fromto(0, In, Out, Res) do
            Out #= X + In
        ).

produitScalaire(V1, V2, Res) :-
        produitVecteur(V1, V2, R),
        sommeVecteur(R,Res).
        
        
%% 3. Partie prédicats de contrainte %%%%%
nbTotalDOuvriersNecessaires(N, Res) :-
  fabriquer(N),
  valeurs(Technicien,_,_),
  dim(N,[Length]),
  ( for(Indice, 1, Length), param(Technicien, N),
    fromto(0, In, Out, Res)
  do
    Out #= In + Technicien[Indice] * N[Indice]
  ).

/*
nbTotalDOuvriersNecessaires([](1,0,0,0,0,0,1,0,0),R).

R = 12
Yes (0.00s cpu)
*/
  
  
beneficeTotalParSorteDeTelephone(N, Res) :-
  fabriquer(N),
  valeurs(_,Quantite, Benefice),
  produitVectoriel(Benefice, Quantite, R),
  produitVectoriel(R, N, Res).
  
/*
beneficeTotalParSorteDeTelephone([](1,0,0,0,0,0,1,0,0),R).

R = [](560, 0, 0, 0, 0, 0, 700, 0, 0)
Yes (0.00s cpu)
*/


profitTotal(N, Res) :-
  beneficeTotalParSorteDeTelephone(N, R),
  sommeVecteur(R, Res).
  
/*
profitTotal([](1,0,0,0,0,0,1,0,0),R).

R = 1260
Yes (0.00s cpu)
*/


%% 4. Partie résolution des contraintes %%

poserContraintes(_N, NbTechniciensTotal, Profit):-
  NbTechniciensTotal #=< 22,
  Profit #> 2600.

solve(N, Profit) :-
	fabriquer(N),
	nbTotalDOuvriersNecessaires(N, Techniciens),
	poserContraintes(N, Techniciens, Profit),
	profitTotal(N, Profit),
	labeling(N).
	
/*
solve(N,X).

N = [](0, 1, 1, 0, 0, 1, 1, 0, 1)
X = 2665
Yes (0.00s cpu, solution 1, maybe more) ? ;

No (0.00s cpu)

Le profit maximum est 2665
*/


%% Question 5.4

solve2(X) :-
	[X,Y,Z,W] #:: [0..10],
	X #= Z+Y+2*W,
	X #\= Z+Y+W,
	labeling([X]).

solve3(X) :-
	[X,Y,Z,W] #:: [0..10],
	X #= Z+Y+2*W,
	X #\= Z+Y+W,
	labeling([X,Y,Z,W]).

minim2(X) :-
	minimize(solve2(X),X).

minim3(X) :-
	minimize(solve3(X),X).

/*
minim2(X).
Found a solution with cost 1
Found no solution with cost -1.0Inf .. 0

X = 1
Yes (0.00s cpu)

minim3(X).
Found a solution with cost 2
Found no solution with cost -1.0Inf .. 1

X = 2
Yes (0.00s cpu)

On constate qu'il faut labeler sur toutes les variables sinon le résultat donné par Eclipse est faux.
En effet les delayed goal ne sont pas pris en compte.
*/

%% Question 5.5
/*
[eclipse 33]: Q #= -P ,minimize(solve(F,P), Q).
Found a solution with cost 0
Found a solution with cost -495
Found a solution with cost -795
Found a solution with cost -1195
Found a solution with cost -1495
Found a solution with cost -1535
Found a solution with cost -1835
Found a solution with cost -1955
Found a solution with cost -1970
Found a solution with cost -2010
Found a solution with cost -2015
Found a solution with cost -2315
Found a solution with cost -2490
Found a solution with cost -2665
Found no solution with cost -1.0Inf .. -2666

Q = -2665
P = 2665
F = [](0, 1, 1, 0, 0, 1, 1, 0, 1)
Yes (0.01s cpu)

La solution optimale est donc 2665
*/

%% Question 5.6
  

poserContraintes2(_N, NbTechniciensTotal, Profit):-
  NbTechniciensTotal #=< 22,
  Profit #> 1000.

solve4(N, Profit, Techniciens) :-
	fabriquer(N),
	nbTotalDOuvriersNecessaires(N, Techniciens),
	profitTotal(N, Profit),
	poserContraintes2(N, Techniciens, Profit),
	labeling(N).
	
/*
[eclipse 42]: minimize(solve4(F,P,N),N).
Found a solution with cost 10
Found a solution with cost 9
Found a solution with cost 8
Found a solution with cost 7
Found no solution with cost -1.0Inf .. 6

F = [](1, 0, 1, 0, 0, 0, 0, 0, 0)
P = 1040
N = 7
Yes (0.00s cpu)
*/
  
