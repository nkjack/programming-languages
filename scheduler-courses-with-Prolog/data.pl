
course(234319, 3, programming_languages,
       [lecture(david, time(8, 30), time(10, 20), wednesday)],
       [tutorial(matan, time(12, 30), time(14, 20), sunday),
        tutorial(tal, time(10, 30), time(12, 20), monday),
        tutorial(tomer, time(15, 30), time(17, 20), wednesday), 
        tutorial(lior, time(8, 30), time(10, 20), thursday)]).

course(234218, 3, data_structures,
	  [lecture(rami, time(8, 30), time(10, 20), monday),
	  	lecture(erez, time(10, 30), time(12, 20), wednesday)],
       [tutorial(yair, time(10, 30), time(11, 20), monday),
        tutorial(david, time(15, 30), time(16, 20), monday),
        tutorial(niv, time(11, 30), time(12, 20), tuesday), 
        tutorial(david, time(10, 30), time(11, 20), thursday),
        tutorial(gil, time(15, 30), time(16, 20), sunday),
        tutorial(uzi, time(15, 30), time(16, 20), wednesday)]).


course(234262, 3, logic_design,
	  [lecture(alexander, time(10, 30), time(12, 20), sunday)],
       [tutorial(moshe, time(15, 30), time(16, 20), tuesday),
        tutorial(rotem, time(9, 30), time(10, 20), wednesday),
        tutorial(noam, time(9, 30), time(10, 20), thursday), 
        tutorial(noam, time(10, 30), time(11, 20), monday)]).

course(234293, 4, logic_and_set_theory,
	  [lecture(orna, time(12, 30), time(15, 20), monday),
	  	lecture(sari, time(10, 30), time(13, 20), thursday)],
       [tutorial(yamit, time(10, 30), time(12, 20), tuesday),
        tutorial(vasim, time(12, 30), time(14, 20), tuesday),
        tutorial(muhamad, time(16, 30), time(16, 20), monday), 
        tutorial(michael, time(8, 30), time(10, 20), wednesday),
        tutorial(maya, time(14, 30), time(16, 20), thursday),
        tutorial(geil, time(15, 30), time(17, 20), wednesday)]).

course(094412, 4, probability,
	  [lecture(dimitry, time(12, 30), time(13, 20), monday)],
       [tutorial(gal, time(15, 30), time(17, 20), monday),
        tutorial(gal, time(16, 30), time(18, 20), wednesday),
        tutorial(amitay, time(18, 30), time(20, 20), monday), 
        tutorial(amitay, time(17, 30), time(19, 20), tuesday)]).


exam(234319, a, date(2018, 7, 9)).
exam(234319, b, date(2018, 10, 3)).

exam(234218, a, date(2018, 7, 27)).
exam(234218, b, date(2018, 09, 17)).

exam(234262, a, date(2018, 7, 20)).
exam(234262, b, date(2018, 10, 19)).

exam(234293, a, date(2018, 7, 5)).
exam(234293, b, date(2018, 10, 16)).

exam(094412, a, date(2018, 7, 13)).
exam(094412, b, date(2018, 10, 9)).

/*-------------------------------------------PART E ------------------------------------*/

/*Dates for these exams are not real and I chose them randomly*/
/*
course(234322, 3, marachot_ichsun_meyda,[],[]).
course(236299, 3, mavo_le_ibut_safot_tiviot,[],[]).
course(236309, 3, mavo_le_torat_ha_zfina,[],[]).
course(236311, 3, sibuchiut_shel_chishuvim_halgebrim,[],[]).
course(236313, 3, torat_ha_sibuchiut,[],[]).
course(236334, 3, mavo_le_reshatot_machshevim,[],[]).
course(236351, 3, distributed_systems,[],[]).


exam(234322, a, date(2018, 7, 5)).
exam(234322, b, date(2018, 10, 9)).

exam(236299, a, date(2018, 7, 7)).
exam(236299, b, date(2018, 10, 10)).

exam(236309, a, date(2018, 7, 10)).
exam(236309, b, date(2018, 10, 12)).

exam(236311, a, date(2018, 7, 13)).
exam(236311, b, date(2018, 10, 13)).

exam(236313, a, date(2018, 7, 15)).
exam(236313, b, date(2018, 10, 14)).

exam(236334, a, date(2018, 7, 19)).
exam(236334, b, date(2018, 10, 17)).

exam(236351, a, date(2018, 7, 21)).
exam(236351, b, date(2018, 10, 20)).

*/