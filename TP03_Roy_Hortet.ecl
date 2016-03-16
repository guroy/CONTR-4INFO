:-lib(ic).
:-lib(ic_symbolic).


%%%%%%%%%%%%%%%%

:- local domain(machine(m1,m2)).

%%%%%%%%%%%%%%%%%%%%%% Une première solution partielle %%%%%%%%%%%%%%%%%%%%%
% Question 1 : taches(+Taches)

taches([](
  tache(3,[], m1, _),
	tache(8,[],m1, _),
	tache(8,[4,5],m1, _),
	tache(6,[],m2, _),
	tache(3,[1],m2, _),
	tache(4,[1,7],m1, _),
	tache(8,[3,5],m1, _),
	tache(6,[4],m2, _),
	tache(6,[6,7],m2, _),
	tache(6,[9,12],m2, _),
	tache(3,[1],m2, _),
	tache(6,[7,8],m2, _))).
	
	
% Question 2 : affiche(+Taches)

affiche(Taches) :- 
	(foreachelem(X, Taches)
    do
      writeln(X)
).

/*
[eclipse 59]: taches(X), affiche(X).
tache(3, [], m1, _243)
tache(8, [], m1, _248)
tache(8, [4, 5], m1, _253)
tache(6, [], m2, _262)
tache(3, [1], m2, _267)
tache(4, [1, 7], m1, _274)
tache(8, [3, 5], m1, _283)
tache(6, [4], m2, _292)
tache(6, [6, 7], m2, _299)
tache(6, [9, 12], m2, _308)
tache(3, [1], m2, _317)
tache(6, [7, 8], m2, _324)

X = [](tache(3, [], m1, _243), tache(8, [], m1, _248), tache(8, [4, 5], m1, _253), tache(6, [], m2, _262), tache(3, [1], m2, _267), tache(4, [1, 7], m1, _274), tache(8, [3, 5], m1, _283), tache(6, [4], m2, _292), tache(6, [6, 7], m2, _299), tache(6, [9, 12], m2, _308), tache(3, [1], m2, _317), tache(6, [7, 8], m2, _324))
Yes (0.00s cpu)
*/


% Question 3 : domaines(+Taches, ?Fin)

