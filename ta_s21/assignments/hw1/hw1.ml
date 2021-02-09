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