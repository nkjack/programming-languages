:-use_module(library(clpfd)).

/*---------------------------PART 1 -------------------------*/
legal_hour(Sh1,Eh1,Sh2,Eh2):- Eh1#=<Sh2 ; Sh1#>=Eh2.

del(X, [X|Xs], Xs).
del(X, [Y|Ys], [Y|Zs]) :- del(X, Ys, Zs).

insert_order(X, [], [X]).

insert_order(X, [Y|Rest], [X,Y|Rest]) :-
    class(_,time(SH1,SM1),_,_) = X,
    class(_,time(SH2,SM2),_,_) = Y,
    (SH1 #< SH2 ; (SH1#=SH2,SM1#<SM2)), !.

insert_order(X, [Y|Rest0], [Y|Rest]) :- insert_order(X, Rest0, Rest).

/*inserting tutorial to schedule*/
insert_to_schedule(TutorialClass, Day, [], [day(Day,[TutorialClass])]). 

insert_to_schedule(TutorialClass, Day, [day(Day,OrigClassList)|Tail], [day(Day,NewClassList)|Tail]):- 
      insert_order(TutorialClass, OrigClassList, NewClassList),!.

insert_to_schedule(TutorialClass, Day, [day(Day1,ClassList)|Tail1], [day(Day1,ClassList)|Tail2]):- 
      insert_to_schedule(TutorialClass,Day, Tail1, Tail2).

/*check overlap time of class with other classes*/
check_overlap(_,_,[]).
check_overlap(time(Sh,Sm),time(Eh,Em),[class(_, time(Sh2,_),time(Eh2,_),_)|Others]):-
    legal_hour(Sh,Eh,Sh2,Eh2), check_overlap(time(Sh,Sm),time(Eh,Em),Others).  

/*check classes in same day - if not overlap hours*/
check_classes([]).
check_classes([class(_, ST, ET,_)|Others]):- check_overlap(ST,ET,Others), check_classes(Others).

/*check schedule is ok - no overlap hours*/
check_schedule([]).
check_schedule([day(_,Classes)|RestDays]):- check_classes(Classes), check_schedule(RestDays).

weekly_schedule([],[]).
weekly_schedule([CourseNumber|Others],Schedule):- 
      weekly_schedule(Others, NewSchedule),
      course(CourseNumber,_,_,ListLectures,ListTutorials),
      
      member(tutorial(TutTeacher,StartTutorial,EndTutorial,DayTutorial),ListTutorials),
      member(lecture(LecTeacher,StartLecture,EndLecture,DayLecture),ListLectures),

      TutorialClass = class(TutTeacher, StartTutorial, EndTutorial,CourseNumber),
      LectureClass = class(LecTeacher, StartLecture, EndLecture, CourseNumber),

      insert_to_schedule(TutorialClass, DayTutorial ,NewSchedule, NewScheduleTemp),
      insert_to_schedule(LectureClass, DayLecture ,NewScheduleTemp, Schedule),
      
      check_schedule(Schedule).


/*---------------------------PART 2-------------------------*/                                     

%----------------------------------------------------------------------%

taken_twelve_half(day(_,Classes)):-
    SH #=< 12,EH #>= 13, member(class(_,time(SH,_),time(EH,_),_),Classes).

taken_one_half(day(_,Classes)):-
    SH #=< 13,EH #>= 14, member(class(_,time(SH,_),time(EH,_),_),Classes).

taken_two_half(day(_,Classes)):-
    SH #=< 14,EH #>= 15, member(class(_,time(SH,_),time(EH,_),_),Classes).

takenTime([Day]):-taken_twelve_half(Day),taken_one_half(Day),taken_two_half(Day).
takenTime([Day|Days]) :-
  (
   taken_twelve_half(Day),taken_one_half(Day),taken_two_half(Day)
  ) ;
  takenTime(Days).

lunch_friendly([]).
lunch_friendly(Schedule) :-not(takenTime(Schedule)).

%----------------------------------------------------------------------%

adj_classes([day(_,Classes)]):-
  member(class(_,time(SH1,_),time(EH1,_),_),Classes),
  member(class(_,time(SH2,_),time(EH2,_),_),Classes),
  (EH1 #= SH2 ; EH2 #= SH1),!.

adj_classes([day(_,Classes)|Days]):-
    adj_classes(Days);
  (
    member(class(_,time(SH1,_),time(EH1,_),_),Classes),
    member(class(_,time(SH2,_),time(EH2,_),_),Classes),
    (EH1 #= SH2 ; EH2 #= SH1)
  ).

no_running(Schedule):- not(adj_classes(Schedule)).

%----------------------------------------------------------------------%

remove_day(X, [X|Xs], Xs).
remove_day(X, [Y|Ys], [Y|Zs]) :-remove_day(X, Ys, Zs).

remove_days_temp([],Input,Input).
remove_days_temp([day(Day,_)|Days], Input, Output):- 
      remove_days_temp(Days, Input ,Output1),
      remove_day(Day, Output1,Output),!.


free_days_temp(Days,Output):-remove_days_temp(Days, [sunday,monday,tuesday,wednesday,thursday,friday,saturday],Output).

free_days(Schedule, Days):-free_days_temp(Schedule,Days).

%----------------------------------------------------------------------%

no_wake_up([]).
no_wake_up([day(_,[class(_,time(S1,_),_,_)|_])|Days]):-
  S1 #>= 10, no_wake_up(Days).

%----------------------------Part 3 -----------------------------------%

%query
/*
weekly_schedule([234319,234218,234262,094412,234293],Schedule),
    lunch_friendly(Schedule),
    free_days(Schedule,Days),
    del(friday,Days,NewDays),
    del(saturday,NewDays,Res),
    length(Res,N),
    N #> 0.

weekly_schedule([234319,234218,234262,094412,234293],Schedule),
    lunch_friendly(Schedule),
    no_running(Schedule).
*/



/*-----------------------------Part D -----------------------------*/
courses_with_time_to_study(Courses):-
    courses_permut(Courses),
    exams_for_courses(Courses,Exams),
    sync_exams(Exams).

courses_permut([]).
courses_permut([Num]):-exam(Num,a,_).
courses_permut([Num1,Num2|Others]):- 
  exam(Num1,a,_),
  exam(Num2,a,_),
  Num1 < Num2, 
  courses_permut([Num2|Others]).

exams_for_courses([], []).
exams_for_courses([Course | Courses], [exam(Course,a,Date) | Exams]):- 
  exam(Course,a,Date), 
  exams_for_courses(Courses,Exams).

exams_for_courses([Course | Courses], [exam(Course,b,Date) | Exams]):- 
  exam(Course,b,Date), 
  exams_for_courses(Courses,Exams).

 
sync_exams(Exams):- check_all_exams(Exams,Exams).

check_all_exams([], _).
check_all_exams([Ex | Others], Exams):-
  check_course_ok_for_exam(Ex, Exams),
  check_all_exams(Others, Exams).
  

check_course_ok_for_exam(_,[]).
check_course_ok_for_exam(exam(Num1,_,Date), [exam(Num2,_,Date2)|Others]):-
  date_time_stamp(Date,S1),
  date_time_stamp(Date2,S2), 
  Z1 is S1 - S2,
  ((Z1 >= 259200 ; Z1 =< -259200) ; ( Num1 = Num2 )), 
  check_course_ok_for_exam(exam(_,_,Date), Others),!.

/*-------------------------------------------Part D course_points---------------------------*/
courses_points([],0).
courses_points([Course|Courses], P):- 
  course(Course,X1,_,_,_),
  X2 #= P - X1,
  courses_points(Courses, X2).

/*---------------------------------------- Part E ----------------------------------------*/

/*queries*/

/*query 2*/
/*
courses_with_time_to_study(Courses),courses_points(Courses,X), X >= 12.
*/
/*query 3*/

/*helper relations*/

courses_with_time_are_not_max(CourseList1):-
  courses_with_time_to_study(CourseList2),
  courses_points(CourseList1, X),
  courses_points(CourseList2, Y),
  Y > X.

all_max_courses_with_time_to_study(CourseList):-
  courses_with_time_to_study(CourseList),
  not(courses_with_time_are_not_max(CourseList)).

/*all_max_courses_with_time_to_study(CourseList).*/





