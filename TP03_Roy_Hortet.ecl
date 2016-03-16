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


% Question 3 : domaines(+Taches, ?Fin)

domaines(Taches, Fin):-
  (foreachelem(tache(Duree,_Nom,_Machine,Debut),Taches), param(Fin)
    do
      (Debut #> 0,
       Debut + Duree #< Fin)).
       
% Question 4 : getVarList(+Taches, ?Fin, ?List) 

getVarList(Taches, Fin, List):-
    (foreachelem(tache(_Duree,_Noms,_Machine,Debut),Taches),
	    fromto([Fin],In, Out, List)
          do
            Out = [Debut| In]).
            
            
%Question 5 : solve(?Taches, ?Fin)

solve(Taches, Fin):-
  taches(Taches),
	domaines(Taches,Fin),
	getVarList(Taches,Fin,Liste),
	labeling(Liste).
	
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
	domaine_machine(Taches),
	precedence(Taches),
	conflits(Taches),
	getVarList(Taches,Fin,Liste),
	Fin #=< 44,
	labeling(Liste),
	affiche(Taches).

