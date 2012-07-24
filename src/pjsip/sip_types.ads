with Interfaces.C;

with Types;
with SIP_Module;
package SIP_Types is
   package C renames Interfaces.C;
   --  arg-macro: procedure PJSIP_RETURN_EXCEPTION ()
   --    pjsip_exception_to_status(PJ_GET_EXCEPTION())
   --  skipped empty struct pjsip_tpmgr
   --  skipped empty struct pjsip_endpoint
   --  skipped empty struct pjsip_resolver_t

   subtype pjsip_user_agent is SIP_Module.Module;
   
   subtype Transport_Type_Enum is C.unsigned;
   PJSIP_TRANSPORT_UNSPECIFIED : constant Transport_Type_Enum := 0;
   PJSIP_TRANSPORT_UDP : constant Transport_Type_Enum := 1;
   PJSIP_TRANSPORT_TCP : constant Transport_Type_Enum := 2;
   PJSIP_TRANSPORT_TLS : constant Transport_Type_Enum := 3;
   PJSIP_TRANSPORT_SCTP : constant Transport_Type_Enum := 4;
   PJSIP_TRANSPORT_LOOP : constant Transport_Type_Enum := 5;
   PJSIP_TRANSPORT_LOOP_DGRAM : constant Transport_Type_Enum := 6;
   PJSIP_TRANSPORT_START_OTHER : constant Transport_Type_Enum := 7;
   PJSIP_TRANSPORT_IPV6 : constant Transport_Type_Enum := 128;
   PJSIP_TRANSPORT_UDP6 : constant Transport_Type_Enum := 129;
   PJSIP_TRANSPORT_TCP6 : constant Transport_Type_Enum := 130;   
   --
   subtype Role_Enum is C.Unsigned;
   PJSIP_ROLE_UAC : constant Role_Enum := 0;
   PJSIP_ROLE_UAS : constant Role_Enum := 1;
   PJSIP_UAC_ROLE : constant Role_Enum := 0;
   PJSIP_UAS_ROLE : constant Role_Enum := 1; 
   
   -- pjsip_exception_to_status
   -- TODO: find arg1 name
   function Exception_To_Status (arg1 : C.int) return Types.Status_T;
   pragma Import (C, Exception_To_Status, "pjsip_exception_to_status");
end SIP_Types;
