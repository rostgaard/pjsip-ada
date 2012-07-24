with System;
with Interfaces.C;
with Interfaces.C.Strings;  
  
with Types;
with Pool;
with Timer;
with Sock;
with IOqueue;
--with SIP_Message;
--with SIP_Module;

package SIP_Transport is
   package C renames Interfaces.C;
   
   type Rx_Data_Type;
   type Rx_Data_Op_Key_Type is record
      Op_Key : aliased IOqueue.IOqueue_Op_Key_Type;
      Rdata   : access Rx_Data_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, Rx_Data_Op_Key_Type);
   
   
   type Transaction_Type is null record;
   
   --  -- pjsip_transaction
   --  subtype anon984_anon2255_array is Interfaces.C.char_array (1 .. 32);
   --  type anon984_anon2093_array is array (1 .. 32) of System.Address;
   --  type Transaction is record
   --     Pool      : access Pool.Pool_Type;
   --     Tsx_User  : access pjsip_sip_types_h.pjsip_module;  -- /usr/local/include/pjsip/sip_transaction.h:86
   --     endpt : System.Address;  -- /usr/local/include/pjsip/sip_transaction.h:87
   --     mutex : System.Address;  -- /usr/local/include/pjsip/sip_transaction.h:88
   --     mutex_b : System.Address;  -- /usr/local/include/pjsip/sip_transaction.h:89
   --     obj_name : aliased anon984_anon2255_array;  -- /usr/local/include/pjsip/sip_transaction.h:96
   --     role : aliased pjsip_sip_types_h.pjsip_role_e;  -- /usr/local/include/pjsip/sip_transaction.h:97
   --     method : aliased pjsip_sip_types_h.pjsip_method;  -- /usr/local/include/pjsip/sip_transaction.h:98
   --     cseq : aliased pj_types_h.pj_int32_t;  -- /usr/local/include/pjsip/sip_transaction.h:99
   --     transaction_key : aliased pj_types_h.pj_str_t;  -- /usr/local/include/pjsip/sip_transaction.h:100
   --     hashed_key : aliased pj_types_h.pj_uint32_t;  -- /usr/local/include/pjsip/sip_transaction.h:101
   --     branch : aliased pj_types_h.pj_str_t;  -- /usr/local/include/pjsip/sip_transaction.h:102
   --     status_code : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:107
   --     status_text : aliased pj_types_h.pj_str_t;  -- /usr/local/include/pjsip/sip_transaction.h:108
   --     state : aliased pjsip_tsx_state_e;  -- /usr/local/include/pjsip/sip_transaction.h:109
   --     handle_200resp : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:110
   --     tracing : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:111
   --     state_handler : access function (arg1 : access pjsip_transaction; arg2 : access pjsip_sip_types_h.pjsip_event) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:114
   --     transport : access pjsip_sip_types_h.pjsip_transport;  -- /usr/local/include/pjsip/sip_transaction.h:119
   --     is_reliable : aliased pj_types_h.pj_bool_t;  -- /usr/local/include/pjsip/sip_transaction.h:120
   --     addr : pj_sock_h.pj_sockaddr;  -- /usr/local/include/pjsip/sip_transaction.h:121
   --     addr_len : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:122
   --     res_addr : aliased pjsip_sip_util_h.pjsip_response_addr;  -- /usr/local/include/pjsip/sip_transaction.h:123
   --     transport_flag : aliased unsigned;  -- /usr/local/include/pjsip/sip_transaction.h:124
   --     transport_err : aliased pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:125
   --     tp_sel : aliased pjsip_sip_transport_h.pjsip_tpselector;  -- /usr/local/include/pjsip/sip_transaction.h:126
   --     pending_tx : access pjsip_sip_types_h.pjsip_tx_data;  -- /usr/local/include/pjsip/sip_transaction.h:127
   --     tp_st_key : System.Address;  -- /usr/local/include/pjsip/sip_transaction.h:130
   --     last_tx : access pjsip_sip_types_h.pjsip_tx_data;  -- /usr/local/include/pjsip/sip_transaction.h:136
   --     retransmit_count : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:137
   --     retransmit_timer : aliased pj_types_h.pj_timer_entry;  -- /usr/local/include/pjsip/sip_transaction.h:138
   --     timeout_timer : aliased pj_types_h.pj_timer_entry;  -- /usr/local/include/pjsip/sip_transaction.h:139
   --     mod_data : aliased anon984_anon2093_array;  -- /usr/local/include/pjsip/sip_transaction.h:142
   --  end record;
   --  pragma Convention (C_Pass_By_Copy, pjsip_transaction);  -- /usr/local/include/pjsip/sip_transaction.h:80
   
   
   -- FIXME:
   type anon_2242 is null record;
   --  type anon_2242 is record
   --     Msg_Buf      : C.Strings.chars_ptr;
   --     Length       : aliased C.int;
   --     Message      : access SIP_Msg.Message_Type;
   --     Information  : Interfaces.C.Strings.chars_ptr;
   --     Cid          : access pjsip_sip_msg_h.pjsip_cid_hdr;
   --     From         : access pjsip_sip_msg_h.pjsip_from_hdr;
   --     To           : access pjsip_sip_msg_h.pjsip_to_hdr;
   --     Via          : access pjsip_sip_msg_h.pjsip_via_hdr;
   --     Cseq         : access pjsip_sip_msg_h.pjsip_cseq_hdr;
   --     Max_Fwd      : access pjsip_sip_msg_h.pjsip_max_fwd_hdr;
   --     Route        : access pjsip_sip_msg_h.pjsip_route_hdr;
   --     Record_Route : access pjsip_sip_msg_h.pjsip_rr_hdr;
   --     Ctype        : access pjsip_sip_msg_h.pjsip_ctype_hdr;
   --     Clength      : access pjsip_sip_msg_h.pjsip_clen_hdr;
   --     Require      : access pjsip_sip_msg_h.pjsip_require_hdr;
   --     Supported    : access pjsip_sip_msg_h.pjsip_supported_hdr;
   --     Parse_Error  : aliased pjsip_sip_parser_h.pjsip_parser_err_report;
   --  end record;
   --  pragma Convention (C_Pass_By_Copy, anon_2242);
   
   -- FIXME:
   type anon2243_anon2093_array is array (0 .. 31) of System.Address;
   type anon_2243 is null record;
   --  type anon_2243 is record
   --     Mod_Data : aliased anon2243_anon2093_array;
   --  end record;
   --  pragma Convention (C_Pass_By_Copy, anon_2243);
   
   
   type Transport_Type;
   type Transport_Info_Type is record
      Pool      : access Pool.Pool_Type;  -- Memory pool
      Transport : access Transport_Type; 
      Tp_Data   : System.Address;  -- Other transport specific data
      Op_Key    : aliased Rx_Data_Op_Key_Type; -- I/O-Queue key
   end record;
   pragma Convention (C_Pass_By_Copy, Transport_Info_Type);
   
   subtype anon2237_anon2239_array is Interfaces.C.char_array (1 .. 4000);
   subtype anon2237_anon2241_array is Interfaces.C.char_array (1 .. 46);
   type Packet_Info_Type is record
      Timestamp             : aliased Types.Time_Value_Type;
      Packet                : aliased anon2237_anon2239_array;
      Zero                  : aliased Types.Uint_32_T;
      Length                : aliased Types.Ssize_T;
      source_address        : Sock.Socket_Address_Type;
      Source_Address_Length : aliased C.Int;
      Source_name           : aliased anon2237_anon2241_array;
      Source_Port           : aliased C.Int;
   end record;
   pragma Convention (C_Pass_By_Copy, Packet_Info_Type);
   
   
   type RX_Data_Type is record
      Transport_Info : aliased Transport_Info_Type;
      Packet_Info    : aliased Packet_Info_Type;  -- The incoming packet
      Message_Info   : aliased anon_2242;  -- /usr/local/include/pjsip/sip_transport.h:403
      Endpoint_Info  : aliased anon_2243;  -- /usr/local/include/pjsip/sip_transport.h:417
   end record;
   pragma Convention (C_Pass_By_Copy, RX_Data_Type);  -- /usr/local/include/pjsip/sip_transport.h:281
   type TX_Data_Type;
   
   type Transport_Direction_Type is 
     (None,
      Outgoing,
      Incoming);
   pragma Convention (C, Transport_Direction_Type);
   
   type Transport_Key_Type is record
      Key_Type : aliased C.long;
      rem_addr : Sock.Socket_Address_Type;  -- /usr/local/include/pjsip/sip_transport.h:705
   end record;
   pragma Convention (C_Pass_By_Copy, Transport_Key_Type);
   
   type Transport_Type is record
      Object_name       : aliased Types.Object_Name_Type;
      Pool              : access Pool.Pool_Type;
      Reference_Count   : access Types.Atomic_T;
      Lock              : System.Address;  -- Lock object
      Tracing           : aliased Types.Boolean_T;
      Is_Shutdown       : aliased Types.Boolean_T;
      Is_Destroying     : aliased Types.Boolean_T;
      Key               : aliased Transport_Key_Type; -- Index key for transport table
      Type_Name         : C.Strings.Chars_Ptr;
      Flag              : aliased C.Unsigned;
      Info              : Interfaces.C.Strings.chars_ptr;
      Address_Length    : aliased C.Int;
      Local_Address     : Sock.Socket_Address_Type;
      Local_Name        : aliased Types.Host_Port_Type;
      Remote_Name       : aliased Types.Host_Port_Type;
      Direction         : aliased Transport_Direction_Type;
      Endpoint          : System.Address;
      Transport_Manager : System.Address;
      Idle_Timer        : aliased Timer.Timer_Entry_Type;
      Data              : System.Address; -- Internal transport data
      
      -- Function to be called by transport manager to send SIP message.
      Send_SIP_Message  : access function
	(Transport          : access Transport_Type;
	 Data               : access TX_Data_Type;
	 Remote_Address     : System.Address; -- TODO: pj_sockaddr_t
	 Address_Length     : C.Int;
	 Token              : System.Address;
	 
	 Transport_Callback : access procedure
	   (Transport  : access Transport_Type ;
	    Token      : System.Address;
	    Sent_Bytes : Types.Ssize_T)
	) 
	return Types.Status_T;
      
      -- Initiates a shutdown      
      Do_Shutdown : access function
	(Transport : access Transport_Type) 
	return Types.Status_T;
      
      -- Forcefully destroy this transport regardless whether there are
      -- objects that currently use this transport.
      Destroy : access function 
	(Transport : access Transport_Type) 
	return Types.Status_T;
   end record; 
   pragma Convention (C_Pass_By_Copy, Transport_Type);
   
   
   -- FIXME:
   type Tx_Data_Type is null record;
   --  type Tx_Data_Type is record
   --     Previous     : access TX_Data_Type;
   --     Next         : access TX_Data_Type;
   --     Pool         : access Pool.Pool_Type;
   --     Object_Name  : aliased Types.Object_Name_type;
   --     Info         : C.Strings.chars_ptr;
   --     RX_Timestamp : aliased pj_types_h.pj_time_val;
   --     Mgr          : System.Address;
   --     Op_Key       : aliased TX_Data_Op_Key_Type;
   --     Lock         : System.Address;
   --     Message      : access pjsip_sip_types_h.pjsip_msg;
   --     Saved_Strict_Route : access pjsip_sip_msg_h.pjsip_route_hdr;
   --     Buf : aliased pjsip_sip_types_h.pjsip_buffer;
   --     ref_cnt : System.Address;
   --     is_pending : aliased int;
   --     token : System.Address;
   --     cb : access procedure
   --          (arg1 : System.Address;
   --           arg2 : access pjsip_sip_types_h.pjsip_tx_data;
   --           arg3 : pj_types_h.pj_ssize_t);
   --     dest_info : aliased anon_2264;
   --     tp_info : aliased anon_2265;
   --     tp_sel : aliased pjsip_tpselector;
   --     auth_retry : aliased pj_types_h.pj_bool_t;
   --     mod_data : aliased anon988_anon2093_array;
   --  end record;
   --  pragma Convention (C_Pass_By_Copy, Tx_Data_Type);
   
end SIP_Transport;
