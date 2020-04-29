(* I pledge my honor that I have abided by the Stevens Honor System. - Eric Altenburg *)

open Ast
open ReM
open Dst


let rec type_of_expr : expr -> texpr tea_result = function 
  | Int _n -> return IntType
  | Var id -> apply_tenv id
  | IsZero(e) ->
    type_of_expr e >>= fun t ->
    if t=IntType
    then return BoolType
    else error "isZero: expected argument of type int"
  | Add(e1,e2) | Sub(e1,e2) | Mul(e1,e2)| Div(e1,e2) ->
    type_of_expr e1 >>= fun t1 ->
    type_of_expr e2 >>= fun t2 ->
    if (t1=IntType && t2=IntType)
    then return IntType
    else error "arith: arguments must be ints"
  | ITE(e1,e2,e3) ->
    type_of_expr e1 >>= fun t1 ->
    type_of_expr e2 >>= fun t2 ->
    type_of_expr e3 >>= fun t3 ->
    if (t1=BoolType && t2=t3)
    then return t2
    else error "ITE: condition not boolean or types of then and else do not match"
  | Let(id,e,body) ->
    type_of_expr e >>= fun t ->
    extend_tenv id t >>+
    type_of_expr body
  | Proc(var,t1,e) ->
    extend_tenv var t1 >>+
    type_of_expr e >>= fun t2 ->
    return @@ FuncType(t1,t2)
  | App(e1,e2) ->
    type_of_expr e1 >>=
    pair_of_funcType "app: " >>= fun (t1,t2) ->
    type_of_expr e2 >>= fun t3 ->
    if t1=t3
    then return t2
    else error "app: type of argument incorrect"
  | Letrec(id,param,tParam,tRes,body,target) ->
    extend_tenv id (FuncType(tParam,tRes)) >>+
    (extend_tenv param tParam >>+
     type_of_expr body >>= fun t ->
     if t=tRes 
     then type_of_expr target
     else error
         "LetRec: Type of recursive function does not match
declaration")
    
  (* pairs *)
  | Pair(e1,e2) ->
  	type_of_expr e1 >>= fun t1 ->
  	type_of_expr e2 >>= fun t2 ->
  	return @@ PairType(t1,t2) 
  | Unpair(id1,id2,e1,e2) ->
    type_of_expr e1 >>=
    pair_of_pairType "unpair: " >>= fun (t1,t2) ->
    extend_tenv id1 t1 >>+
    extend_tenv id2 t2 >>+
    type_of_expr e2

  (* references *)
  | Unit -> return UnitType
  | BeginEnd(es) ->
    List.fold_left (fun r e -> r >>= fun _ -> type_of_expr e) (return UnitType) es 
  | NewRef(e) ->
  	type_of_expr e >>= fun t1 ->
  	return @@ RefType t1
  | DeRef(e) ->
  	type_of_expr e >>=
    arg_of_refType "DeRef: " >>= fun e1 ->
    return e1
  | SetRef(e1,e2) ->
  	type_of_expr e1 >>=
  	arg_of_refType "SetRef: " >>= fun t1 ->
  	type_of_expr e2 >>= fun t2 ->
  	if t1=t2
  	then return UnitType
  	else error "Error: first argument and second argument do not have the same type"
 
  (* lists *)
  | EmptyList(t) ->
  	return @@ ListType t
  | Cons(h, t) ->
(*   	type_of_expr t >>= fun t1 ->
  	arg_of_listType "Cons: " t1 >>= fun t2 ->
  	type_of_expr h >>= fun t3 ->
  	if t3 = t2 (* both hd and tail match inttype and inttype *)
  	then return @@ ListType t2
  	else (match t3 with they don't match but the head might be an empty list 
  			| ListType a -> if a = t2
  							then return @@ ListType t3
  							else error "cons: type of head and tail do not match"
  			| _ -> error "cons: type of head and tail do not match") *)

  	type_of_expr t >>= fun t1 ->
  	arg_of_listType "Cons: " t1 >>= fun t2 ->
  	type_of_expr h >>= fun t3 ->
  	if t3 = t2
  	then return @@ ListType t2
    else error "cons: Type of head and tail do not match"
  | Null(e) ->
    type_of_expr e >>=
    arg_of_listType "Null: " >>= fun _ ->
    return BoolType
  | Hd(e) ->
    type_of_expr e >>=
    arg_of_listType "Hd: " >>= fun t1 ->
    return t1  
  | Tl(e) ->
    type_of_expr e >>=
    arg_of_listType "Tl: " >>= fun t1 ->
    return @@ ListType t1

  (* trees *)
  | EmptyTree(t) ->
    return @@ TreeType t
  | Node(de, le, re) ->
	type_of_expr de >>= fun e1 ->
	type_of_expr le >>=
	arg_of_treeType "Node: " >>= fun e2 ->
	type_of_expr re >>=
	arg_of_treeType "Node: " >>= fun e3 ->
	if e2 = e3
	then 	if e1 = e2 
			then return @@ TreeType e1
			else error "Node: Subtree types do not match data type"
	else error "Node: Subtree types do not match"
  | NullT(t) ->
    type_of_expr t >>= 
    arg_of_treeType "NullT: " >>= fun _ ->
    return @@ BoolType
  | GetData(t) ->
    type_of_expr t >>= 
    arg_of_treeType "GetData: " >>= fun e ->
    return e
  | GetLST(t) ->
    type_of_expr t >>=
    arg_of_treeType "GetLST: " >>= fun e ->
    return @@ TreeType e
  | GetRST(t) ->
  	type_of_expr t >>= 
  	arg_of_treeType "GetRST: " >>= fun e ->
  	return @@ TreeType e

  | Debug(_e) ->
    string_of_tenv >>= fun str ->
    print_endline str;
    error "Debug: reached breakpoint"
  | _ -> error "type_of_expr: implement"    

let type_of_prog (AProg e) =  type_of_expr e



let parse s =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.prog Lexer.read lexbuf in
  ast


(* Type-check an expression *)
let chk (e:string) : texpr result =
  let c = e |> parse |> type_of_prog
  in run_teac c

let chkpp (e:string) : string result =
  let c = e |> parse |> type_of_prog
  in run_teac (c >>= fun t -> return @@ Ast.string_of_texpr t)


let ex1 = "
let x = 7  
in let y = 2 
   in let y = let x = x-1 
              in x-y 
      in (x-8)- y"

let ex2 = "
   let g = 
      let counter = 0 
      in proc(d:int) {
         begin 
           set counter = counter+1; 
           counter
         end
         }
   in (g 11)-(g 22)"

let ex3 = "
  let g = 
     let counter = newref(0) 
     in proc (d:int) {
         begin
          setref(counter, deref(counter)+1);
          deref(counter)
         end
       }
  in (g 11) - (g 22)"

let ex4 = "
   let g = 
      let counter = 0 
      in proc(d:int) {
         begin 
           set counter = counter+1; 
           counter
         end
         }
   in (proc (x:int) { x + x }
(g 0))"
(* 3 in call-by-name *)
(* 2 in call-by-need *)

let ex5 = "
let a = 3
in let p = proc(x) { set x = 4 }
in begin 
         (p a); 
         a 
       end"

let ex6 = "let p = proc(x:int) { 5-x } in (p 3)"
(* 2 *)

let ex7 = "
let a = 3
in let f = proc(x:int) { proc(y:int) { set x = x-y }}
in begin
((f a) 2);
a
end"
(* 1 *)

let ex8 = "
let swap = proc (x:int) { proc (y:int) {
                      let temp = x
                      in begin 
                          set x = y;
                          set y = temp
                         end
                      } 
            }
         in let a = 33
         in let b = 44
         in begin
             ((swap a) b);
             a-b
            end"
(* 11 *)

let ex9 = "
letrec fact (x) = if zero?(x) then 1 else x*(fact (x-1)) 
in (fact 7)"
(* 5040 *)

let ex10 = "
letrec infiniteLoop (x) = (infiniteLoop (x+1)) 
in let f = proc (z) { 11 }
in (f (infiniteLoop 0))"

