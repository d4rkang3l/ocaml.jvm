open Core.Std
open Accflag
open Float32

module rec InnClass : sig
  type t =
    { name : string;
      access_flags : int;
      super_class  : t option;
      interfaces   : t list;
      fields : (MemberID.t, InnField.t) Hashtbl.t;
      methods : (MemberID.t, InnMethod.t) Hashtbl.t;
      conspool : InnPoolrt.t;
      attributes : Attribute.AttrClass.t list;
      loader  : InnLoader.t;
      static_fields : (MemberID.t, InnValue.t) Hashtbl.t;
    }
end
and InnField: sig
  type t =
    { jclass        : InnClass.t;
      mid         : MemberID.t;
      access_flags  : int;
      attrs         : Attribute.AttrField.t list;
    }
  val default_value : MemberID.t -> InnValue.t
end
and InnMethod : sig
  type t =
    { jclass        : InnClass.t;
      mid         : MemberID.t;
      access_flags  : int;
      attrs         : Attribute.AttrMethod.t list;
    }
end
and InnLoader : sig
  type t =
    { name : string;
      classes : (string, InnClass.t) Hashtbl.t;
    }
end
and InnPoolrt : sig
  type entry =
    | Utf8 of string
    | Integer of int32
    | Float of float32
    | Long of int64
    | Double of float64
    | Class of InnClass.t
    | String of string
    | Fieldref of InnField.t
    | Methodref of InnMethod.t
    | InterfaceMethodref of InnMethod.t
    | NameAndType of int * int
    | MethodHandle of string
    | MethodType of string
    | InvokeDynamic of string
    | Byte8Placeholder

  type t = entry array
end
and InnValue : sig
  type t =
    | Byte of int
    | Short of int
    | Char of int
    | Int of int32
    | Float of float32
    | Long of int64
    | Double of float64
    | Boolean of bool
    | Reference of InnObject.t
    | ReturnAddress
end
and InnObject : sig
  type obj =
    { jclass : InnClass.t;
      fields : (MemberID.t, InnValue.t) Hashtbl.t;
    }

  type arr =
    { jclass : InnClass.t option;
      values : (InnValue.t) Array.t;
    }

  type t =
    | Obj of obj
    | Arr of arr
    | Null
end

val bootstrap_loader : InnLoader.t

(* load a none array class from file System *)
val load_from_bytecode : InnLoader.t -> string -> InnClass.t
val load_class : InnLoader.t -> string -> InnClass.t
