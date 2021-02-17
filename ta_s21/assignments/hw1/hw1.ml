type program = int list

let square : program = [0; 2; 2; 3; 3; 4; 4; 5; 5; 1]
let letter_e : program = [0; 2; 2; 3; 3; 5; 5; 4; 3; 5; 4; 3; 3; 5; 5; 1]

let rec mirror_image_helper n = 
	match n with
	| 0 -> 0
	| 1 -> 1
	| 2 -> 4
	| 3 -> 5
	| 4 -> 2
	| 5 -> 3
	| _ -> -1

let mirror_image p =
	List.map mirror_image_helper p

let rec rotate_90_letter_helper n = 
	match n with 
	| 0 -> 0
	| 1 -> 1
	| 2 -> 3
	| 3 -> 4
	| 4 -> 5
	| 5 -> 2
	| _ -> -1

let rotate_90_letter p =
	List.map rotate_90_letter_helper p

let rotate_90_word (p: int list list): int list list = 
	List.map rotate_90_letter p

(* let rec repeat n x = 
	match n with
	| 0 -> []
	| m -> 
		match m with
		| 0 -> [0]
		| 1 -> [1]
		| _ -> x :: repeat (n-1) x

let rec repeat_p n x = 
	match n with
	| 0 -> []
	| m -> 
		match m with 
		| 0 ->[0]
		| 1 -> [1]
		| n -> [n] @ repeat (n-1) x

let pantograph_p n l = 
	List.map (repeat n) l

let rec pantograph n l = 
	match l with
	| [] -> []
	| h::t -> 
		match h with
		| 0 -> 0 :: pantograph n t
		| 1 -> 1 :: pantograph n t
		| _ -> 3 :: pantograph n t *)

(* let rec repeat n x = 
	match n with 
	| 0 -> []
	| m -> x :: repeat (m-1) x *)

let rec greater_than_one l = 
	match l with 
	| [] -> []
	| h::t -> 
		if h>1
		then h::greater_than_one t
		else greater_than_one t

let rec condense_lists l = 
	match l with
	| [] -> []
	| h::t -> h @ condense_lists t

let rec repeat' n x = 
	match n with
	| 0 -> []
	| m -> 
		if x > 1
		then x :: repeat' (m-1) x
		else x :: repeat' 0 x
(* 
let rec repeat_helper n x=
	match n with
	| 0 -> []
	| m -> x :: repeat_helper (n-1) x *)
(* 
let rec repeat n x =
	match x with
	| 0 -> [0]
	| 1 -> [1]
	| m -> repeat_helper n x *)

let rec pantograph n lst = 
	List.map (repeat' n) lst

let rec count_how_many n prv lst = 
	match lst with
	| [] -> n
	| h::t ->
		if h==prv
		then count_how_many (n+1) h t
		else n

let rec grab_next_few num lst = 
	match num with
	| 0 -> lst
	| m -> grab_next_few (num-1) (List.tl lst)

let rec compress lst =
	match lst with
	| [] -> []
	| h::t -> (h, count_how_many 0 h lst) :: compress (grab_next_few (count_how_many 0 h lst) lst)