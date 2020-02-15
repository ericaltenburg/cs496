(* 	Name: 			Eric Altenburg
	Description: 	Implementation of DTree
	Pledge: 		I pledge my honor that I have abided by the Stevens Honor System.
	Date: 			10 February 2020 
*)

type ('a, 'b) dTree = Leaf of 'b | Node of 'a * ('a, 'b) dTree * ('a, 'b) dTree

(* Just for testing, IGNORE *)
let tSmall = Node('b', Leaf 1, Leaf 2)

let tBig = Node ('a',
				Node('r',
					Node('c', Leaf 1, Leaf 2),
					Node('d', Leaf 3, Leaf 4)),
				Node('j',
					Node('u',
						Node('y', Leaf 5, Leaf 6),
						Leaf 8),
					Leaf 4))

let tLeft = Node('w',
				Node('x', Leaf 2, Leaf 5),
				Leaf 8)

let tRight = Node('w',
				Node('x', Leaf 2, Leaf 5),
				Node('y', Leaf 7, Leaf 5))

let rec dTree_height_h t i : int =
	match t with
	| Leaf t -> i
	| Node (d, lt, rt) -> max (dTree_height_h lt (i+1)) (dTree_height_h rt (i+1))

let dTree_height t : int = 
	dTree_height_h t 0

let rec dTree_size_h t i: int = 
	match t with
	| Leaf t -> 1
	| Node (d, lt, rt) -> 1 + (dTree_size_h lt i) + (dTree_size_h rt i)

let dTree_size t : int =
	dTree_size_h t 1

let rec dTree_paths (t: ('a, 'b) dTree) : 'b list list = 
	match t with
	| Leaf l -> []::[]
	| Node(d, lt, rt) -> List.map (List.cons 0) (dTree_paths lt) @ List.map (List.cons 1) (dTree_paths rt)

let rec dTree_is_perfect_h ll len = 
	match ll with
	| [] -> true
	| h::t -> if (List.length h == len)
				then dTree_is_perfect_h t len
				else false

let dTree_is_perfect t : bool = 
	dTree_is_perfect_h (dTree_paths t) (List.length(List.hd (dTree_paths t)))

let rec dTree_map f g t = 
	match t with
	| Leaf l -> Leaf (g l)
	| Node(d, lt, rt) -> Node ((f d), dTree_map f g lt, dTree_map f g rt)

let rec list_to_tree (l: char list) = 
	match l with
	| []-> Leaf 0
	| h::t -> Node(h, list_to_tree t, list_to_tree t)

let grab_rest f = 
	match f with
	| [] -> []
	| [x] -> [x]
	| h::t -> t

let rec replace_leaf_at_h t f height lvl = 
	match t with
	| Leaf l -> Leaf (snd (List.hd f))
	| Node (d, lt, rt) -> 
							if (lvl == (height -1))
							then Node (d, replace_leaf_at_h lt f height lvl, replace_leaf_at_h rt (grab_rest f) height lvl)
							else Node (d, (replace_leaf_at_h lt f height (lvl+1)), (replace_leaf_at_h rt f height (lvl+1)))

let replace_leaf_at t f = 
	replace_leaf_at_h t (snd f) (dTree_height t) 0

let rec helper t drc num = 
	match t with
	| Leaf l -> Leaf num
	| Node (d, lt, rt) -> 
							if ((List.hd drc) == 0)
							then Node (d, helper lt (grab_rest drc) num, rt)
							else Node (d, lt, helper rt (grab_rest drc) num)

let rec test_replace tr lst= 
	match lst with
	| [] -> tr
	| h::t -> test_replace (helper tr (fst h) (snd h)) t




let bf_to_dTree encoding = 
	replace_leaf_at (list_to_tree (fst encoding)) encoding