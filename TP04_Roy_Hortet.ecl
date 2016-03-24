%TP4 Roy - Hortet

:-lib(ic).
:-lib(ic_symbolic).


% Question 4.1 : getData(?TailleEquipe, ?NbEquipes, ?CapaBateaux, NbBateaux, ?NbConf).


getData(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf):-
		TailleEquipes = [](5,5,2,1),
		CapaBateaux = [](7,6,5),
		dim(TailleEquipes, [NbEquipes]),
		dim(CapaBateaux, [NbBateaux]),
		NbConf is 3.


% Question 4.2 : defineVars(?T, +NbEquipes, +NbConf, +NbBateaux).

defineVars(T, NbEquipes, NbConf,  NbBateaux):-
		dim(T, [NbEquipes, NbConf]),
		T #:: 1..NbBateaux.


% Question 4.3 : getVarList(+T, ?L)

getVarList(T, L) :-
        dim(T,[NbEquipes,NbConf]),
        (multifor([I,J],[NbConf,NbEquipes],[1,1],[-1,-1]),
         param(T),
         fromto([], In, Out, L)
         do
            (V is T[J,I],
             Out = [V|In]
            )   
        ).

% Question 4.4 : solve(?T)

solve(T):-
        getData(_TailleEquipes,NbEquipes,_CapaBateaux,NbBateaux,NbConf),
        defineVars(T, NbEquipes, NbConf, NbBateaux),
        getVarList(T,L),
        labeling(L).	

% Question 4.5 : pasMemeBateaux(+T, +NbEquipes, + NbConf)


pasMemeBateaux(T,_NbEquipes, _NbConf):-
        foreacharg(Ligne, T) do
            ic:alldifferent(Ligne).

solve2(T):-
	getData(_TailleEquipes,NbEquipes,_CapaBateaux,NbBateaux,NbConf),
        defineVars(T, NbEquipes, NbConf, NbBateaux),
        getVarList(T,L),
	pasMemeBateaux(T, NbEquipes, NbConf),
        labeling(L).

% Question 4.6 : pasMemePartenaires(+T, +NbEquipes, +NbConf)

