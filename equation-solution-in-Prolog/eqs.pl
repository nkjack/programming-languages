:-use_module(library(clpfd)).

/*----------------------- 1 ----------------------------*/

eq_add(equation([]),equation([]),equation([])).

eq_add(equation([]),equation([variable(Name,Factor)]),equation([variable(Name,Factor)])).

eq_add(equation([variable(Name,Factor)]),equation([]),equation([variable(Name,Factor)])).

eq_add(equation([]),equation([variable(Name,Factor)|Others]),equation([variable(Name,Factor)|Others])):- 
	eq_add(equation([]), equation(Others),equation(Others)).

eq_add(equation([variable(Name,Factor)|Others]),equation([]),equation([variable(Name,Factor)|Others])):-
	eq_add(equation([]), equation(Others),equation(Others)).

eq_add(equation([variable(Name1,Factor1)|Others1]), equation([variable(Name2,Factor2)|Others2]), equation([variable(Name1,Factor1)|NewOthers])):-
	Name1 @< Name2,
	eq_add(equation(Others1), equation([variable(Name2,Factor2)|Others2]), equation(NewOthers)),!.

eq_add(equation([variable(Name1,Factor1)|Others1]), equation([variable(Name2,Factor2)|Others2]), equation([variable(Name2,Factor2)|NewOthers])):-
	Name2 @< Name1,
	eq_add(equation([variable(Name1,Factor1)|Others1]), equation(Others2), equation(NewOthers)),!.

eq_add(equation([variable(Name,Factor1)|Others1]), equation([variable(Name,Factor2)|Others2]), equation([variable(Name,FactorNew)|NewOthers])):-
	FactorNew is Factor1 + Factor2,
	eq_add(equation(Others1), equation(Others2), equation(NewOthers)),!.

/*----------------------- 2 ----------------------------*/

eq_multiply(equation([]), _, equation([])).
eq_multiply(equation([variable(Name1,Factor1)|Others1]),Factor, equation([variable(Name1,NewFactor)|NewOthers])):-
	NewFactor is Factor * Factor1,
	eq_multiply(equation(Others1), Factor, equation(NewOthers)),!.

/*----------------------- 3 -----------------------------*/
/*del and insert actions on list*/
del(X, [X|Xs], Xs).
del(X, [Y|Ys], [Y|Zs]) :- del(X, Ys, Zs).

vars_update([],_,[]).

vars_update([variable(Name,Factor1)|Others1], Factor, [variable(Name,Factor2)|Others2]):-
	Temp is Factor1 / Factor,
	Factor2 is Temp * -1,
	vars_update(Others1,Factor,Others2).

eq_extract(equation(ListVars), Name, equation(UpdatedListVars)):-
	member(variable(Name,Factor),ListVars),
	del(variable(Name,Factor), ListVars, NewListVars),
	vars_update(NewListVars, Factor, UpdatedListVars), !.

/*------------------------- 4 -------------------------------*/

eq_substitute(equation(VarList),Name, NameEquation, Result):-
	member(variable(Name,Factor),VarList),
	eq_multiply(NameEquation, Factor, ResultMult),
	del(variable(Name,Factor),VarList,NewVarList),
	eq_add(equation(NewVarList), ResultMult, Result),!.

/*------------------------ 5 ---------------------------------*/

eqs_substitute(equations([]), _, _, equations([])).

eqs_substitute(equations([Eq|Eqs]), Name, NameEquation, equations([EqRes|EqsRes])):-
	eq_substitute(Eq, Name,NameEquation,EqRes),
	eqs_substitute(equations(Eqs), Name, NameEquation, equations(EqsRes)).

/*
 eqs_substitute(equations([equation([variable("x", 2.0), variable("y", 1.0)]),
 							equation([variable("x", 2.0), variable("y", 1.0)]),
 							equation([variable("x", 2.0), variable("y", 1.0)]),
 							equation([variable("x", 2.0), variable("y", 1.0)])]), "x", equation([variable("y", 1.0)]), Result).
*/
/*------------------------ 6 -----------------------------------*/

