with Interfaces.C;
with Interfaces.C.Strings;
with Interfaces;
with System;

package PJ_Types is 
   package C renames Interfaces.C;

   type Int_32_T is new C.Int;              --  typedef int             pj_int32_t;
   type Uint_32_T is new C.Unsigned;        --  typedef unsigned int    pj_uint32_t;
   type Int_16_T is new C.Short;            --  typedef short           pj_int16_t
   type Uint_16_T is new C.Unsigned_Short ; --  typedef unsigned short  pj_uint16_t;
   type Int_8_T is new C.Char;              --  typedef signed char     pj_int8_t;
   type Uint_8_T is new C.Unsigned_Char;    --  typedef unsigned char   pj_uint8_t;
   type Size_T is new C.Unsigned_Long;      --  typedef size_t          pj_size_t;
   type Ssize_T is new C.Long;              --  typedef long            pj_ssize_t;
   type Status_Code_T is new C.Int;         --  typedef int             pj_status_t;
   type Boolean_T is new C.Int;             --  typedef int             pj_bool_t;
   
   Success : constant Integer := 0; -- PJ_SUCCESS
   
   type String_T is record  -- pj_str_t
      Ptr  : C.Strings.Chars_Ptr := C.Strings.Null_Ptr;
      Size : Size_T := -1;
   end record;
   pragma Convention(C,String_T);
   for String_T'Size use 16*8;

end PJ_Types;