pasMemePartenaires(T, NbEquipes, NbConf):-
	(for(Eq1,1,NbEquipes), param(T,NbConf,NbEquipes)
		do
		(for(Eq2,Eq1+1,NbEquipes), param(T,NbConf,Eq1)
			do
			(for(Conf1,1,NbConf), param(T,Eq1,Eq2,NbConf)	
				do
				(for(Conf2, 1+Conf1, NbConf), param(T,Eq1,Eq2,Conf1)
					do
					(T[Eq1,Conf1]#= T[Eq2,Conf1]) => (T[Eq1,Conf2] #\= T[Eq2,Conf2])
				)
			)	
		)
	).


solve3(T):-
	getData(_TailleEquipes,NbEquipes,_CapaBateaux,NbBateaux,NbConf),
        defineVars(T, NbEquipes, NbConf, NbBateaux),
        getVarList(T,L),
	pasMemeBateaux(T, NbEquipes, NbConf),
	pasMemePartenaires(T, NbEquipes, NbConf),
        labeling(L).


% Question 4.7 : capaBateaux(+T, + TailleEquipes, +CapaBateaux, +NbConf)

capaBateaux(T,_TailleEquipes, NbEquipes,_CapaBateaux, NbBateaux, NbConf) :-
        (multifor([I,J],[1,1],[NbConf,NbBateaux]), param(NbEquipes, T) do
            listeBateauxConf(T, NbEquipes, I, Liste),
            aBord(Liste, J, 1, Res),
            getData(_TailleEquipes, _NbEquipes, CapaBateaux, _NbBateaux, _NbConf),
            Taille is CapaBateaux[J],
            Res #=< Taille
        ).

%% liste des bateaux pour une confrontation
listeBateauxConf(T, NbEquipes, NumConf, L) :-
        (for(I,1,NbEquipes),
         fromto([], In, Out, L), param(T,NumConf)
                                 do
            Elem is T[I,NumConf],
            append(In,[Elem],Out)
        ).

%% aBord(+ListeBateau, +NumBateau, +NumEquipe, -Res) : renvoie pour un bateau le nombre de personne à bord
aBord([],_NumBateau,_NumEquipe,0).
aBord([NumBateau|Reste],NumBateau,NumEquipe,Res) :-
        !,
	getData(TailleEquipes, _NbEquipes, _CapaBateaux, _NbBateaux, _NbConf),
        ResTmp is TailleEquipes[NumEquipe],
        NumEquipe2 is NumEquipe + 1,
        aBord(Reste,NumBateau,NumEquipe2,ResTmp2),
        Res is ResTmp + ResTmp2.

aBord([_NumBateau2|Reste],NumBateau,NumEquipe,Res) :-
        NumEquipe2 is NumEquipe + 1,
        aBord(Reste,NumBateau,NumEquipe2,Res).


solve4(T):-
        getData(_TailleEquipes,NbEquipes,_CapaBateaux,NbBateaux,NbConf),
        defineVars(T, NbEquipes, NbConf, NbBateaux),
        getVarList(T,L),
        pasMemeBateaux(T,NbEquipes,NbConf),
        pasMemePartenaires(T, NbEquipes, NbConf),
       	capaBateaux(T, _TailleEquipes, NbEquipes, _CapaBateaux, NbBateaux, NbConf),
        labeling(L).
 


 /*Question 4.8
 * getVarListAlt(+T, ?List)
 * Alterne une petite et une grande equipe par rapport a getVarList.
 * Utilise le fait que les equipes sont donnes dans un tableau ordonne.
 * L'ajout a la liste est donc realise en partant des deux extremites et en allant vers le milieu.
 
		NON FONCTIONNEL
*/

getData2(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, 7):-
	TailleEquipes = [](7, 6, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
	dim(TailleEquipes, [NbEquipes]),
	CapaBateaux = [](10, 10, 9, 8, 8, 8, 8, 8, 8, 7, 6, 4, 4),
	dim(CapaBateaux, [NbBateaux]).

getVarListAlt(T, List):-
	dim(T, [NbEquipes, NbConf]),
	(for(J, 0, NbConf-1), fromto([], In, Out, List), param(T, NbEquipes, NbConf) do
		MoitieNbEquipes is div(NbEquipes, 2),
		(for(I, 0, MoitieNbEquipes-1), fromto([], SubIn, SubOut, SubList), param(MoitieNbEquipes, T, J, NbConf, NbEquipes) do
			% Les indices sont inverses car fromto inverse les listes:
			JInv is NbConf - J,
			IInv is MoitieNbEquipes - I,
			Elem1 is T[IInv, JInv], % Une grande equipe.
			Elem2 is T[NbEquipes-IInv+1, JInv], % Une petite equipe.
			SubOut = [Elem1, Elem2|SubIn]
		),
		append(SubList, In, Out)
	).



solve5(T):-
        getData2(TailleEquipes,NbEquipes,CapaBateaux,NbBateaux,NbConf),
        defineVars(T, NbEquipes, NbConf, NbBateaux),
        pasMemeBateaux(T,NbEquipes,NbConf),
        pasMemePartenaires(T, NbEquipes, NbConf),
	capaBateaux(T, TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),
	getVarListAlt(T,L),
        labeling(L).
        
%%%%%%%%%Test%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

/* 
%Question 4.1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


getData(TailleEquipes,NbEquipes,CapaBateaux,NbBateaux,NbConf).

TailleEquipes = [](5, 5, 2, 1)
NbEquipes = 4
CapaBateaux = [](7, 6, 5)
NbBateaux = 3
NbConf = 3
Yes (0.00s cpu)

%Question 4.2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getData(TailleEquipes,NbEquipes,CapaBateaux,NbBateaux,NbConf), defineVars(T, NbEquipes, NbConf, NbBateaux).
lists.eco  loaded in 0.00 seconds

TailleEquipes = [](5, 5, 2, 1)
NbEquipes = 4
CapaBateaux = [](7, 6, 5)
NbBateaux = 3
NbConf = 3

T = []([](_12663{1 .. 3}, _12678{1 .. 3}, _12693{1 .. 3}), [](_12708{1 .. 3}, _12723{1 .. 3}, _12738{1 .. 3}), [](_12753{1 .. 3}, _12768{1 .. 3}, _12783{1 .. 3}), [](_12798{1 .. 3}, _12813{1 .. 3}, _12828{1 .. 3}))
Yes (0.00s cpu)

% Question 4.3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getData(TailleEquipes,NbEquipes,CapaBateaux,NbBateaux,NbConf), defineVars(T, NbEquipes, NbConf, NbBateaux), getVarList(T,L).

TailleEquipes = [](5, 5, 2, 1)
NbEquipes = 4
CapaBateaux = [](7, 6, 5)
NbBateaux = 3
NbConf = 3
T = []([](_562{1 .. 3}, _577{1 .. 3}, _592{1 .. 3}), [](_607{1 .. 3}, _622{1 .. 3}, _637{1 .. 3}), [](_652{1 .. 3}, _667{1 .. 3}, _682{1 .. 3}), [](_697{1 .. 3}, _712{1 .. 3}, _727{1 .. 3}))
L = [_562{1 .. 3}, _607{1 .. 3}, _652{1 .. 3}, _697{1 .. 3}, _577{1 .. 3}, _622{1 .. 3}, _667{1 .. 3}, _712{1 .. 3}, _592{1 .. 3}, _637{1 .. 3}, _682{1 .. 3}, _727{1 .. 3}]
Yes (0.00s cpu)

% Question 4.4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve(T).

T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 1))
Yes (0.00s cpu, solution 1, maybe more) ? 

T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 2))
Yes (0.00s cpu, solution 2, maybe more) ? ;

T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 3))
Yes (0.00s cpu, solution 3, maybe more) ? ;

T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 2), [](1, 1, 1))
Yes (0.00s cpu, solution 4, maybe more) ? ;

T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 2), [](1, 1, 2))
Yes (0.00s cpu, solution 5, maybe more) ? ;

% Question 4.5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve2(T).

T = []([](1, 2, 3), [](1, 2, 3), [](1, 2, 3), [](1, 2, 3))
Yes (0.00s cpu, solution 1, maybe more) ? ;

T = []([](1, 2, 3), [](1, 2, 3), [](1, 2, 3), [](1, 3, 2))
Yes (0.00s cpu, solution 2, maybe more) ? ;

T = []([](1, 2, 3), [](1, 2, 3), [](1, 3, 2), [](1, 2, 3))
Yes (0.00s cpu, solution 3, maybe more) ? ;

T = []([](1, 2, 3), [](1, 2, 3), [](1, 3, 2), [](1, 3, 2))
Yes (0.00s cpu, solution 4, maybe more) ? 


% Question 4.6%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve3(T).

T = []([](1, 2, 3), [](1, 3, 2), [](2, 1, 3), [](2, 3, 1))
Yes (0.00s cpu, solution 1, maybe more) ? 
[eclipse 31]: solve3(T).

T = []([](1, 2, 3), [](1, 3, 2), [](2, 1, 3), [](2, 3, 1))
Yes (0.00s cpu, solution 1, maybe more) ? ;

T = []([](1, 2, 3), [](1, 3, 2), [](2, 3, 1), [](2, 1, 3))
Yes (0.00s cpu, solution 2, maybe more) ? ;

T = []([](1, 3, 2), [](1, 2, 3), [](2, 1, 3), [](2, 3, 1))
Yes (0.00s cpu, solution 3, maybe more) ? 

% Question 4.7%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve4(T).

T = []([](1, 2, 3), [](2, 3, 1), [](3, 1, 2), [](3, 2, 1))
Yes (0.01s cpu, solution 1, maybe more) ? ;

T = []([](1, 3, 2), [](2, 1, 3), [](3, 2, 1), [](3, 1, 2))
Yes (0.01s cpu, solution 2, maybe more) ? ;

T = []([](1, 2, 3), [](3, 1, 2), [](2, 3, 1), [](1, 3, 2))
Yes (0.01s cpu, solution 3, maybe more) ? ;

T = []([](1, 3, 2), [](3, 2, 1), [](2, 1, 3), [](1, 2, 3))
Yes (0.01s cpu, solution 4, maybe more) ? 


*/