eqs_solve_step([],_,[]).

eqs_solve_step(equations([equation(VarList)|Eqs]), Name, Result):-
	member(variable(Name,_), VarList),
	eq_extract(equation(VarList), Name, NameEquation),
	eqs_substitute(equations(Eqs), Name, NameEquation, Result),!.

eqs_solve_step(equations([equation(VarList)|Eqs]), Name, Result):-
	eqs_solve_step(equations(Eqs), Name, Result2),
	Result = [equation(VarList)|Result2].

/*----------------------- 7 ------------------------------------*/

extract_eq_vars(equation([]), []).
extract_eq_vars(equation([variable(Name,_)|OtherVars]), [Name | Others]):- extract_eq_vars(equation(OtherVars), Others).

merge_list_vars([],[],[]).
merge_list_vars(List, [], List):-!.
merge_list_vars([], List, List):-!.
merge_list_vars([X|Xs],[Y|Ys], [X|Result]):-
	X @< Y,
	merge_list_vars(Xs, [Y|Ys], Result),!.

merge_list_vars([X|Xs],[Y|Ys], [Y|Result]):-
	Y @< X,
	merge_list_vars([X|Xs], Ys, Result),!.

merge_list_vars([X|Xs],[X|Ys], [X|Result]):-merge_list_vars(Xs,Ys,Result).

extract_eqs_vars(equations([]), []).
extract_eqs_vars(equations([equation(VarList)|Eqs]), ListResult):-
	extract_eqs_vars(equations(Eqs), NewListResult1),
	extract_eq_vars(equation(VarList), EqNames),
	merge_list_vars(NewListResult1, EqNames, ListResult).

remove_unwanted_vars([],_,[]).
remove_unwanted_vars(Xs, [], Xs):-!.
remove_unwanted_vars([X|Xs], [X|Ys], Others):- remove_unwanted_vars(Xs, Ys, Others),!.
remove_unwanted_vars([X|Xs], [Y|Ys], [X | Others]):- X @< Y, remove_unwanted_vars(Xs, [Y|Ys], Others),!.
remove_unwanted_vars([X|Xs], [Y|Ys], Others):- Y @< X, remove_unwanted_vars([X|Xs], [Y|Ys], Others),!.

sub_eqs_solve(Equations, [], Equations).
sub_eqs_solve(Equations, [Var|Others],Result):-
	sub_eqs_solve(Equations, Others, TempResult),
	eqs_solve_step(TempResult, Var, Result).

make_eq_beauty(equation(VarList), Result):- 
	member(variable(Name,Factor),VarList), 
	Name \= "_", 
	Divider is 1 / Factor,
	eq_multiply(equation(VarList), Divider, Result),!.

make_eqs_beauty(equations([]), equations([])).
make_eqs_beauty(equations([Eq|Eqs]), equations([EqBeautiful|TempResult])):-
	make_eqs_beauty(equations(Eqs), equations(TempResult)),
	make_eq_beauty(Eq, EqBeautiful).


eqs_solve(Equations, Names, Result):-
	extract_eqs_vars(Equations, EqsNames),
	remove_unwanted_vars(EqsNames, Names, EqNamesWithoutNames),
	remove_unwanted_vars(EqNamesWithoutNames, ["_"], EqNamesUpdated),
	sub_eqs_solve(Equations, EqNamesUpdated, TempResult),
	make_eqs_beauty(TempResult, Result),!.

/*-----------------------------8--------------------------------*/

eqs_solutions(_, [], []).
eqs_solutions(Equations, [Var|Vars], [Res|OtherRes]):-
	eqs_solve(Equations,[Var], equations([TempResult])),
	eq_extract(TempResult, Var, equation([variable("_", NumResult)])),
	Res = variable(Var,NumResult),
	eqs_solutions(Equations, Vars, OtherRes),!.

