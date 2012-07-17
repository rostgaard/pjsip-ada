with Interfaces.C;

with Types;


package Sock is
   package C renames Interfaces.C;
   
   type Address_Type is (Generic_Address, IPv4, IPv6);
   
   type Address_Header_Type is record
      Family : aliased Types.Uint_16_T;
   end record;
   pragma Convention (C_Pass_By_Copy, Address_Header_Type);
   

   type In_Address is record
      S_Addr : aliased Types.Uint_32_T;
   end record;
   pragma Convention (C_Pass_By_Copy, In_Address);
   
   
   subtype anon937_anon1797_array is Interfaces.C.char_array (1 .. 8);
   type Socket_Address_In_Type is record
      Sin_Family : aliased Types.UInt_16_T;
      Sin_Port   : aliased Types.Uint_16_T;
      Sin_Addr   : aliased In_Address;
      Sin_Zero   : aliased anon937_anon1797_array;
   end record;
   pragma Convention (C_Pass_By_Copy, Socket_Address_In_Type);

   type anon1798_anon1800_array is array (0 .. 15) of aliased Types.Uint_8_T;
   type anon1798_anon1803_array is array (0 .. 3) of aliased Types.Uint_32_T;
   type Socket_In6_Address_Type (discr : C.unsigned := 0) is record
      case discr is
         when 0 =>
            s6_addr : aliased anon1798_anon1800_array;
         when others =>
            u6_addr32 : aliased anon1798_anon1803_array;
      end case;
   end record;
   pragma Convention (C_Pass_By_Copy, Socket_In6_Address_Type);
   pragma Unchecked_Union (Socket_In6_Address_Type);

   type Socket_Address_In6 is record
      sin6_family : aliased Types.Uint_16_T;
      sin6_port : aliased Types.Uint_16_T;
      sin6_flowinfo : aliased Types.Uint_32_T;
      sin6_addr : Socket_In6_Address_Type;
      sin6_scope_id : aliased Types.Uint_32_T;
   end record;
   pragma Convention (C_Pass_By_Copy, Socket_Address_In6);
   
   
   type Socket_Address_Type (Socket : Address_Type := Generic_Address) is record
      case Socket is
         when Generic_Address =>
            Address : aliased Address_Header_Type;
         when IPv4 =>
            IPv4 : aliased Socket_Address_In_Type;
         when IPv6 =>
            IPv6 : aliased Socket_Address_In6;
      end case;
   end record;
   pragma Convention (C_Pass_By_Copy, Socket_Address_Type);
   pragma Unchecked_Union (Socket_Address_Type);
   
end Sock;
