(*	Name: 			Eric Altenburg
 *	Date: 			2/5/2020
 * 	Description:	Implementation of functions to be used in connect the dots assignment
 * 	Pledge: 		I pledge my honor that I have abided by the Stevens Honor System.
 *)

(* TYPES *)
type coord = int*int
type coded_pic = coord list


(* VARS *)
let cp1:coded_pic = [(0,0);(2,0);(2,2);(0,2);(0,0)] (* Square *)
let cp2:coded_pic = [(0,0);(4,0);(4,4);(0,0)]	(* Triangle *)


(* STRETCH - Explicit recursion with 1 explicit helper function and mapping *)
(* Multiplies the coords by a factor *)
let mult_coords (f:int)(p:coord):coord = 
	(((fst p)* f), ((snd p) * f))

 (* Explicit recursion *)
let rec stretch (p:coded_pic) (factor:int) : coded_pic = 
 	match p with
	|	[] -> []
	| 	h::t -> mult_coords factor h :: stretch t factor

 (* Mapping *)
let stretch_m (p:coded_pic) (factor:int) = List.map (mult_coords factor) p


(* SEGMENT *)
let rec segment (cx,cy) (nx,ny) : coord list = 
	if ((nx - cx == 0 || ny - cy == 0) || (nx - cx == ny - cy))
	then 	if (cx == nx && cy == ny)
			then []
			else (cx+compare nx cx, cy+compare ny cy) :: segment (cx+compare nx cx, cy+compare ny cy) (nx,ny)
	else []


(* COVERAGE - Explicit recursion with 1 explicit helper function and folding left *)
(* Helper *)
let rec coverage_h = function
	| [] -> []
	| [x] -> []
	| h::t -> segment h (List.hd t) @ coverage_h t

(* Recursion *)
let coverage ((start::p):coded_pic):coord list = 
 	start::coverage_h (start::p)

 let func lst x = 
 	lst @ segment (List.hd (List.rev lst)) x

(* Folding *)
let coverage_f ((start::p):coded_pic):coord list = 
	List.fold_left func [start] p


(* EQUIVALENT_PICS - 1 explicit helper function *)
(* Helper *)
let rec equivalent_pics_h (cp1:coded_pic) (cp2:coded_pic):bool = 
	match cp2 with
	| [] -> true
	| h::t ->	if (List.mem h cp1)
				then equivalent_pics_h cp1 t
				else false

let equivalent_pics (cp1:coded_pic) (cp2:coded_pic):bool = 
	equivalent_pics_h (coverage cp1) cp2


(* HEIGHT - 1 explicit helper function *)
(* Helper for height *)
let rec height_h (p:coded_pic) (m:int) (l:int):int =
	match p with
	| [] -> m - l
	| [x] -> 	if ((snd x) > m)
				then height_h [] (snd x) l
				else	if ((snd x) < l)
						then height_h [] m (snd x)
						else height_h [] m l
	| h::t -> height_h t (max m (max (snd h) (snd (List.hd t) ))) (min l (min (snd h) (snd (List.hd t))))

let height (p:coded_pic):int = 
	height_h p (snd (List.hd p)) (snd (List.hd p))


(* WIDTH - 1 explicit helper function *)
(* helper with width *)
let rec width_h (p:coded_pic) (m:int) (l:int):int = 
	match p with
	| [] -> m - l
	| [x] -> 	if ((fst x) > m)
				then width_h [] (fst x) l
				else	if ((fst x) < l)
						then width_h [] m (fst x)
						else width_h [] m l
	| h::t -> width_h t (max m (max (fst h) (fst (List.hd t) ))) (min l (min (fst h) (fst (List.hd t))))

let width (p:coded_pic):int = 
	width_h p (fst (List.hd p)) (fst (List.hd p))


(* TILE - 5 explicit helper function *)
(* Increment the x coord by a num *)
let add_coord_x (num:int)(p:coord):coord = 
	(((fst p) + num), (snd p))

(* Increment the y coord by a num *)
let add_coord_y (num:int) (p:coord):coord =
	((fst p), (snd p) + num)

(* Given a coded_pic, increment the x or y depending on a direction input by either the height of width *)
let rec increment_pic (dir:int) (num:int) (p:coded_pic): coded_pic=
	match p with
	| [] -> []
	| h::t -> 	if dir == 1
				then (add_coord_x num h) :: increment_pic dir num t
				else if dir == 0
				then (add_coord_y num h) :: increment_pic dir num t
				else []

(* Build the columns of the tile *)
let rec tile_c num p =
	match num with
	| 0 -> []
	| n -> p::tile_c (num-1) (increment_pic 1 (width p) p)

(* Build the rows of the tile *)
let rec tile_r ((dx,dy):coord) (og:int) (p:coded_pic) = 
	match dy with
	| 0 -> []
	| n -> 	if (dy == og)
			then tile_c dx p :: tile_r (dx,dy-1) og p
			else tile_c dx (increment_pic 0 (height p) p) :: tile_r (dx,dy-1) og (increment_pic 0 (height p) p)

let tile ((dx,dy):coord) (p:coded_pic) : coded_pic list list = 
	tile_r (dx,dy) dy p


(* TRI_ALLIGNED - 1 explicit helper function *)
(* Helper *)
let tri_aligned_h (l:coord list) (c: coord):bool = 
	match l with
	| [] -> false
	| h::t ->	if (List.mem c l)
				then true
				else false

let tri_aligned ((x1,y1):coord) ((x2,y2):coord) ((x3,y3):coord):bool = 
	tri_aligned_h (segment (x1,y1) (x2,y2)) (x3,y3) || tri_aligned_h (segment (x1,y1) (x3,y3)) (x2,y2) || tri_aligned_h (segment (x2,y2) (x3,y3)) (x1,y1)


(* COMPRESS - 1 explicit helper function *)
(* Get rid of the first element and return the rest of the array *)
let make_list t  =
	match t with
	| [] -> []
	| h::t -> t

let rec compress (p:coded_pic):coded_pic = 
 	match p with
 	| [] -> []
 	| [x] -> [x]
 	| [a;b] -> [a;b]
	| h::t -> 	if (tri_aligned h (List.hd t) (List.nth t 1))
				then h :: compress (make_list t)
				else h::compress t

let rec stutter_helper (m:int) (n:int) = 
	if n > 0
	then m :: stutter_helper m (n-1)
	else []

let rec stutter (m:int) (n:int) =  
	if m >= 0
	then (stutter_helper m n :: []) @ stutter (m-1) n
	else []

let rec is_zero_list l = 
match l with
| [] -> []
| h::t ->
	if h = 0
	then [true] @ is_zero_list t
	else [false] @ is_zero_list t
