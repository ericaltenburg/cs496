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

let list_to_tree (l: char list) = 
	failwith "Implement"

let replace_leaf_at t f = 
	failwith "Implement"

let bf_to_dTree t = 
	failwith "Implement"