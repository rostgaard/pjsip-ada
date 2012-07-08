with Interfaces.C;
with Interfaces.C.Strings;
with PJ_Types;
with SIP_Timer;
with SIP_Auth;
with System;

package PJSUA is 
   package C renames Interfaces.C;
   use type C.Int; -- Enables use of negation operator on C.Int
   
   -- TODO: Autogenerate these
   PJSUA_ACC_MAX_PROXIES : constant C.Int := 8;
   PJSUA_DEFAULT_SRTP_SECURE_SIGNALING : constant C.Int := 1;
   PJSIP_TRANSPORT_UDP : constant Integer := 1;
   PJSUA_REG_RETRY_INTERVAL : constant C.Unsigned := 300;
   
   type Config_Proxy_Servers_Array is array (1 .. 4) of PJ_Types.String_T;
   pragma Convention (C,Config_Proxy_Servers_Array);
   
   -- TODO: align this
   type Proxy_Servers_Array is array (1 .. 4) of PJ_Types.String_T;
   pragma Convention (C,Proxy_Servers_Array);
   for Proxy_Servers_Array'Size use 8*128;
   
   type Name_Servers_Array is array (1 .. 4) of PJ_Types.String_T;
   pragma Convention (C,Name_Servers_Array);
   for Name_Servers_Array'Size use 512;
   
   type Stun_Servers_Array is array (1 .. 8) of PJ_Types.String_T; 
   pragma Convention (C,STUN_Servers_Array);
   
   type Credential_Info_Array is array (1.. PJSUA_ACC_MAX_PROXIES) 
     of SIP_Auth.Credential_Info_Type;
   pragma Convention (C,Credential_Info_Array);
   for Credential_Info_Array'Size use 1024*8;
   
   
   --TODO
   type Event_Callback_Type is null record;
   for Event_Callback_Type'Size use 296*8;
   pragma Convention (C,Event_Callback_Type);
   
   type Pjsip_Header_Dummy is null record;
   for Pjsip_Header_Dummy'Size use 64*8;
   
   type Pjsua_Transport_Config_Dummy is null record;
   for Pjsua_Transport_Config_Dummy'Size use 184*8;
   
   type Log_Callback_Type is access procedure (Level  : C.Int; 
					       Data   : C.Strings.Chars_Ptr;
					       Length : C.Int);
   pragma Convention (C,Log_Callback_Type);
   
   
   type Logging_Config_Type is record 
      Logging_Enabled : PJ_Types.Boolean_T;
      Level           : C.Unsigned := 5;
      Console_Level   : C.Unsigned := 4;
      Decorator       : C.Unsigned := 0;
      Filename        : PJ_Types.String_T; -- Optional
      File_Flags      : C.Unsigned;
      Callback        : Log_Callback_Type;
   end record;
   for Logging_Config_Type'Size use 48*8;
   pragma Convention (C,Logging_Config_Type);
   
   type Config_Type is record
      Max_Calls : C.Unsigned := 4; -- Must be smaller than PJSUA_MAX_CALLS
      Thread_Count : C.Unsigned := 1; -- 0 imples polling
      Nameserver_Count : C.Unsigned := 0;
      Nameserver           : Name_Servers_Array;
      Force_Loose_Route    : PJ_Types.Boolean_T;
      Outbound_Proxy_Count : C.Unsigned;
      Outbound_Proxy : Config_Proxy_Servers_Array;
      STUN_Domain : PJ_Types.String_T; 
      STUN_Host : PJ_Types.String_T;
      STUN_Server_Count : C.Unsigned;
      Stun_Server : Stun_Servers_Array;
      STUN_Ignore_Failure : PJ_Types.Boolean_T;
      Nat_Type_In_SDP : C.Int := 1;
      Require_100rel : C.Int; -- TODO: Change to C ENUM-ish corresponding type
      Use_Timer : C.Int; -- TODO: Change to C ENUM-ish corresponding type
      Enable_Unsolicited_Mwi : PJ_Types.Boolean_T;
      Timer_Setting : SIP_Timer.Setting_Type;
      Cred_Info : Credential_Info_Array;
      Event_Callback : Event_Callback_Type;
      Useragent : PJ_Types.String_T;
      Use_Srtp : C.Int; -- TODO: make into real enum - or use the type
      SRTP_Secure_Signaling : C.Int := PJSUA_DEFAULT_SRTP_SECURE_SIGNALING;
      SRTP_Optional_Dup_Offer : PJ_Types.Boolean_T;
      Hangup_Forked_Call : PJ_Types.Boolean_T;
   end record;
   pragma Convention (C,Config_Type);
   for Config_Type'Size use 1704*8;
   
   type User_Data_Dummy is null record;
   for User_Data_Dummy'Size use 8*8;
   
   type Pjsip_Auth_Clt_Pref_Dummy is null record;
   for Pjsip_Auth_Clt_Pref_Dummy'Size use 24*8;
   
   type Account_Config_Type is record
      User_Data                         : User_Data_Dummy;
      Priority                          : C.Int;
      ID                                : PJ_Types.String_T; -- SIP Identity
      Registration_URI                  : PJ_Types.String_T;
      Registration_Header_List          : PJSIP_Header_Dummy;
      Subscription_Header_List          : PJSIP_Header_Dummy;
      Mwi_Enabled                       : PJ_Types.Boolean_T := 0;
      Publish_Enabled                   : PJ_Types.Boolean_T := 0;
      Publish_Options                   : C.Int;
      Unpublish_Max_Wait_Time           : C.Unsigned := 60;
      Authentication_Preferences        : Pjsip_Auth_Clt_Pref_Dummy; -- TODO
      PIDF_Tuple_ID                     : PJ_Types.String_T; -- Defaults to random string
      Force_Contact                     : PJ_Types.String_T; -- Should be left empty
      Contact_Parameters                : PJ_Types.String_T;
      Contact_URI_Parameters            : PJ_Types.String_T;
      Require_100rel                    : C.Int; -- Should be made type safe
      Use_Timer                         : C.Int; -- TODO: Change to C ENUM-ish 
						 -- corresponding type
      Timer_Setting                     : SIP_Timer.Setting_Type;
      Proxy_Count                       : C.Unsigned;
      Outbound_Proxy                    : Proxy_Servers_Array;
      Registration_Timeout              : C.Unsigned := 300;
      Registration_Delay_Before_Refresh : C.Unsigned := 5; -- In seconds
      Unregistration_Timeout            : C.Unsigned := 10; -- Seconds
      Credential_Count                  : C.Unsigned := 0;
      Credential_Info                   : Credential_Info_Array;
      -- Alignment checked until here. Still a few to go
      Transport_ID                      : C.Int := -1;
      Allow_Contact_Rewrite             : PJ_Types.Boolean_T := 1;
      Contact_Rewrite_Method            : C.Int := 2;
      Use_Rfc5626                       : C.Unsigned := 1;
      Rfc5626_Instance_Id               : PJ_Types.String_T;
      Rfc5626_Reg_Id                    : PJ_Types.String_T;
      Keep_Alive_Interval               : C.Unsigned := 15; -- Seconds
      Keep_Alive_Data                   : PJ_Types.String_T;
      Video_In_Auto_Show                : PJ_Types.Boolean_T := 0;
      vid_out_auto_transmit                : PJ_Types.Boolean_T := 0;
      Vid_Wnd_Flags : C.Unsigned := 0;
      Vid_Cap_Dev : C.Int := 0; --TODO
      Vid_Rend_Dev : C.Int := 0; --TODO
      Vid_Stream_Rc_Cfg : C.Int := 0; -- TODO
      Rtp_Cfg : Pjsua_Transport_Config_Dummy;
      Use_Srtp                : C.Int;
      Srtp_Secure_Signaling   : C.Int := 0;
      Srtp_Optional_Dup_Offer : PJ_Types.Boolean_T;
      Reg_Retry_Interval       : C.Unsigned;
      Reg_First_Retry_Interval : C.Unsigned := 0;
      Drop_Calls_On_Reg_Fail   : PJ_Types.Boolean_T := 0;
      Reg_Use_Proxy            : C.Unsigned;
      Use_Stream_Ka            :       PJ_Types.Boolean_T;
      call_hold_type : C.Int := 0;
      Register_On_Acc_Add : PJ_Types.Boolean_T := 1;
   end record;
   pragma Convention (C,Account_Config_Type);
   for Account_Config_Type'Size use 1800*8;
	
   
   type Transport_Config_Type is record
      Port           : C.Unsigned        := 0; -- Local UDP port
      Public_Address : PJ_Types.String_T;
      Bound_Address  : PJ_Types.String_T;
