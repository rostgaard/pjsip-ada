with Interfaces.C;
with Interfaces.C.Strings;
with Interfaces;
with System;

with Assert_Sizes; use Assert_Sizes;

package Types is 
   package C renames Interfaces.C;
   
   PJ_MAX_OBJ_NAME : constant C.Size_T := 32;
   
   subtype Object_Name_Type is C.Char_Array (1 .. Types.PJ_MAX_OBJ_NAME);
   
   
   type Int_32_T is new C.Int;              --  typedef int             pj_int32_t;
   type Uint_32_T is new C.Unsigned;        --  typedef unsigned int    pj_uint32_t;
   type Int_16_T is new C.Short;            --  typedef short           pj_int16_t
   type Uint_16_T is new C.Unsigned_Short ; --  typedef unsigned short  pj_uint16_t;
   type Int_8_T is new C.Char;              --  typedef signed char     pj_int8_t;
   type Uint_8_T is new C.Unsigned_Char;    --  typedef unsigned char   pj_uint8_t;
   type Size_T is new C.Unsigned_Long;      --  typedef size_t          pj_size_t;
   type Ssize_T is new C.Long;              --  typedef long            pj_ssize_t;
   type Status_T is new C.Int;         --  typedef int             pj_status_t;
   type Boolean_T is new C.Int;             --  typedef int             pj_bool_t;
   
   type Atomic_T is null record;
   
   Success : constant Integer := 0; -- PJ_SUCCESS
   
   True  : constant Integer := 1; -- PJ_TRUE;
   False : constant Integer := 1; -- PJ_FALSE;
   
   type Transport_Type_Enum is 
     (Unspecified,
      UDP,
      TCP,
      TLS,
      SCTP,
      Loop_Transport,
      Loop_Datagram,
      Start_Another,
      IPv6,
      UDPv6,
      TCPv6);
   for Transport_Type_Enum use 
     (Unspecified    => 0,
      UDP            => 1,
      TCP            => 2,
      TLS            => 3,
      SCTP           => 4,
      Loop_Transport => 5,
      Loop_Datagram  => 6,
      Start_Another  => 7,
      IPv6           => 128,
      UDPv6          => 129,
      TCPv6          => 130);
   for Transport_Type_Enum'Size use C.Unsigned'Size;
   pragma Convention (C,Transport_Type_Enum);
   
   type String_T is record  -- pj_str_t
      Ptr  : C.Strings.Chars_Ptr := C.Strings.Null_Ptr;
      Size : aliased Size_T := -1;
   end record;
   pragma Convention (C_Pass_By_Copy, String_T);
   pragma Assert (String_T'Size = String_T_Size*Byte_Size);

   type Time_Value_Type is record
      Seconds     : aliased C.Long;
      Miliseconds : aliased C.Long;
   end record;
   pragma Convention (C_Pass_By_Copy, Time_Value_Type);
   pragma Assert (Time_Value_Type'Size = Time_Value_Type_Size*Byte_Size);
   
   -- pj_parsed_time
   type Parsed_Time_Type is record
      Weekday     : aliased C.Int; -- 0 for Sunday
      Day_Of_Year : aliased C.Int;
      Month       : aliased C.Int;
      Year        : aliased C.Int;
      Second      : aliased C.Int;
      Minute      : aliased C.Int;
      Hour        : aliased C.Int;
      Milisecond  : aliased C.Int;
   end record;
   pragma Convention (C_Pass_By_Copy, Parsed_Time_Type);
   
   type Buffer_Type is record
      Start      : C.Strings.Chars_Ptr;
      Current    : C.Strings.Chars_Ptr;
      Buffer_End : C.Strings.Chars_Ptr;
   end record;
   pragma Convention (C_Pass_By_Copy, Buffer_Type);

   type Host_Port_Type is record
      Host : aliased String_T;
      Port : aliased C.int;
   end record;
   pragma Convention (C_Pass_By_Copy, Host_Port_Type);

   type Host_Info_Type is record
      Flag      : aliased C.Unsigned; 
      Host_Type : aliased Transport_Type_Enum;
      Address   : aliased Host_Port_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, Host_Info_Type);
   pragma Assert (Host_Info_Type'Size = Host_Info_Type_Size*Byte_Size);
   
   
end Types;
