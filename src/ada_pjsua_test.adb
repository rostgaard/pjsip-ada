with Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;
with Interfaces.C; use Interfaces.C;-- REMOVE THIS
with Interfaces.C.Strings; use Interfaces.C.Strings;
with System;

-- Local packages
with Debug;
with Configuration;
with Callbacks;
with Types; use Types;
with PJSUA;
with Transport_SRTP;
with SIP_Types;
with SIP_Transport;

procedure Ada_Pjsua_Test is
   use Ada.Text_IO;
   
   Config           : aliased PJSUA.Config_Type;
   Log_Config       : aliased PJSUA.Logging_Config_Type;
   Account_Config   : aliased PJSUA.Account_Config_Type;
   Account_ID       : aliased PJSUA.Account_ID_Type;
   Transport_Config : aliased PJSUA.Transport_Config_Type;
   Transport_ID     : aliased PJSUA.Transport_Id_Type;
   
   for Transport_ID'Address use System.Null_Address;
   
   --  /* Automatically answer incoming calls with 200/OK */
   --    pjsua_call_answer(call_id, 200, NULL, NULL);
   --  }
     
     
     --  /* Callback called by the library upon receiving incoming call */
--  static void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id,
--                               pjsip_rx_data *rdata)
--  {
--      pjsua_call_info ci;

--      PJ_UNUSED_ARG(acc_id);
--      PJ_UNUSED_ARG(rdata);

--      pjsua_call_get_info(call_id, &ci);

--      PJ_LOG(3,(THIS_FILE, "Incoming call from %.*s!!",
--                           (int)ci.remote_info.slen,
--                           ci.remote_info.ptr));

--      /* Automatically answer incoming calls with 200/OK */
--      pjsua_call_answer(call_id, 200, NULL, NULL);
--  }

--  /* Callback called by the library when call's state has changed */
--  static void on_call_state(pjsua_call_id call_id, pjsip_event *e)
--  {
--      pjsua_call_info ci;

--      PJ_UNUSED_ARG(e);

--      pjsua_call_get_info(call_id, &ci);
--      PJ_LOG(3,(THIS_FILE, "Call %d state=%.*s", call_id,
--                           (int)ci.state_text.slen,
--                           ci.state_text.ptr));
--  }

--  /* Callback called by the library when call's media state has changed */
--  static void on_call_media_state(pjsua_call_id call_id)
--  {
--      pjsua_call_info ci;

--      pjsua_call_get_info(call_id, &ci);

--      if (ci.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
--          // When media is active, connect call to sound device.
--          pjsua_conf_connect(ci.conf_slot, 0);
--          pjsua_conf_connect(0, ci.conf_slot);
--      }
--  }

--  /* Display error and exit application */
--  static void error_exit(const char *title, pj_status_t status)
--  {
--      pjsua_perror(THIS_FILE, title, status);
--      pjsua_destroy();
--      exit(1);
--  }
   
begin
   Configuration.Load_Config_File("ada_pjsua_test.conf");
   
   -- Create pjsua "object". This is an internal state in the library
   if PJSUA.Create /= Success then
      Debug.Log ("PJSUA object creation failed!", Debug.Fatal);
      return;
   end if;
   
   
   if PJSUA.Verify_Sip_Url(New_String("sip:" & Configuration.Value("Username") & "@" &
			 Configuration.Value("Realm"))) /= Success then
      Put_Line("Invalid SIP URL");
      return;
   end if;
   
   Debug.Log ("Verifying SIP URL " & "sip:" & 
		Configuration.Value("Username") &
		"@" & Configuration.Value("Realm") & "... ",Debug.Debug);
   
   PJSUA.Config_Default (Config'Access);
   Config.Event_Callback.On_Incoming_Call := Callbacks.On_Incoming_Call'Access;

   PJSUA.Logging_Config_Default (Log_Config'Access);
   Log_Config.Console_Level := 3;
   if PJSUA.Init
     (Config'Access,Log_Config'Access,System.Null_Address) /= Success then
      Debug.Log("Could not init PJSUA",Debug.Fatal);
      return;
   end if;
   
   PJSUA.Transport_Config_Default (Transport_Config);
   PJSUA.Transport_Config_Default (Transport_Config);
   Transport_Config.Port  := 5060;
   if PJSUA.Transport_Create 
     (SIP_Types.PJSIP_TRANSPORT_UDP,
      Transport_Config'Access, 
      Transport_ID'Access) /= Success then
      Debug.Log ("Could not create transport!",Debug.Fatal);
      return;
   end if;
      
   if PJSUA.Start /= Success then
      Put_Line ("Start failed!");
   else
      Put_Line ("Start OK!");
   end if;
   
   
   -- Set the initial config values
   PJSUA.Account_Config_Default (Account_Config'Access);
	--  cfg.cb.on_incoming_call = &on_incoming_call;
	--  cfg.cb.on_call_media_state = &on_call_media_state;
	--  cfg.cb.on_call_state = &on_call_state;
   
   Account_Config.Credential_Count := 1;
   
   Account_Config.ID := PJSUA.To_PJ_String
     (New_String("sip:" & Configuration.Value("Username") & "@" &
	Configuration.Value("Realm")));
   
   Account_Config.Registration_URI := 
     PJSUA.To_PJ_String(New_String("sip:" & Configuration.Value("Realm")));
   
   Account_Config.Credential_Info(1).Realm 
     := PJSUA.To_PJ_String (New_String("asterisk"));
   Account_Config.Credential_Info(1).Scheme 
     := PJSUA.To_PJ_String (New_String("digest"));
   Account_Config.Credential_Info(1).Username 
     := PJSUA.To_PJ_String (New_String(Configuration.Value("Username")));
   Account_Config.Credential_Info(1).Data_Type := 0;
   Account_Config.Credential_Info(1).Data
     := PJSUA.To_PJ_String (New_String(Configuration.Value("Password")));
   
   if PJSUA.Account_Add(Account_Config => Account_Config'Access,
			Account_ID     => Account_ID'access) /= Success then
      Put_Line ("Add failed!");
   end if;
   
   declare
      Buffer : String ( 1 .. 128) := (others => ' ');
      Filled : Natural := 0;
   begin
      loop
	 exit when Buffer(Buffer'First .. 4) = "exit"; 
	   
	 Get_Line(Buffer,filled);
	 Put_Line(Buffer(Buffer'First .. Filled));
      end loop;
   end;
   
   
   
   --  status = pjsua_init(&cfg, &log_cfg, NULL);
	--  if (status != PJ_SUCCESS) error_exit("Error in pjsua_init()", status);
   
exception
   when Error : others =>
      Debug.Log
	("Got undefined exception: " & Exception_Information(Error),Debug.Fatal);
end Ada_Pjsua_Test;
