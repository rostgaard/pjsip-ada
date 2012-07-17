with Ada.Text_IO; use Ada.Text_IO;

with System;
package body PJSUA is
   
   
   
   -- PJ_DECL(void) pjsua_transport_config_default(pjsua_transport_config *cfg)
   procedure Transport_Config_Default (Transport_Config : in Transport_Config_Type) is
      Transport_Config_Ptr : System.Address := Transport_Config'Address;
      
      procedure C_Pjsua_Transport_Config_Default 
	(Transport_Config_Ptr : in System.Address);
      pragma Import 
	(C,C_Pjsua_Transport_Config_Default,"pjsua_transport_config_default");
   begin
      C_Pjsua_Transport_Config_Default (Transport_Config_Ptr);
   end Transport_Config_Default;
   
   --  PJ_DECL(pj_status_t) pjsua_transport_create(pjsip_transport_type_e type,
   --  					    const pjsua_transport_config *cfg,
   --  					    pjsua_transport_id *p_id);
   procedure Transport_Create (Transport_Type   : Integer;
			       Transport_Config : in Transport_Config_Type) is
      Transport_Config_Ptr : System.Address := Transport_Config'Address;
      
      function  C_Pjsua_Transport_Create 
	(Transport_Config_Type : in C.Int;
	 Transport_Config_Ptr  : in System.Address;
	 Transport_ID          : in C.Strings.Chars_Ptr) return C.Int;
      pragma Import 
	(C,C_Pjsua_Transport_Create ,"pjsua_transport_create");
   begin
      if Integer(C_Pjsua_Transport_Create (C.Int(Transport_Type),
				   Transport_Config_Ptr,
				   C.Strings.Null_Ptr)) /= Types.Success then
	 raise PROGRAM_ERROR;
      end if;
   end Transport_Create;
   
   --  pjsua_acc_id acc_id;
    --  pj_status_t status;
   
   function Account_Add (Account_Config : in Account_Config_Type; 
			 Account_Id     : in C.Int ) return Integer is
      Account_Config_Ptr : System.Address := Account_Config'Address;
      Account_Id_Ptr : System.Address := Account_Id'Address;
      function C_Pjsua_Account_Add (Account_Config_Ptr : in System.Address;
				     Some_Value : C.Int;
				     Account_ID_Ptr : in System.Address) return
	C.Int;
      pragma Import (C,C_Pjsua_Account_Add,"pjsua_acc_add");
   begin
      return Integer(C_Pjsua_Account_Add(Account_Config_Ptr,1,Account_ID_Ptr));
   end Account_Add;
   
   procedure Account_Config_Default (Account_Config : out Account_Config_Type) is
      Account_Config_Ptr : System.Address := Account_Config'Address;
      
      procedure C_Pjsua_Account_Config_Default (Account_Config_Ptr : in System.Address);
      pragma Import (C,C_Pjsua_Account_Config_Default,"pjsua_acc_config_default");
   begin
      C_Pjsua_Account_Config_Default(Account_Config_Ptr);
   end Account_Config_Default;

   procedure Config_Default (Config : out Config_Type) is
      Config_Ptr : System.Address := Config'Address;
      
      procedure C_Pjsua_Config_Default (Config_Ptr : in System.Address);
      pragma Import (C,C_Pjsua_Config_Default,"pjsua_config_default");
   begin
      C_Pjsua_Config_Default(Config_Ptr);
   end Config_Default;
   
   procedure Logging_Config_Default (Logging_Config : in Logging_Config_Type) is
      Logging_Config_Ptr : System.Address := Logging_Config'Address;
      
      procedure C_Pjsua_Logging_Config_Default 
	(Logging_Config_Ptr : in System.Address);
      pragma Import (C,C_Pjsua_Logging_Config_Default,"pjsua_logging_config_default");
   begin
      C_Pjsua_Logging_Config_Default(Logging_Config_Ptr);
   end Logging_Config_Default;
   
   function Create return Integer is
      function C_Pjsua_Create return C.Int;
      pragma Import (C,C_Pjsua_Create,"pjsua_create");
   begin
      return Integer(C_Pjsua_Create);
   end Create;
   
   function Start return Integer is
      function C_Pjsua_Start return C.Int;
      pragma Import (C,C_Pjsua_Start,"pjsua_start");
   begin
      return Integer(C_Pjsua_Start);
   end Start;
   
   function To_Pj_String(Item : in String) return Types.String_T is
      function C_PJ_Str (Str : C.Strings.Chars_Ptr) return Types.String_T;
      pragma Import (C,C_PJ_Str,"pj_str");
      Str : Types.String_T;
   begin
      Str := C_PJ_Str(C.Strings.New_String(Item));
      Put_Line("To_PJ_String: Ptr => " & C.Strings.value (Str.Ptr) & 
		 " Size => " & Types.Size_T'Image(Str.Size));
      return Str;
      
   end To_Pj_String;
   
   function Verify_Url (URL : in String) return Integer is
      function C_Pjsua_Verify_Sip_Url (URL : in C.Strings.Chars_Ptr) return C.Int;
      pragma Import (C,C_Pjsua_Verify_Sip_Url,"pjsua_verify_sip_url");
   begin
      return Integer (C_Pjsua_Verify_Sip_Url (C.Strings.New_String(URL) ) );
   end Verify_Url;
   
   
   procedure Init (Config             : Config_Type; 
		  Logging_Config     :  Logging_Config_Type
		    --Pjsua_Media_Config : Pjsua_Media_Config_type --TODO
		 ) is
      Config_Ptr         : System.Address := Config'Address;
      Logging_Config_Ptr : System.Address := Logging_Config'Address;
      
      function C_Pjsua_Init (Config_Ptr          : in System.Address;
			     Logging_Config_Ptr  : in System.Address;
			     Pjsua_Media_Config  : in C.Strings.Chars_Ptr) 
			    return C.Int;
      pragma Import (C,C_Pjsua_Init,"pjsua_init");
   begin
      if Integer ((C_Pjsua_Init
	    (Config_Ptr,Logging_Config_Ptr, C.Strings.Null_Ptr))) /= Types.Success then
	 raise PROGRAM_ERROR;
      end if;
   end Init;
   
      --   pjsua_init(&cfg, &log_cfg, NULL);
   
   
end PJSUA;
