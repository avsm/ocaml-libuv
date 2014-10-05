open Ctypes
open Foreign

type timespec = {
  tv_sec : int64;
  tv_nsec : int64 (* TODO what type should these be? *)
}

type stat = {
  (* Note a lot of these types have standard Posix types. libuv, being
     a cross platform library, does not use these types, and uses uint64_t
     for all of these fields. This struct follows suit.
   *)
  st_dev : int64;
  st_mode : int64;
  st_nlink : int64;
  st_uid : int64;
  st_gid : int64;
  st_rdev : int64;
  st_ino : int64;
  st_size : int64;
  st_blksize : int64;
  st_blocks : int64;
  st_flags : int64;
  st_gen : int64;
  st_atim : timespec;
  st_mtim : timespec;
  st_ctim : timespec;
  st_birthtim : timespec
}

module Loop :
sig
  type t

  type run_mode = RunDefault | RunOnce | RunNoWait

  val default_loop : unit -> t

  val run : t -> run_mode -> int
end

module Request :
sig
  type 'a t
  val cancel : 'a t -> unit
end

type iobuf = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

module FS :
sig
  type fs
  type t = fs Request.t

  val openfile : ?loop:Loop.t -> ?cb:(t -> unit) -> ?perm:int -> string -> int -> t (* TODO unix flags *)
  val close : ?loop:Loop.t -> ?cb:(t -> unit) -> int -> t
  val read : ?loop:Loop.t -> ?cb:(t -> unit) -> ?offset:int -> int -> t
  val write : ?loop:Loop.t -> ?cb:(t -> unit) -> ?offset:int -> int -> iobuf -> t
  val stat : ?loop:Loop.t -> ?cb:(t -> unit) -> string -> t

  (* Accessor functions *)
  val buf : t -> iobuf
  val result : t -> int64
  val path : t -> string
  val statbuf : t -> stat
  (* TODO statbuf -- should we just let everyone access it? Or try to change the 
   signatures for the methods that actually use it? *)

  (* Utilities *)
  val string_of_iobuf : ?len:int -> iobuf -> string
  val iobuf_of_string : string -> iobuf
end

