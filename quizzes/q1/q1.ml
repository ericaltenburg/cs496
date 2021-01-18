let even_list = [1;2;3;4;5;6]
let odd_list = [1;2;3;4;5]
let small_list = [1;2;3;4]

let rec length l = 
	match l with
	| [] -> 0
	| h::t -> 1 + length t

let rec compare_list l il =
	match l with
	| [] -> []
	| h::t ->
		match il with
		| [] -> h :: compare_list t []
		| [x] -> compare_list t []
		| x::xs -> compare_list t xs

let rec split_helper l c = 
	match l with
	| [] -> []
	| h::t ->
		if c > 0
		then h :: split_helper t (c-1)
		else []

let split l =
	let first_half = split_helper l ((length l)/2) in
	(first_half :: []) @ (compare_list l first_half :: [])
(* 	if (length l mod 2 = 0)
	then (split_helper l ((length l)/2) :: []) @ (compare_list l (split_helper l ((length l)/2) :: []))
	else (split_helper l ((length l)/2) :: []) @ (compare_list l (split_helper l ((length l)/2) :: []))

	- take the first list, then compare the list until I get something that doesn't match and make a new list with that
 *)