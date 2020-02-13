(* 	Name: 			Eric Altenburg
	Description: 	Implementation of DTree
	Pledge: 		I pledge my honor that I have abided by the Stevens Honor System.
	Date: 			10 February 2020 
*)

type ('a, 'b) dTree = Leaf of 'a | Node of 'b * ('a,'b) dTree * ('a,'b) dTree

let tLeft = failwith "Implement"

let tRight = failwith "Implement"

let dTree_height (t:dTree) : int = 
	failwith "Implement"

let dTree_size (t:dTree) : int =
	failwith "Implement"

let dTree_paths (t:dTree) : int list list = 
	failwith "Implement"

let dTree_is_perfect (t:dTree) : bool = 
	failwith "Implement"

let dTree_map f g (t:dTree) : dTree = 
	failwith "Implement"

let list_to_tree (l: char list) : dTree = 
	failwith "Implement"

let replace_leaf_at (t:dTree) f : dTree = 
	failwith "Implement"

let bf_to_dTree = 
	failwith "Implement"