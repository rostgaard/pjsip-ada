with System;
with Interfaces.C;
with Interfaces.C.Strings;

with Types;
with SIP_Timer;
with SIP_Auth;
with Sip_Event;
with SIP_Types;
with SIP_Transport;
with SIP_Transaction;

-- Internal data consistency checks
with Assert_Sizes; use Assert_Sizes;

package PJSUA is 
   package C renames Interfaces.C;
   use type C.Int; -- Enables use of negation operator on C.Int
   
   package PJ_Types renames Types;
   
   subtype Call_Id_Type         is C.Int;
   subtype Account_Id_Type      is C.Int;
   subtype Buddy_Id_Type        is C.Int;
   subtype Player_Id_Type       is C.Int;
   subtype Recorder_I_Type      is C.Int;
   subtype Confing_Port_Id_Type is C.Int; 
   subtype Transport_ID_Type    is C.Int;
   
   type State_Type is 
     (Uninitialized,
      Created,
      Initializes,
      Starting,
      Running,
      Closingg);
   pragma Convention (C, State_Type);
   
   -- TODO: Autogenerate these
   PJSUA_ACC_MAX_PROXIES : constant C.Int := 8;
   PJSUA_DEFAULT_SRTP_SECURE_SIGNALING : constant C.Int := 1;
   PJSIP_TRANSPORT_UDP : constant Integer := 1;
   PJSUA_REG_RETRY_INTERVAL : constant C.Unsigned := 300;
   
   type Config_Proxy_Servers_Array is array (1 .. 4) of PJ_Types.String_T;
   pragma Convention (C,Config_Proxy_Servers_Array);
   
   -- TODO: Make assertions of these
   type Proxy_Servers_Array is array (1 .. 4) of PJ_Types.String_T;
   pragma Convention (C,Proxy_Servers_Array);
   for Proxy_Servers_Array'Size use 8*128;
   pragma Assert(Proxy_Servers_Array'Size = 8*128);

   
   type Name_Servers_Array is array (1 .. 4) of PJ_Types.String_T;
   pragma Convention (C,Name_Servers_Array);
   for Name_Servers_Array'Size use 512;
   
   type Stun_Servers_Array is array (1 .. 8) of PJ_Types.String_T; 
   pragma Convention (C,STUN_Servers_Array);
   
   type Credential_Info_Array is array (1.. PJSUA_ACC_MAX_PROXIES) 
     of SIP_Auth.Credential_Info_Type;
   pragma Convention (C,Credential_Info_Array);
   for Credential_Info_Array'Size use 1024*8;
   
   
   
   type Pjsip_Header_Dummy is null record;
   for Pjsip_Header_Dummy'Size use 64*8;
   
   type Pjsua_Transport_Config_Dummy is null record;
   for Pjsua_Transport_Config_Dummy'Size use 184*8;
   
   type Log_Callback_Type is access procedure (Level  : C.Int; 
					       Data   : C.Strings.Chars_Ptr;
					       Length : C.Int);
   pragma Convention (C,Log_Callback_Type);
   
   
   type Logging_Config_Type is record 
      Logging_Enabled : aliased PJ_Types.Boolean_T;
      Level           : aliased C.Unsigned := 5;
      Console_Level   : aliased C.Unsigned := 4;
      Decorator       : aliased C.Unsigned := 0;
      Filename        : aliased PJ_Types.String_T; -- Optional
      File_Flags      : aliased C.Unsigned;
      Callback        : Log_Callback_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, Logging_Config_Type);  -- pjsua.h:391
   pragma Assert (Logging_Config_Type'Size = Logging_Config_Type_Size*Byte_size);
   
   
   type Call_Info_Type_Dummy is null record;
   for Call_Info_Type_Dummy'Size use Call_Info_Type_Size;
   
   type Call_Info_Type is new Call_Info_Type_Dummy;
  
  type Event_Callback_Type is record
      On_Call_State : access procedure 
     	(Call_Id : Call_Id_Type; Event : access SIP_Event.Event_Type);  -- pjsua.h:624
      On_Incoming_Call : access procedure
	(Account_ID : PJSUA.Account_ID_Type;
	 Call_ID    : PJSUA.Call_Id_Type;
	 RX_Data    : SIP_Transport.RX_Data_Type);
      On_Call_Tsx_State : access procedure
	(Call_Id     : Call_Id_Type;
	 Transaction : access SIP_Transaction.Transaction_Type;
	 Event       : access SIP_Event.Event_Type);
   end record;
   --     on_call_media_state : access procedure (arg1 : pjsua_call_id);  -- pjsua.h:661
   --     on_call_sdp_created : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access pjmedia_sdp_h.pjmedia_sdp_session;
   --           arg3 : access pj_types_h.pj_pool_t;
   --           arg4 : access constant pjmedia_sdp_h.pjmedia_sdp_session);  -- pjsua.h:677
   --     on_stream_created : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : System.Address;
   --           arg3 : unsigned;
   --           arg4 : System.Address);  -- pjsua.h:697
   --     on_stream_destroyed : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : System.Address;
   --           arg3 : unsigned);  -- pjsua.h:710
   --     on_dtmf_digit : access procedure (arg1 : pjsua_call_id; arg2 : int);  -- pjsua.h:720
   --     on_call_transfer_request : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pj_types_h.pj_str_t;
   --           arg3 : access pjsip_sip_msg_h.pjsip_status_code);  -- pjsua.h:736
   --     on_call_transfer_request2 : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pj_types_h.pj_str_t;
   --           arg3 : access pjsip_sip_msg_h.pjsip_status_code;
   --           arg4 : access pjsua_call_setting);  -- pjsua.h:755
   --     on_call_transfer_status : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : int;
   --           arg3 : access constant pj_types_h.pj_str_t;
   --           arg4 : pj_types_h.pj_bool_t;
   --           arg5 : access pj_types_h.pj_bool_t);  -- pjsua.h:777
   --     on_call_replace_request : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access pjsip_sip_types_h.pjsip_rx_data;
   --           arg3 : access int;
   --           arg4 : access pj_types_h.pj_str_t);  -- pjsua.h:795
   --     on_call_replace_request2 : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access pjsip_sip_types_h.pjsip_rx_data;
   --           arg3 : access int;
   --           arg4 : access pj_types_h.pj_str_t;
   --           arg5 : access pjsua_call_setting);  -- pjsua.h:812
   --     on_call_replaced : access procedure (arg1 : pjsua_call_id; arg2 : pjsua_call_id);  -- pjsua.h:831
   --     on_call_rx_offer : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pjmedia_sdp_h.pjmedia_sdp_session;
   --           arg3 : System.Address;
   --           arg4 : access pjsip_sip_msg_h.pjsip_status_code;
   --           arg5 : access pjsua_call_setting);  -- pjsua.h:853
   --     on_reg_started : access procedure (arg1 : pjsua_acc_id; arg2 : pj_types_h.pj_bool_t);  -- pjsua.h:869
   --     on_reg_state : access procedure (arg1 : pjsua_acc_id);  -- pjsua.h:878
   --     on_reg_state2 : access procedure (arg1 : pjsua_acc_id; arg2 : access pjsua_reg_info);  -- pjsua.h:888
   --     on_incoming_subscribe : access procedure
   --          (arg1 : pjsua_acc_id;
   --           arg2 : System.Address;
   --           arg3 : pjsua_buddy_id;
   --           arg4 : access constant pj_types_h.pj_str_t;
   --           arg5 : access pjsip_sip_types_h.pjsip_rx_data;
   --           arg6 : access pjsip_sip_msg_h.pjsip_status_code;
   --           arg7 : access pj_types_h.pj_str_t;
   --           arg8 : System.Address);  -- pjsua.h:937
   --     on_srv_subscribe_state : access procedure
   --          (arg1 : pjsua_acc_id;
   --           arg2 : System.Address;
   --           arg3 : access constant pj_types_h.pj_str_t;
   --           arg4 : pjsip_simple_evsub_h.pjsip_evsub_state;
   --           arg5 : access pjsip_sip_types_h.pjsip_event);  -- pjsua.h:957
   --     on_buddy_state : access procedure (arg1 : pjsua_buddy_id);  -- pjsua.h:969
   --     on_buddy_evsub_state : access procedure
   --          (arg1 : pjsua_buddy_id;
   --           arg2 : System.Address;
   --           arg3 : access pjsip_sip_types_h.pjsip_event);  -- pjsua.h:982
   --     on_pager : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pj_types_h.pj_str_t;
   --           arg3 : access constant pj_types_h.pj_str_t;
   --           arg4 : access constant pj_types_h.pj_str_t;
   --           arg5 : access constant pj_types_h.pj_str_t;
   --           arg6 : access constant pj_types_h.pj_str_t);  -- pjsua.h:1003
   --     on_pager2 : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pj_types_h.pj_str_t;
   --           arg3 : access constant pj_types_h.pj_str_t;
   --           arg4 : access constant pj_types_h.pj_str_t;
   --           arg5 : access constant pj_types_h.pj_str_t;
   --           arg6 : access constant pj_types_h.pj_str_t;
   --           arg7 : access pjsip_sip_types_h.pjsip_rx_data;
   --           arg8 : pjsua_acc_id);  -- pjsua.h:1022
   --     on_pager_status : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pj_types_h.pj_str_t;
   --           arg3 : access constant pj_types_h.pj_str_t;
   --           arg4 : System.Address;
   --           arg5 : pjsip_sip_msg_h.pjsip_status_code;
   --           arg6 : access constant pj_types_h.pj_str_t);  -- pjsua.h:1042
   --     on_pager_status2 : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pj_types_h.pj_str_t;
   --           arg3 : access constant pj_types_h.pj_str_t;
   --           arg4 : System.Address;
   --           arg5 : pjsip_sip_msg_h.pjsip_status_code;
   --           arg6 : access constant pj_types_h.pj_str_t;
   --           arg7 : access pjsip_sip_types_h.pjsip_tx_data;
   --           arg8 : access pjsip_sip_types_h.pjsip_rx_data;
   --           arg9 : pjsua_acc_id);  -- pjsua.h:1069
   --     on_typing : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pj_types_h.pj_str_t;
   --           arg3 : access constant pj_types_h.pj_str_t;
   --           arg4 : access constant pj_types_h.pj_str_t;
   --           arg5 : pj_types_h.pj_bool_t);  -- pjsua.h:1091
   --     on_typing2 : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pj_types_h.pj_str_t;
   --           arg3 : access constant pj_types_h.pj_str_t;
   --           arg4 : access constant pj_types_h.pj_str_t;
   --           arg5 : pj_types_h.pj_bool_t;
   --           arg6 : access pjsip_sip_types_h.pjsip_rx_data;
   --           arg7 : pjsua_acc_id);  -- pjsua.h:1109
   --     on_nat_detect : access procedure (arg1 : access constant pjnath_nat_detect_h.pj_stun_nat_detect_result);  -- pjsua.h:1120
   --     on_call_redirected : access function
   --          (arg1 : pjsua_call_id;
   --           arg2 : access constant pjsip_sip_types_h.pjsip_uri;
   --           arg3 : access constant pjsip_sip_types_h.pjsip_event) return pjsip_sip_util_h.pjsip_redirect_op;  -- pjsua.h:1168
   --     on_mwi_info : access procedure (arg1 : pjsua_acc_id; arg2 : access pjsua_mwi_info);  -- pjsua.h:1181
   --     on_transport_state : access procedure
   --          (arg1 : access pjsip_sip_types_h.pjsip_transport;
   --           arg2 : pjsip_sip_transport_h.pjsip_transport_state;
   --           arg3 : access constant pjsip_sip_transport_h.pjsip_transport_state_info);  -- pjsua.h:1187
   --     on_call_media_transport_state : access function (arg1 : pjsua_call_id; arg2 : System.Address) return pj_types_h.pj_status_t;  -- pjsua.h:1193
   --     on_ice_transport_error : access procedure
   --          (arg1 : int;
   --           arg2 : pjnath_ice_strans_h.pj_ice_strans_op;
   --           arg3 : pj_types_h.pj_status_t;
   --           arg4 : System.Address);  -- pjsua.h:1205
   --     on_snd_dev_operation : access function (arg1 : int) return pj_types_h.pj_status_t;  -- pjsua.h:1222
   --     on_call_media_event : access procedure
   --          (arg1 : pjsua_call_id;
   --           arg2 : unsigned;
   --           arg3 : access pjmedia_event_h.pjmedia_event);  -- pjsua.h:1236
   --     on_create_media_transport : access function
   --          (arg1 : pjsua_call_id;
   --           arg2 : unsigned;
   --           arg3 : access pjmedia_transport_h.pjmedia_transport;
   --           arg4 : unsigned) return access pjmedia_transport_h.pjmedia_transport;  -- pjsua.h:1261
   --  end record;
   --  pragma Convention (C_Pass_By_Copy, pjsua_callback);  -- pjsua.h:614
   for Event_Callback_Type'Size use 296*8;
   pragma Convention (C,Event_Callback_Type);
   
   
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
   
   function Call_Get_Info (Call_ID          : Call_Id_Type; 
			   Call_Information : access Call_Info_Type) return Types.Status_T;
   pragma Import (C, Call_Get_Info, "pjsua_call_get_info");
   
   -- pjsua_call_answer
   function Call_Answer
     (Call_ID      : Call_Id_Type;
      Code         : C.unsigned;
      Reason       : access constant Types.String_T;
      Message_Data : System.Address) return Types.Status_T;  -- pjsua.h:4044
   pragma Import (C, Call_Answer, "pjsua_call_answer");
 
   procedure Config_Default (Config : access Config_Type);
   pragma Import (C, Config_Default, "pjsua_config_default");
   -- Initializes the configuration object with default values
   
   -- pjsua_transport_config_default 
   procedure Transport_Config_Default (Transport_Config : in Transport_Config_Type);
   pragma Import (C, Transport_Config_Default, "pjsua_transport_config_default");
   -- Initializes the transport configuration object with default values

   -- pjsua_transport_create
   function Transport_Create
     (Transport_Type   : in     SIP_Types.Transport_Type_Enum;
      Transport_Config : access Transport_Config_Type;
      Transport_ID     : access Transport_ID_type) return Types.Status_T;
   pragma Import (C, Transport_Create, "pjsua_transport_create");
   
   -- pjsua_logging_config_default
   procedure Logging_Config_Default (Logging_Config : access Logging_Config_Type);
   pragma Import (C,Logging_Config_Default,"pjsua_logging_config_default");
   -- Initialize the logging record with default values.
   
   -- pjsua_init
   function Init
     (Config             : access Config_Type;
      Logging_Config     : access Logging_Config_Type;
      Pjsua_Media_Config : System.Address) return Types.Status_T;
   pragma Import (C, Init, "pjsua_init");
   
   -- pjsua_create
   function Create return Types.Status_T;
   pragma Import (C, Create, "pjsua_create");
   -- Creates a PJSUA "object" internally in the C part of the application
     
   -- pjsua_start
   function Start return Types.Status_T;
   pragma Import (C, Start, "pjsua_start");
   -- Starts the SIP stack
   
   -- pjsua_destroy
   function Destroy return Types.Status_T;
   pragma Import (C, Destroy, "pjsua_destroy");
   
   -- pj_str (should be moved)
   function To_PJ_String (Str : C.Strings.Chars_Ptr) return Types.String_T;
   pragma Import (C,To_PJ_String,"pj_str");
   
   function Verify_Sip_Url (URL : in C.Strings.Chars_Ptr) return Types.Status_T;
   pragma Import (C,Verify_Sip_Url,"pjsua_verify_sip_url");
   -- Returns PJ_Success on success, otherwise an error code
   
   procedure Account_Config_Default (Account_Config : access Account_Config_Type);
   -- Initializes the Config_Type record with default values;
   pragma Import (C,Account_Config_Default,"pjsua_acc_config_default");
   
   -- pjsua_acc_add
   function Account_Add
     (Account_Config : access Account_Config_Type; 
      Is_Default     : Types.Boolean_T := Types.True;
      Account_Id     : access Account_Id_Type) return types.status_t;
   pragma Import (C, Account_Add, "pjsua_acc_add");

   
end PJSUA;
