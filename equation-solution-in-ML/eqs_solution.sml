local 
	fun partition (pred, pivot, nil,(arr1,arr2)) = (arr1,arr2)  
		| partition (pred, pivot, y::ys,(arr1,arr2)) = 
			if pred(y,pivot) 
			then partition (pred, pivot, ys, (arr1@[y],arr2))
			 else  partition (pred, pivot, ys, (arr1,arr2@[y]))
in 
	fun quickSort pred nil = nil
		| quickSort pred (x::nil) = [x]
		| quickSort pred (x::xs) =
			let
				val (arr_s, arr_l) = partition(pred, x, xs,([],[]))
			in
				(quickSort pred arr_s)@[x]@(quickSort pred arr_l)
			end;
end;

(**
quickSort op> [1,3,4,6,8,9,2,4,6,8,7];
quickSort op< [1,3,4,6,8,9,2,4,6,8,7];
quickSort op< [];
**)

local
	exception Exp;

	fun take (0,_) = []
			| take(i, x::xs) = x::take(i-1,xs)
			| take(_,_) = raise Exp

	fun drop (0, xs) = xs
		| drop (i, _::xs) = drop (i-1, xs)
		| drop (_,_) = raise Exp

	fun merge pred [] [] = []
		| merge pred [x] [] = [x]
		| merge pred [] [x] = [x]
		| merge pred (x::xs) (y::ys) = 
			if pred(x,y) 
			then [x]@(merge pred (xs) (y::ys)) 
			else [y]@(merge pred (x::xs) (ys))
		| merge _ arr1 arr2 = raise Exp

	fun split pred [] = []
		| split pred [x] = [x]
		| split pred arr = 
		let
			val arr_size = length arr;
			val half_size = arr_size div 2;
			val arr1 = take(half_size, arr);
			val arr2 = drop(half_size, arr);
		in
			merge pred (split pred arr1) (split pred arr2)
		end

in
	fun mergeSort pred [] = []
		| mergeSort pred arr = split pred arr
end;

(**
quickSort op> [1,3,4,6,8,9,2,4,6,8,7];
quickSort op< [1,3,4,6,8,9,2,4,6,8,7];
quickSort op< [];
**)

local
	fun filter pred [] = []
		| filter pred (x::xs) =
			if pred x then (x:: filter pred xs)
			else filter pred xs

	fun  filterArray _ [] new_arr = new_arr
		| filterArray pred (x::xs) new_arr = 
			let
				val withX = filter (fn (y) => if pred(y,x) then true else false) (x::xs);
				val withOutX = filter (fn (y) => if pred(y,x) then false else true) xs;				
				val new_record = {count= length(withX), item=x};		
			in
				filterArray pred withOutX (new_arr@[new_record])
			end
in
	fun counter pred arr = filterArray pred arr []
end;

(*counter op= [1,2,3,4,5,6,7,8,9,2,4,6,8,3,6,9,4,8,5,6,7,8,9];*)
(*counter op= [];*)

fun eq_sort eq_list = 
	let
		fun pred ((var1:string, param1:real),(var2,param2)) = if var1 < var2 then true else false 
	in
		quickSort pred eq_list
	end;

(*eq_sort [("x",2.1),("b",2.1),("a",2.1),("y",2.1)];*)
(*eq_sort [("y", 1.0), ("x", 2.0)];*)

fun eqs_sort eqs_list = map (eq_sort) eqs_list;

fun eq_add [] [] = []
	| eq_add [] eq = eq
	| eq_add eq [] = eq
	| eq_add ((st1:string,rl1:real)::xs) ((st2,rl2)::ys) = 
		if (st1 < st2) 
		then ([(st1,rl1)]@(eq_add (xs) ((st2,rl2)::ys))) 
		else 
			if (st1 > st2) 
			then ([(st2,rl2)]@(eq_add (ys) ((st1,rl1)::xs)))
			else ([(st1,rl1+rl2)]@(eq_add (xs) (ys)));
			
(*eq_add [("bar", 1.0), ("foo", 2.0)] [("bar", 2.0), ("buzz", 5.0)];*)

fun eq_multiply [] mult_param = []
	| eq_multiply ((st1:string,rl1:real)::xs) mult_param = 
		([(st1,rl1*mult_param)]@(eq_multiply (xs) mult_param));

