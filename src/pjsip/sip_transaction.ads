with System;
with Interfaces.C;

with Types;
with SIP_Module;
with SIP_Types;
with SIP_Message;

package SIP_Transaction is
   package C renames Interfaces.C;
   
   -- pjsip_tsx_state_e
   type State_Enum is 
     (PJSIP_TSX_STATE_NULL,
      PJSIP_TSX_STATE_CALLING,
      PJSIP_TSX_STATE_TRYING,
      PJSIP_TSX_STATE_PROCEEDING,
      PJSIP_TSX_STATE_COMPLETED,
      PJSIP_TSX_STATE_CONFIRMED,
      PJSIP_TSX_STATE_TERMINATED,
      PJSIP_TSX_STATE_DESTROYED,
      PJSIP_TSX_STATE_MAX);
   pragma Convention (C, State_Enum);
   for State_Enum'Size use C.Unsigned'Size;
   
   type Transaction_dummy is null record;
   subtype Transaction_Type is Transaction_Dummy;
   
--     -- TODO: Name these
--     subtype anon984_anon2255_array is Interfaces.C.char_array (1 .. 32);
--     type anon984_anon2093_array is array (1 .. 32) of System.Address;
   
--     -- pjsip_transaction
--     type pjsip_transaction is record
--        Pool  : access Pool.Pool_t;
--        Tsx_User : access SIP_Module.Module;
--        Endpt : System.Address;
--        Mutex : System.Address;
--        Mutex_B : System.Address;
--        Obj_Name : aliased anon984_anon2255_array;
--        Role   : aliased SIP_Types.Role;
--        Method : aliased SIP_Message.Method_Type;
--        Cseq : aliased Types.Int_32_T;
--        Transaction_Key : aliased Types.String_t;
--        Hashed_Key : aliased Types.Uint_32_T;
--        branch : aliased pj_types_h.pj_str_t;  -- /usr/local/include/pjsip/sip_transaction.h:102
--        status_code : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:107
--        status_text : aliased pj_types_h.pj_str_t;  -- /usr/local/include/pjsip/sip_transaction.h:108
--        state : aliased pjsip_tsx_state_e;  -- /usr/local/include/pjsip/sip_transaction.h:109
--        handle_200resp : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:110
--        tracing : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:111
--        state_handler : access function 
--  	(arg1 : access pjsip_transaction; 
--  	 arg2 : access pjsip_sip_types_h.pjsip_event) 
--  	return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:114
--        transport : access pjsip_sip_types_h.pjsip_transport;  -- /usr/local/include/pjsip/sip_transaction.h:119
--        is_reliable : aliased pj_types_h.pj_bool_t;  -- /usr/local/include/pjsip/sip_transaction.h:120
--        addr : pj_sock_h.pj_sockaddr;  -- /usr/local/include/pjsip/sip_transaction.h:121
--        addr_len : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:122
--        res_addr : aliased pjsip_sip_util_h.pjsip_response_addr;  -- /usr/local/include/pjsip/sip_transaction.h:123
--        transport_flag : aliased unsigned;  -- /usr/local/include/pjsip/sip_transaction.h:124
--        transport_err : aliased pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:125
--        tp_sel : aliased pjsip_sip_transport_h.pjsip_tpselector;  -- /usr/local/include/pjsip/sip_transaction.h:126
--        pending_tx : access pjsip_sip_types_h.pjsip_tx_data;  -- /usr/local/include/pjsip/sip_transaction.h:127
--        tp_st_key : System.Address;  -- /usr/local/include/pjsip/sip_transaction.h:130
--        last_tx : access pjsip_sip_types_h.pjsip_tx_data;  -- /usr/local/include/pjsip/sip_transaction.h:136
--        retransmit_count : aliased int;  -- /usr/local/include/pjsip/sip_transaction.h:137
--        retransmit_timer : aliased pj_types_h.pj_timer_entry;  -- /usr/local/include/pjsip/sip_transaction.h:138
--        timeout_timer : aliased pj_types_h.pj_timer_entry;  -- /usr/local/include/pjsip/sip_transaction.h:139
--        mod_data : aliased anon984_anon2093_array;  -- /usr/local/include/pjsip/sip_transaction.h
--  :142
--     end record;
--     pragma Convention (C_Pass_By_Copy, pjsip_transaction);  -- /usr/local/include/pjsip/sip_transaction.h:80
  
   -- pjsip_tsx_layer_init_module
   --  function Layer_Init_Module (arg1 : System.Address) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:153
   --  pragma Import (C, pjsip_tsx_layer_init_module, "pjsip_tsx_layer_init_module");

   --  function pjsip_tsx_layer_instance return access pjsip_sip_types_h.pjsip_module;  -- /usr/local/include/pjsip/sip_transaction.h:160
   --  pragma Import (C, pjsip_tsx_layer_instance, "pjsip_tsx_layer_instance");

   --  function pjsip_tsx_layer_destroy return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:167
   --  pragma Import (C, pjsip_tsx_layer_destroy, "pjsip_tsx_layer_destroy");

   --  function pjsip_tsx_layer_get_tsx_count return unsigned;  -- /usr/local/include/pjsip/sip_transaction.h:175
   --  pragma Import (C, pjsip_tsx_layer_get_tsx_count, "pjsip_tsx_layer_get_tsx_count");

   --  function pjsip_tsx_layer_find_tsx (arg1 : access constant pj_types_h.pj_str_t; arg2 : pj_types_h.pj_bool_t) return access pjsip_sip_types_h.pjsip_transaction;  -- /usr/local/include/pjsip/sip_transaction.h:189
   --  pragma Import (C, pjsip_tsx_layer_find_tsx, "pjsip_tsx_layer_find_tsx");

   --  function pjsip_tsx_create_uac
   --    (arg1 : access pjsip_sip_types_h.pjsip_module;
   --     arg2 : access pjsip_sip_types_h.pjsip_tx_data;
   --     arg3 : System.Address) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:211
   --  pragma Import (C, pjsip_tsx_create_uac, "pjsip_tsx_create_uac");

   --  function pjsip_tsx_create_uas
   --    (arg1 : access pjsip_sip_types_h.pjsip_module;
   --     arg2 : access pjsip_sip_types_h.pjsip_rx_data;
   --     arg3 : System.Address) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:229
   --  pragma Import (C, pjsip_tsx_create_uas, "pjsip_tsx_create_uas");

   --  function pjsip_tsx_set_transport (arg1 : access pjsip_sip_types_h.pjsip_transaction; arg2 : access constant pjsip_sip_transport_h.pjsip_tpselector) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:246
   --  pragma Import (C, pjsip_tsx_set_transport, "pjsip_tsx_set_transport");

   --  procedure pjsip_tsx_recv_msg (arg1 : access pjsip_sip_types_h.pjsip_transaction; arg2 : access pjsip_sip_types_h.pjsip_rx_data);  -- /usr/local/include/pjsip/sip_transaction.h:263
   --  pragma Import (C, pjsip_tsx_recv_msg, "pjsip_tsx_recv_msg");

   --  function pjsip_tsx_send_msg (arg1 : access pjsip_sip_types_h.pjsip_transaction; arg2 : access pjsip_sip_types_h.pjsip_tx_data) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:282
   --  pragma Import (C, pjsip_tsx_send_msg, "pjsip_tsx_send_msg");

   --  function pjsip_tsx_retransmit_no_state (arg1 : access pjsip_sip_types_h.pjsip_transaction; arg2 : access pjsip_sip_types_h.pjsip_tx_data) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:300
   --  pragma Import (C, pjsip_tsx_retransmit_no_state, "pjsip_tsx_retransmit_no_state");

   --  function pjsip_tsx_create_key
   --    (arg1 : access pj_types_h.pj_pool_t;
   --     arg2 : access pj_types_h.pj_str_t;
   --     arg3 : pjsip_sip_types_h.pjsip_role_e;
   --     arg4 : access constant pjsip_sip_types_h.pjsip_method;
   --     arg5 : access constant pjsip_sip_types_h.pjsip_rx_data) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:316
   --  pragma Import (C, pjsip_tsx_create_key, "pjsip_tsx_create_key");

   --  function pjsip_tsx_terminate (arg1 : access pjsip_sip_types_h.pjsip_transaction; arg2 : int) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:328
   --  pragma Import (C, pjsip_tsx_terminate, "pjsip_tsx_terminate");

   --  function pjsip_tsx_stop_retransmit (arg1 : access pjsip_sip_types_h.pjsip_transaction) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:345
   --  pragma Import (C, pjsip_tsx_stop_retransmit, "pjsip_tsx_stop_retransmit");

   --  function pjsip_tsx_set_timeout (arg1 : access pjsip_sip_types_h.pjsip_transaction; arg2 : unsigned) return pj_types_h.pj_status_t;  -- /usr/local/include/pjsip/sip_transaction.h:368
   --  pragma Import (C, pjsip_tsx_set_timeout, "pjsip_tsx_set_timeout");

   --  function pjsip_rdata_get_tsx (arg1 : access pjsip_sip_types_h.pjsip_rx_data) return access pjsip_sip_types_h.pjsip_transaction;  -- /usr/local/include/pjsip/sip_transaction.h:382
   --  pragma Import (C, pjsip_rdata_get_tsx, "pjsip_rdata_get_tsx");

   --  procedure pjsip_tsx_layer_dump (arg1 : pj_types_h.pj_bool_t);  -- /usr/local/include/pjsip/sip_transaction.h:396
   --  pragma Import (C, pjsip_tsx_layer_dump, "pjsip_tsx_layer_dump");

   --  function pjsip_tsx_state_str (arg1 : pjsip_tsx_state_e) return Interfaces.C.Strings.chars_ptr;  -- /usr/local/include/pjsip/sip_transaction.h:402
   --  pragma Import (C, pjsip_tsx_state_str, "pjsip_tsx_state_str");

   --  function pjsip_role_name (arg1 : pjsip_sip_types_h.pjsip_role_e) return Interfaces.C.Strings.chars_ptr;  -- /usr/local/include/pjsip/sip_transaction.h:408
   --  pragma Import (C, pjsip_role_name, "pjsip_role_name");

   
   
end SIP_Transaction;
