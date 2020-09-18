# scheduler-courses-with-Prolog
Part of an assignment in Programming Languages Course - Technion University.
This is a small program which will generate all suitable Schedules.

data.pl - contains all facts about the courses a student can take.
prologfreak.pl - will contain all the relations.

main structure in this code is the Course structure:
% course(Number,
%        Points,
%        Name,
%        [lecture(Teacher,
%                 time(StartHour, StartMinute),
%                 time(EndHour, EndMinute),
%                 Day)
%        ],
%        [tutorial(Tutor,
%                  time(StartHour, StartMinute),
%                  time(EndHour, EndMinute),
%                  Day)
%        ]).

# Relations
*valid schedule is a schedule which a student take 1 lecture and 1 tutorial from each course he needs.

weekly_schedule(CourseList, Schedule) - this relation is set to true if the given schedule is valid for the given courses.

lunch_friendly(Schedule) - true if there is a free hour between 12:00-15:00 each day of the week.

no_running(Schedule) - true if there is a free hour after each class.

free_days(Schedule, Days) - true if Schedule doesn't contain classes in the given days.

no_wake_up(Schedule) - True if the first class of each day starts later than 10:20

