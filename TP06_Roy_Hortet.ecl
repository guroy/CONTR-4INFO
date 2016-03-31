:-lib(ic).
:-lib(ic_symbolic).
:-lib(branch_and_bound).

%% Question 6.1
data(Poids,Places):-
  Poids = [](24,39,85,60,165,6,32,123,7,14),
  dim(Places,[10]),
  Places #:: [-8 .. -1,1 .. 8].
  
%% Chaque personne doit être à une place différente
place_differente(Places) :-
  ic:alldifferent(Places).
  
%% La balancoire doit être équilibrée
equilibre(Poids, Places, Moment):-
  (for(I,1,10),
    param(Poids,Places),
      fromto(0,In,Out,PoidsTotal),
      fromto(0, In2, Out2, Moment),
      param(Poids,Places)
      do
        Out #= In + Poids[I]*Places[I],
        Out2 #= In2 + Poids[I]*abs(Places[I])
   ),
   PoidsTotal #= 0.

%% Les parents souhaitent encadrer leurs enfants
encadrer(Places):-
  Papa is Places[8],
  Maman is Places[4],
  ic:max(Places,Max),
  ic:min(Places,Min),
  (Papa #= Min) or (Papa #= Max),
  (Maman #= Min) or (Maman #= Max).
  
%% Les deux plus jeunes sont sur des côtés opposés
jeunes(Places):-
  Papa is Places[8],
  Maman is Places[4],
  Dan is Places[6],
  Max is Places[9],
  Papa #< 0 => (Dan #= Papa+1 and Max #= Maman-1) or (Max #= Papa+1 and Dan #= Maman-1),
  Papa #> 0 => (Dan #= Papa-1 and Max #= Maman+1) or (Max #= Papa-1 and Dan #= Maman+1).

%% Il y a 5 personnes de chaque cote
personnes(Places):-
  (for(I,1,10),
    param(Places),
    fromto(0,In,Out,Total),
    param(Places)
    do
      Out #= In + (Places[I] #> 0) - (Places[I] #< 0)
  ),
  Total #= 0.

%% Pose toutes les contraintes
contraintes(Poids, Places, Moment):-
  place_differente(Places),
  personnes(Places),
  equilibre(Poids, Places, Moment),
  encadrer(Places),
  jeunes(Places).
  
%% Question 6.2
%% Résolution du probleme
solve(Poids, Places, Moment):-
  data(Poids, Places),
  contraintes(Poids, Places, Moment),
  labeling(Places).


%% Question 6.3
%% La balancoire est symetrique, on force donc la position du père 
%% pour accélérer la recherche
enlever_sym(Places) :-
  Papa is Places[8],
  Papa #< 0.

contrainte2(Poids, Places, Moment):-
  place_differente(Places),
  personnes(Places),
  equilibre(Poids, Places, Moment),
  encadrer(Places),
  jeunes(Places),
  enlever_sym(Places).
  
solve2(Poids, Places, Moment):-
  data(Poids, Places),
  contraintes(Poids, Places, Moment),
  labeling(Places).
  
  
%% Tests
/*
Question 6.2 :
[eclipse 23]: solve(P,Pl,M).

P = [](24, 39, 85, 60, 165, 6, 32, 123, 7, 14)
Pl = [](-6, -5, -4, -8, 2, 5, 3, 6, -7, 1)
M = 2416
Yes (0.09s cpu, solution 1, maybe more) ? ;

P = [](24, 39, 85, 60, 165, 6, 32, 123, 7, 14)
Pl = [](-6, -5, -1, 8, 5, 7, 3, -8, -7, 1)
M = 2914
Yes (0.13s cpu, solution 2, maybe more) ? ;

P = [](24, 39, 85, 60, 165, 6, 32, 123, 7, 14)
Pl = [](-6, -5, 1, -8, -2, 6, 5, 7, -7, 4)
M = 2396
Yes (0.13s cpu, solution 3, maybe more) ? ;

P = [](24, 39, 85, 60, 165, 6, 32, 123, 7, 14)
Pl = [](-6, -5, 2, 8, 4, -7, -2, -8, 7, 5)
M = 2858
Yes (0.14s cpu, solution 4, maybe more) ? 
*/






  
  
