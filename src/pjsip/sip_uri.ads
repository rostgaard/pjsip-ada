with System;
with Interfaces.C;
with Interfaces.C.Strings;

with Types;
with Pool;


package SIP_URI is
   package C renames Interfaces.C;
   
   type Parameter_Type is record
      Previous : access Parameter_Type;
      Next     : access Parameter_Type;
      Name     : aliased Types.String_T;
      Value    : aliased Types.String_T;
   end record;
   pragma Convention (C_Pass_By_Copy, Parameter_Type);
   

   type Uri_Context_Enum is 
     (PJSIP_URI_IN_REQ_URI,
      PJSIP_URI_IN_FROMTO_HDR,
      PJSIP_URI_IN_CONTACT_HDR,
      PJSIP_URI_IN_ROUTING_HDR,
      PJSIP_URI_IN_OTHER);
   pragma Convention (C, Uri_Context_Enum);
   
   type URI_Vptr_Type is record
      P_Get_Scheme : access function 
	(URI : System.Address) 
	return access constant Types.String_T;
      
      P_Get_Uri : access function 
	(URI : System.Address) 
	return System.Address;  -- void*
      
      P_Print   : access function
           (Context : Uri_Context_Enum;
            URI     : System.Address;
            Buffer  : C.Strings.chars_ptr;
            Size    : Types.Size_T) 
	   return Types.Ssize_T;
      
      P_Compare : access function
           (Context : Uri_Context_Enum;
            URI1    : System.Address;
            URI2    : System.Address) 
	   return Types .Status_T;
      
      P_Clone : access function 
	(Pool : access Pool.Pool_Type;
	 URI  : System.Address) 
	return System.Address;
   end record;
   pragma Convention (C_Pass_By_Copy, URI_Vptr_Type);
   
   type URI_Type is record
      vptr : access URI_Vptr_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, URI_Type);

   
end SIP_URI;
