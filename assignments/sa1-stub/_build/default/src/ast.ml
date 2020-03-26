(* Name: Eric Altenburg and Hamzah Nizami
Pledge: I pledge my honor that I have abided by the Stevens Honor System. *)

(* The type of the abstract syntax tree (AST). *)


type expr =
  | Var of string
  | Int of int
  | Add of expr*expr
  | Sub of expr*expr
  | Mul of expr*expr
  | Div of expr*expr
  | Let of string*expr*expr
  | IsZero of expr
  | ITE of expr*expr*expr
  | Proc of string*expr
  | App of expr*expr
  | Letrec of decs*expr
  | Set of string*expr
  | BeginEnd of expr list
  | NewRef of expr
  | DeRef of expr
  | SetRef of expr*expr
  | Pair of expr*expr
  | Fst of expr
  | Snd of expr
  | Tuple of expr list
  | Record of (string*expr) list
  | Proj of expr*string
  | Cons of expr*expr
  | Hd of expr
  | Tl of expr
  | Empty of expr
  | EmptyList
  | Unit
  | Debug of expr
and
  decs = (string*string*expr) list

type prog = AProg of expr

let rec string_of_expr e =
  match e with
  | Var s -> "Var "^s
  | Int n -> "Int "^string_of_int n
  | Add(e1,e2) -> "Add(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Sub(e1,e2) -> "Sub(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Mul(e1,e2) -> "Mul(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Div(e1,e2) -> "Div(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | NewRef(e) -> "NewRef(" ^ (string_of_expr e) ^ ")"
  | DeRef(e) -> "DeRef(" ^ (string_of_expr e) ^ ")"
  | SetRef(e1,e2) -> "SetRef(" ^ (string_of_expr e1) ^ "," ^ string_of_expr e2 ^ ")"
  | Let(x,def,body) -> "Let("^x^","^string_of_expr def ^","^ string_of_expr body ^")"
  | Proc(x,body) -> "Proc("^x^"," ^ string_of_expr body ^")" 
  | App(e1,e2) -> "App("^string_of_expr e1 ^"," ^ string_of_expr e2^")"
  | IsZero(e) -> "Zero?("^string_of_expr e ^")"
  | ITE(e1,e2,e3) -> "IfThenElse("^string_of_expr e1^"," ^ string_of_expr e2^"," ^ string_of_expr e3  ^")"
  | Letrec(decs, body) -> "Letrec(" ^ string_of_decs decs ^ " | " ^ string_of_expr body ^ ")"
  | Set(x,rhs) -> "Set("^x^","^string_of_expr rhs^")"
  | BeginEnd(es) -> "BeginEnd(" ^ List.fold_left (fun x y -> x^","^y)
                      "" (List.map string_of_expr es) ^")"
  | Pair(e1,e2) -> "Pair("^string_of_expr e1^","^string_of_expr e2^")"
  | Fst(e) -> "Fst("^string_of_expr e^")"
  | Snd(e) -> "Snd("^string_of_expr e^")"
  | Debug(e) -> "Debug("^string_of_expr e^")"
  | _ -> failwith "Not implemented!"
and
  string_of_decs decs =
    match decs with
    | [] -> ""
    | [(x, y, e1)] -> "Dec(" ^ x ^ ", " ^ y ^ ", " ^ string_of_expr e1 ^ ")"
    | (x, y, e1)::rest ->
      "Dec(" ^ x ^ ", " ^ y ^ ", " ^ string_of_expr e1 ^ "), " ^ string_of_decs rest

let string_of_prog (AProg e)  = string_of_expr e
