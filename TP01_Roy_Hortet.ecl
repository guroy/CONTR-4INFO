:- lib(ic).

%%%%%%%%%%%%%%%%


%%% QUESTION 1.1

couleursBateau(vert).
couleursBateau(noir).
couleursBateau(blanc).

couleursVoiture(rouge).
couleursVoiture(vert(clair)).
couleursVoiture(gris).
couleursVoiture(blanc).


% choixCouleur(?CouleurBateau, ?CouleurVoiture)
choixCouleur(B, V) :- 
  couleursBateau(B),
  couleursVoiture(V),
  ==(B, V).
  
  
%%% QUESTION 1.2

% Les succès et échecs sont en feuille de l'arbre de recherche.


%%% QUESTION 1.3

% isBetween(?Var, +Min, +Max)
isBetween(Min, Min, _).
isBetween(Var, Min, Max) :-
  Min_p1 is Min+1,
  Min_p1 =< Max,
  isBetween(Var, Min_p1, Max).
  
  
%%% QUESTION 1.4

% commande(-NbResistance, -NbCondensateur)
commande(NbResistance, NbCondensateur) :-
  isBetween(NbResistance, 5000, 10000),
  isBetween(NbCondensateur, 9000, 20000),
  NbResistance >= NbCondensateur.
 
  
%%% QUESTION 1.5
/*

                Commande(-NbResistance,-NbCondensateur)
                                   |
 isBetween(NbResistance,5000,10000),isBetween(NbCondensateur,9000,20000),
                      NbResistance>=NbCondensateur
                                   |
 ------------------------------------------------------------------------
 |                    |                                 |               |
...                   |NbRes=9000                       |NbRes=9000    ...
                      |                                 |
   isBetween(NbCondensateur,9000,20000),   isBetween(NbCondensateur,9000,20000),
             9000>=NbCondensateur              9001>=NbCondensateur
                      |                                 |
            -------------------               -------------------
 NbCond=9000|      NbCond=9001|    NbCond=9000|      NbCond=9001|
            |                 |               |                 |
            |                 |               |                 |
        9000>=9000        9000>=9001      9001>=9000        9001>=9001
           YES                NO             YES                NO
*/

%%% QUESTION 1.6

% Si on pose le prédicat >= avant les appels à isBetween, on teste
% un nombre important d'inégalités sortant des limites du problème.
% Le temps d'exécution est ainsi bien supérieur.

%%%%%%%%%%%%%%%%


%%% QUESTION 1.7

% commande2(-NbResistance, -NbCondensateur)
commande2(NbResistance, NbCondensateur) :-
  NbResistance #:: 5000..10000,
  NbCondensateur #:: 9000..20000,
  NbResistance #>= NbCondensateur.
  
% Il y a un "Delayed goal". Comme les valeurs ne sont pas instanciées,
% on ne peut pas continuer l'exécution.


%%% QUESTION 1.8

% commande3(-NbResistance, -NbCondensateur)
commande3(NbResistance, NbCondensateur) :-
  NbResistance #:: 5000..10000,
  NbCondensateur #:: 9000..20000,
  NbResistance #>= NbCondensateur,
  labeling([NbResistance, NbCondensateur]).


/*
                Commande(-NbResistance,-NbCondensateur)
                                   |
                        NbResistance{5000..10000}
                        NbCondensateur{9000..20000}
                                   |
         NbCondensateur{9000..20000} - NbResistance{5000..10000} #<= 0,
         labeling(NbResistance{5000..10000},NbCondensateur{9000..20000})
                                   |
           --------------------------------------------------------
           |                    |                                 |       
  labelling[9000,9000]  labelling[9001,9000]                     ...
          YES                  YES
*/

%%%%%%%%%%%%%%%%


%%% QUESTION 1.9

% chapie(-Chats, -Pies, -Pattes, -Tetes)
chapie(Chats, Pies, Pattes, Tetes) :-
  Chats #:: 0..1000, % no more than 1000 cats
  Pies #:: 0..1000, % no more than 1000 birds
  Tetes #= Chats + Pies,
  Pattes #= 4*Chats + 2*Pies.

chapie(2, Pies, Pattes, 5). % test pour 5 têtes et 2 chats
% Pies = 3
% Pattes = 14


%%% QUESTION 1.10

chapietriple(Chats, Pies, Pattes, Tetes) :-
  Pattes #= 3*Tetes,
  chapie(Chats, Pies, Pattes, Tetes),
  labeling([Chats, Pies, Pattes, Tetes]).

%%%%%%%%%%%%%%%%

  
%%% QUESTION 1.11

% vabs(?Val, ?AbsVal) avec prolog
vabs(Val, AbsVal) :-
    AbsVal #:: 0..inf,
    abs2(Val,AbsVal),
    labeling([Val,AbsVal]).

abs2(Val,AbsVal) :-
    Val #= AbsVal.
abs2(Val,AbsVal) :-
    Val #= -AbsVal.
    
% vabs(?Val, ?AbsVal) avec ic
vabs2(Val, AbsVal) :-
    AbsVal #:: 0..1000,
    Val #:: -1000..1000,
    (Val #= AbsVal) or (Val #= -AbsVal),
    labeling([Val,AbsVal]).

%%% QUESTION 1.12
 
/*
	X #:: -10..10, vabs(X, Y).
	X = 1
	Y = 1
	Yes (0.01s cpu, solution 1, maybe more)
	X = 2
	Y = 2
	Yes (0.01s cpu, solution 2, maybe more)
	X = 3
	Y = 3
	Yes (0.01s cpu, solution 3, maybe more)
	...
X #:: -10..10, vabsIC(X, Y).
	X = -10
	Y = 10
	Yes (0.00s cpu, solution 1, maybe more)
	X = -9
	Y = 9
	Yes (0.00s cpu, solution 2, maybe more)
	X = -8
	Y = 8
	Yes (0.00s cpu, solution 3, maybe more)
	...
*/


%%% Question 1.13

% faitListe(?ListVar,?Taille,+Min,+Max)

faitListe(ListVar,Taille,Min,Max):-
	length(ListVar,Taille),
	ListVar #:: Min..Max.