domaines(Taches, Fin):-
  (foreachelem(tache(Duree,_Nom,_Machine,Debut),Taches), param(Fin)
    do
      (Debut #> 0,
       Debut + Duree #< Fin)).
       
/*
[eclipse 61]: taches(X),domaines(X,100),affiche(X).
tache(3, [], m1, _421{1 .. 96})
tache(8, [], m1, _514{1 .. 91})
tache(8, [4, 5], m1, _607{1 .. 91})
tache(6, [], m2, _700{1 .. 93})
tache(3, [1], m2, _793{1 .. 96})
tache(4, [1, 7], m1, _886{1 .. 95})
tache(8, [3, 5], m1, _979{1 .. 91})
tache(6, [4], m2, _1072{1 .. 93})
tache(6, [6, 7], m2, _1165{1 .. 93})
tache(6, [9, 12], m2, _1258{1 .. 93})
tache(3, [1], m2, _1351{1 .. 96})
tache(6, [7, 8], m2, _1445{1 .. 93})

X = [](tache(3, [], m1, _421{1 .. 96}), tache(8, [], m1, _514{1 .. 91}), tache(8, [4, 5], m1, _607{1 .. 91}), tache(6, [], m2, _700{1 .. 93}), tache(3, [1], m2, _793{1 .. 96}), tache(4, [1, 7], m1, _886{1 .. 95}), tache(8, [3, 5], m1, _979{1 .. 91}), tache(6, [4], m2, _1072{1 .. 93}), tache(6, [6, 7], m2, _1165{1 .. 93}), tache(6, [9, 12], m2, _1258{1 .. 93}), tache(3, [1], m2, _1351{1 .. 96}), tache(6, [7, 8], m2, _1445{1 .. 93}))
Yes (0.00s cpu)
*/
    
       
% Question 4 : getVarList(+Taches, ?Fin, ?List) 

getVarList(Taches, Fin, List):-
    (foreachelem(tache(_Duree,_Noms,_Machine,Debut),Taches),
	    fromto([Fin],In, Out, List)
          do
            Out = [Debut| In]).

/*
[eclipse 65]: taches(X),domaines(X,100),getVarList(X,100,L).

X = [](tache(3, [], m1, _449{1 .. 96}), tache(8, [], m1, _542{1 .. 91}), tache(8, [4, 5], m1, _635{1 .. 91}), tache(6, [], m2, _728{1 .. 93}), tache(3, [1], m2, _821{1 .. 96}), tache(4, [1, 7], m1, _914{1 .. 95}), tache(8, [3, 5], m1, _1007{1 .. 91}), tache(6, [4], m2, _1100{1 .. 93}), tache(6, [6, 7], m2, _1193{1 .. 93}), tache(6, [9, 12], m2, _1286{1 .. 93}), tache(3, [1], m2, _1379{1 .. 96}), tache(6, [7, 8], m2, _1473{1 .. 93}))
L = [_1473{1 .. 93}, _1379{1 .. 96}, _1286{1 .. 93}, _1193{1 .. 93}, _1100{1 .. 93}, _1007{1 .. 91}, _914{1 .. 95}, _821{1 .. 96}, _728{1 .. 93}, _635{1 .. 91}, _542{1 .. 91}, _449{1 .. 96}, 100]
Yes (0.00s cpu)

*/         
      
            
%Question 5 : solve(?Taches, ?Fin)

solve(Taches, Fin):-
  taches(Taches),
	domaines(Taches,Fin),
	getVarList(Taches,Fin,Liste),
	labeling(Liste).
	
/*
[eclipse 68]: solve(T,100).

T = [](tache(3, [], m1, 1), tache(8, [], m1, 1), tache(8, [4, 5], m1, 1), tache(6, [], m2, 1), tache(3, [1], m2, 1), tache(4, [1, 7], m1, 1), tache(8, [3, 5], m1, 1), tache(6, [4], m2, 1), tache(6, [6, 7], m2, 1), tache(6, [9, 12], m2, 1), tache(3, [1], m2, 1), tache(6, [7, 8], m2, 1))
Yes (0.00s cpu, solution 1, maybe more) ? ;

T = [](tache(3, [], m1, 2), tache(8, [], m1, 1), tache(8, [4, 5], m1, 1), tache(6, [], m2, 1), tache(3, [1], m2, 1), tache(4, [1, 7], m1, 1), tache(8, [3, 5], m1, 1), tache(6, [4], m2, 1), tache(6, [6, 7], m2, 1), tache(6, [9, 12], m2, 1), tache(3, [1], m2, 1), tache(6, [7, 8], m2, 1))
Yes (0.00s cpu, solution 2, maybe more) ? 
*/


%%%%%%%%%%%%%%%%%%%%%% Pose des contraintes d'ordonnancement %%%%%%%%%%%%%%%%%%%%%

%Question 6 : precedences(+Taches)

precedences(Taches) :-
  (foreachelem(tache(_Duree,Nom,_Machine,Debut),Taches), param(Taches)
    do
      (
        foreach(T,Nom), param(Taches,Debut)
            do
              (
                tache(Duree, _Nom, _Machine2, Debut2) is Taches[T],
                  Debut #>= Duree + Debut2
                  )
     )
  ).

/*
[eclipse 75]: taches(X),domaines(X,40),precedences(X),affiche(X).
tache(3, [], m1, 1)
tache(8, [], m1, _560{1 .. 31})
tache(8, [4, 5], m1, 7)
tache(6, [], m2, 1)
tache(3, [1], m2, 4)
tache(4, [1, 7], m1, 23)
tache(8, [3, 5], m1, 15)
tache(6, [4], m2, _1118{7 .. 21})
tache(6, [6, 7], m2, 27)
tache(6, [9, 12], m2, 33)
tache(3, [1], m2, _1397{4 .. 36})
tache(6, [7, 8], m2, _1491{23 .. 27})

X = [](tache(3, [], m1, 1), tache(8, [], m1, _560{1 .. 31}), tache(8, [4, 5], m1, 7), tache(6, [], m2, 1), tache(3, [1], m2, 4), tache(4, [1, 7], m1, 23), tache(8, [3, 5], m1, 15), tache(6, [4], m2, _1118{7 .. 21}), tache(6, [6, 7], m2, 27), tache(6, [9, 12], m2, 33), tache(3, [1], m2, _1397{4 .. 36}), tache(6, [7, 8], m2, _1491{23 .. 27}))


Delayed goals:
	_1118{7 .. 21} - _1491{23 .. 27} #=< -6
Yes (0.00s cpu)
*/


solve2(Taches,Fin) :-
	taches(Taches),
	domaines(Taches,Fin),
	precedences(Taches),
	getVarList(Taches,Fin,Liste),
	labeling(Liste),
	affiche(Taches).
	
	
	%Question 7 : conflits(+Taches)
	
	conflits(Taches) :-
	dim(Taches,[IndiceMax]),
	(for(Indice,1,IndiceMax), 
	param(Taches,IndiceMax)
	do
    (
	tache(Duree,_Noms,Machine,Debut) is Taches[Indice],
	IndiceSuiv is Indice+1,
	(for(Indice2,IndiceSuiv,IndiceMax),
	param(Taches,Duree,Machine,Debut)
	do
    (
	tache(Duree2, _Noms2, Machine2,Debut2) is Taches[Indice2],
	((Debut2 #>= Debut) and (Debut2 #< (Debut + Duree))) => (Machine &\= Machine2),
	((Debut #>= Debut2) and (Debut #< (Debut2 + Duree2))) => (Machine &\= Machine2)
    )
)
)
).


solve3(Taches,Fin) :-
	taches(Taches),
	domaines(Taches,Fin),
	precedences(Taches),
	conflits(Taches),
	getVarList(Taches,Fin,Liste),
	labeling(Liste),
	affiche(Taches).


%%%%%%%%%%%%%%%%%%%%%% La meilleure solution ? %%%%%%%%%%%%%%%%%%%%%


solve4(Taches,Fin) :-
	taches(Taches),
	domaines(Taches,Fin),
	precedences(Taches),
	conflits(Taches),
	getVarList(Taches,Fin,Liste),
	Fin #=< 44,
	labeling(Liste),
	affiche(Taches).

