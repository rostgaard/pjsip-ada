with System;
with Interfaces.C;

with Types;
with SIP_Event;
with SIP_Transport;
--with SIP_Transaction;

package SIP_Module is
   package C renames Interfaces.C;
   
   -- pjsip_module
   type Module is record
      Previous : access module;
      Next     : access module;
      Name     : aliased Types.String_T;
      ID       : aliased C.int;
      Priority : aliased C.int;
      
      Load     : access function 
	(Endpoint : System.Address) return Types.Status_T;
      
      Start         : access function return Types.Status_T;
      
      Stop          : access function return Types.Status_T;
      
      Unload        : access function return Types.Status_T;
      
      On_Rx_Request : access function 
	(Message : access SIP_Transport.RX_Data_Type) 
	return Types.Boolean_T;
      
      On_Rx_Response : access function 
	(Message : access SIP_Transport.RX_Data_Type)
	return Types.Boolean_T;
      
      On_Tx_Request : access function 
	(Message : access SIP_Transport.TX_Data_Type)
	return Types.Boolean_T;
      
      On_Tx_Response : access function 
	(Message : access SIP_Transport.TX_Data_Type)
	return Types.Boolean_T;
      
      On_Transaction_State : access procedure 
	(-- TODO: Fix this dependency
	 --Transaction : access SIP_Transaction.Transaction_type; 
	 Transaction : System.Address;
	 Event       : access SIP_Event.Event_Type);
   end record;
   pragma Convention (C_Pass_By_Copy, Module);

   --  subtype pjsip_module_priority is unsigned;
   --  PJSIP_MOD_PRIORITY_TRANSPORT_LAYER : constant pjsip_module_priority := 8;
   --  PJSIP_MOD_PRIORITY_TSX_LAYER : constant pjsip_module_priority := 16;
   --  PJSIP_MOD_PRIORITY_UA_PROXY_LAYER : constant pjsip_module_priority := 32;
   --  PJSIP_MOD_PRIORITY_DIALOG_USAGE : constant pjsip_module_priority := 48;
   --  PJSIP_MOD_PRIORITY_APPLICATION : constant pjsip_module_priority := 64;  -- /usr/local/include/pjsip/sip_module.h:186
   
   -- pjsip_module_priority
   type Priority is
     (PJSIP_MOD_PRIORITY_TRANSPORT_LAYER,
      PJSIP_MOD_PRIORITY_TSX_LAYER,
      PJSIP_MOD_PRIORITY_UA_PROXY_LAYER,
      PJSIP_MOD_PRIORITY_DIALOG_USAGE,
      PJSIP_MOD_PRIORITY_APPLICATION);
   
   for Priority use
     (PJSIP_MOD_PRIORITY_TRANSPORT_LAYER =>  8,
      PJSIP_MOD_PRIORITY_TSX_LAYER       => 16,
      PJSIP_MOD_PRIORITY_UA_PROXY_LAYER  => 32,
      PJSIP_MOD_PRIORITY_DIALOG_USAGE    => 48,
      PJSIP_MOD_PRIORITY_APPLICATION     => 64);
   
end SIP_Module;
