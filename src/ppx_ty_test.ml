
Printexc.record_backtrace true

let env =
  lazy begin 
    Compmisc.init_path (); 
    Compmisc.initial_env () 
  end

let tyexp_to_exp env (super:Untypeast.mapper) =
  fun self (texp : Typedtree.expression) ->
    let e = super.expr self texp in
    let e = Ppxlib.Selected_ast.Of_ocaml.copy_expression e in
    let loc = texp.exp_loc in
    let e =
      if Ctype.does_match env texp.exp_type Predef.type_int then begin
        let open Ppxlib in
        [%expr [%e e] + 42]
      end else begin
        e
      end
    in
    Ppxlib.Selected_ast.To_ocaml.copy_expression e

let transform str =
    let str = Ppxlib.Selected_ast.To_ocaml.copy_structure str in
    let env = Lazy.force env in
    let (tstr, _, _, _,_ ) = Typemod.type_structure env str in
    let super = Untypeast.default_mapper in
    let mapper_body =
      {super with expr = tyexp_to_exp env super}
    in
    let str = mapper_body.structure mapper_body tstr in
    Ppxlib.Selected_ast.Of_ocaml.copy_structure str

let () =
  Ppxlib.Driver.register_transformation 
    ~impl:transform
    "ppx_ty_test"
