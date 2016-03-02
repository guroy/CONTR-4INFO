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

%       
%
%
%
%

%%% QUESTION 1.6

% Si on pose le prédicat >= avant les appels à isBetween, on teste
% un nombre important d'inégalités sortant des limites du problème.
% Le temps d'exécution est ainsi bien supérieur.

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

%       
%
%
%
%

%%%%%%%%%%%%%%%%

% chapie(-Chats, -Pies, -Pattes, -Tetes)
chapie(Chats, Pies, Pattes, Tetes) :-
  Chats #:: 0..1000, % no more than 1000 cats
  Pies #:: 0..1000, % no more than 1000 birds
  Tetes #= Chats + Pies,
  Pattes #= 4*Chats + 2*Pies.

%%% QUESTION 1.9

chapie(2, Pies, Pattes, 5).
% Pies = 3
% Pattes = 14

%%% QUESTION 1.10

chapietriple(Chats, Pies, Pattes, Tetes) :-
  Pattes #= 3*Tetes,
  chapie(Chats, Pies, Pattes, Tetes),
  labeling([Chats, Pies, Pattes, Tetes]).
  
%%% QUESTION 1.11

% vabs(?Val, ?AbsVal)