(*eq_multiply [("a", 2.0), ("b", 1.0)] 3.0;*)

fun eq_extract [] wanted = [] 
  | eq_extract ((var:string,param:real)::xs) wanted = 
    if (wanted=var) then (eq_extract (xs) wanted) 
    else ([(var,(~param))]@(eq_extract (xs) wanted));

local
  fun findDivFactor [] wanted = 1.0
  | findDivFactor ((var:string,param:real)::xs) wanted = 
    if (wanted=var) then param else findDivFactor (xs) wanted
    
  fun extractAux [] wanted divFactor = []
  | extractAux ((var:string,param:real)::xs) wanted divFactor = 
    if (wanted=var) then (extractAux (xs) wanted divFactor) else
    ([(var,((~param) / divFactor))]@(extractAux (xs) wanted divFactor))
    
in
  fun eq_extract [] wanted = []
  	| eq_extract ((var:string,param:real)::xs) wanted = 
  	let
  		val temp = findDivFactor ((var,param)::xs) wanted;
  	in
  		extractAux ((var,param)::xs) wanted temp
  	end
end;

(*eq_extract [("x", 2.0), ("y", 4.0), ("z", 8.0)] "x";*)
(*eq_extract [("x", 1.0), ("y", 3.0), ("z", 5.0), ("_", 23.0)] "z";*)

local
	exception Exp;

	fun method3 [] var  = []
		| method3 ((str1:string,rl1:real)::xs) var  = 
		if (str1 = var) then method3 xs var 
		else ([(str1,rl1)]@(method3 xs var))

	fun method2 [] var eql2 orig_eq= raise Exp
		| method2 ((str1:string,rl1:real)::xs) var eql2 orig_eq=
			if str1 = var 
			then (eq_add (eq_sort (method3 (orig_eq) var)) (eq_sort (eq_multiply eql2 rl1))) 
			else method2 xs var eql2 orig_eq

	(*check if var is inside the equation if yes call method2 else return equation1*)
	fun method1 eql1 var eql2 =
		let
			fun pred (var_name:string,_) = if (var_name = var) then true else false;

			fun exists p [] = false
				| exists p (x::xs) = (p x) orelse exists p xs;
		in
			if exists pred eql1 then (method2 (eql1) var (eql2) (eql1)) else eql1
		end
	
in
	fun eq_substitute [] var _ = []
	| eq_substitute eq_list var [] = eq_list
	| eq_substitute ((str1:string,rl1:real)::xs) var exp_l =
		method1 ((str1,rl1)::xs) var exp_l
end;

(*eq_substitute [("x", 2.0), ("y", 1.0),("_",2.1)] "x" [("y", 1.0)];*)


fun eqs_substitute [] var exp = []
	| eqs_substitute (x::xs) var exp = [(eq_substitute x var exp)]@(eqs_substitute xs var exp);
(*
eqs_substitute [[("x", 2.0), ("y", 1.0),("_",2.1)],
				[("x", 2.0), ("y", 1.0),("_",2.1)],
				[("y", 1.0),("_",2.1)]] "x" [("y", 1.0)];*)
				

local

  fun filter pred [] = []
     | filter pred (x::xs) =
          if pred x then (x:: filter pred xs)
                    else      filter pred xs;

  fun methodWith eq_l wanted= let
      fun findVar [] = false
        | findVar ((var:string,param:real)::xs) =
          if (wanted=var) then true else findVar (xs);
    in
      filter findVar eq_l
    end

     fun methodWithout eq_l wanted= let
        fun findVar2 [] = true
          | findVar2 ((var:string,param:real)::xs) =
            if (wanted=var) then false else findVar2 (xs);
      in
        filter findVar2 eq_l
      end

    fun extAndSub [] _ = []
      | extAndSub (x::xs) wanted =
        let
          val extract = eq_extract (x) wanted;
        in
        	eqs_substitute (xs) wanted extract
        end

    fun finalMethod eq_l var =
    	let
    		val filtered = methodWith (eq_l) var;
    		val notFiltered = methodWithout (eq_l) var;
    	in
    		(extAndSub (filtered) var)@(notFiltered)
    	end
in
    fun eqs_solve_step eq_l var = finalMethod (eq_l) var
