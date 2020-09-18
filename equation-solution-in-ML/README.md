# Equation-solution-in-ML
This is part of an homework in Programming Languages course - Technion University.

# Types
The basic type of variable with a its coefficient is string*real, where string is the variable and real is the coefficient. To represent the free coefficient I'll use the "_" symbol. 
Example: 2x + 3y -5 = 0 ---- [(“x”, 2.0), (“y”, 3.0), (“\_”, ~5.0)].

# Functions
val eq_sort = fn : (string * real) list -> (string * real) list

val eqs_sort =fn : (string * real) list list -> (string * real) list list

val eq_add = fn : (string * real) list -> (string * real) list -> (string * real) list

val eq_multiply = fn : (string * real) list -> real -> (string * real) list

val eq_extract = fn : (string * real) list -> string -> (string * real) list

val eq_substitute = fn : (string * real) list -> string -> (string * real) list -> (string * real) list

val eqs_substitute = fn : (string * real) list list -> string -> (string * real) list -> (string * real) list list

val eqs_solve_step = fn : (string * real) list list -> string -> (string * real) list list

val eqs_solve = fn : (string * real) list list -> string list -> (string * real) list list

val eqs_solutions = fn : (string * real) list list -> string list -> (string * real) list

# Functions - Explanation

eq_sort - get an equation and return the same equation sorted by lexicographical order.

eqs_sort - sorting System of linear equations, sorting each of it's equation.

eq_add - sum 2 equations together.

eq_multiply - multiply an equation with a constant.

eq_extract - extract a variable from an equation.

eq_substitute - with equation, varaiable name (in the eq), expression. This function will substitute the expression in each appearance of the varaiable in the equation.

eqs_substitute - use eq substitue for each equation in the system of linear equations.

eqs_solve_step - step in solving the system of linear equations. With System of linear equations and variable as input, hide each of the appearances of the given variable using the substitute functions.

eqs_solve - With system of linear equations and list of variables as input, this function return a new system of eqs with only variables that belong to the given list of variables.

eqs_solutions - represent the solution of a system of linear equations in a more beautiful way. Using eqs solve to represent only the final solutions.