-- TODO: Rest
--      /**
--       * This specifies TLS settings for TLS transport. It is only be used
--       * when this transport config is being used to create a SIP TLS
--       * transport.
--       */
--      pjsip_tls_setting	tls_setting;

--      /**
--       * QoS traffic type to be set on this transport. When application wants
--       * to apply QoS tagging to the transport, it's preferable to set this
--       * field rather than \a qos_param fields since this is more portable.
--       *
--       * Default is QoS not set.
--       */
--      pj_qos_type		qos_type;

--      /**
--       * Set the low level QoS parameters to the transport. This is a lower
--       * level operation than setting the \a qos_type field and may not be
--       * supported on all platforms.
--       *
--       * Default is QoS not set.
--       */
--      pj_qos_params	qos_params;

      --  } pjsua_transport_config;
   end record;
   pragma Convention (C,Transport_Config_Type);
   for Transport_Config_Type'Size use 184*8;
   
   procedure Config_Default (Config : out Config_Type);
   -- Initializes the configuration object with default values
   
   procedure Transport_Config_Default (Transport_Config : in Transport_Config_Type);
   -- Initializes the transport configuration object with default values
   
   procedure Transport_Create (Transport_Type   : Integer;
			       Transport_Config : in Transport_Config_Type);   
   -- TODO
   
   procedure Logging_Config_Default (Logging_Config : in Logging_Config_Type);
   -- Initialize the logging record with default values.
   
   procedure Init (Config           : Config_Type; 
		  Logging_Config    :  Logging_Config_Type
		    --Pjsua_Media_Config : Pjsua_Media_Config_type --TODO
		 );
   
   function Create return Integer;
   -- Creates a PJSUA "object" internally in the C part of the application
   
   function Start return Integer;
   -- Starts the SIP stack
   
   function To_Pj_String(Item : in String) return PJ_Types.String_T;
   -- Converts a standard String into an internal PJ type string.

   function Verify_Url (URL : in String) return Integer;
   -- Returns PJ_Success on success, otherwise an error code
   -- TODO: Figure out the error codes and return them enumerated instead
   
   procedure Account_Config_Default (Account_Config : out Account_Config_Type);
   -- Initializes the Config_Type record with default values;
   
   -- TODO, make this correspond to the C equivalent
   --status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
   function Account_Add (Account_Config : in Account_Config_Type; 
			 Account_Id     : in C.Int ) return integer;
   
end PJSUA;