end;


local
	exception Exp;

	fun exists p [] = false
				| exists p (x::xs) = (p x) orelse exists p xs;

    (*Method2: returns the list of variables we want to use *)
    fun method2 [] varsKeep varsThrow = varsThrow
        | method2 ((var:string,param:real)::xs) varsKeep varsThrow =
            if (exists (fn x=> if (x = var) then true else false) varsKeep
                orelse exists (fn x=> if (x = var) then true else false) varsThrow)
            then
                method2 (xs) varsKeep varsThrow
            else
                (method2 (xs) varsKeep ([var]@(varsThrow)))
            
    (*Method1: scans through all the lists then uses method2 above *)
    fun method1 [] varsKeep varsThrow = varsThrow
        | method1 (x::xs) varsKeep varsThrow =
            method1 (xs) varsKeep (method2 (x) (varsKeep) (varsThrow))

    (*Match foldl to our needs *)
    fun newFoldl func [] eqls = eqls
        | newFoldl func (x::xs) eqls = newFoldl func (xs) (func eqls x)

    (*Method3: returns activates eqs_solve_step on the equlibriams
      using the naughtyVars we want to extract and sub            *)
    fun method3 eqls naughtyVars = (newFoldl eqs_solve_step naughtyVars eqls)

    (*find value of one of the good vars in order to multiply it after*)
    fun findValueOfVar [] _ = raise Exp
    	| findValueOfVar _ [] = raise Exp
    	| findValueOfVar ((str1:string,rl1:real)::eqls) vars = 
    		if exists (fn x=> x=str1) vars then (1.0 / rl1) else findValueOfVar eqls vars

    fun makeEqlNoraml vars eql = (eq_multiply eql (findValueOfVar eql vars))
    
    (*Method 4: using method 3 and make sure every interesting variable has
    	a param of 1.0*)
    fun method4 eql vars = 
    	let
    		val sorted = eqs_sort eql;
        	val naughtyVars = method1 sorted (vars@["_"]) [];
        	val goodEqls = method3 sorted naughtyVars;
    	in
    		map (makeEqlNoraml vars) goodEqls
    	end

in
    (*fun eqs_solve eql vars = (method1 (eqs_sort eql) (vars@["_"]) [])*)
    fun eqs_solve eql vars =
    let
        val goodEqls = (method4 eql vars);
    in
    	goodEqls
    end
end;


(*eqs_solve [[("x", 2.0), ("y", 4.0)], [("x", 7.0), ("y", 3.0), ("z", 5.0),("_",123.2)]] ["x"]*)
(*val partial = eqs_solve [
  [("x", 1.0), ("y", 3.0), ("z", 5.0), ("_", 23.0)],
  [("x", 3.0), ("y", 1.0), ("z", 8.0), ("_", 22.0)],
  [("x", 7.0), ("y", 2.0), ("z", 3.0), ("_", 34.0)]] ["x", "y"];*)

(*val temp = eqs_solve partial ["x"];*)
(*eq_extract (hd temp) "_";*)
(*eqs_solve partial ["y"];*)

local
	exception Exp;
	(*solve equations according to all vals*)
	fun recursiveSol eqls [] = []
		| recursiveSol eqls (var::vars) = (eqs_solve eqls [var])@(recursiveSol eqls vars)

	(*final equation need to show only value*)
	fun formatEquation [] = raise Exp
		| formatEquation ((str1:string,rl1:real)::nil) = raise Exp
		| formatEquation ((str1:string,rl1:real)::(str2:string,rl2:real)::ys) = (str2, ~rl1)

	fun wrapperMethod [] = [] 
	 	| wrapperMethod (eq::finalEqls) = [(formatEquation eq)]@(wrapperMethod finalEqls)
in
	fun eqs_solutions eqls vars = 
		let
			val finalEqls = (recursiveSol eqls vars);
		in
			(wrapperMethod finalEqls)
		end
end;

(*eqs_solutions [[("x", 1.0), ("y", 3.0), ("z", 5.0), ("_", 23.0)],
  [("x", 3.0), ("y", 1.0), ("z", 8.0), ("_", 22.0)],
  [("x", 7.0), ("y", 2.0), ("z", 3.0), ("_", 34.0)]] ["x", "y"];*)