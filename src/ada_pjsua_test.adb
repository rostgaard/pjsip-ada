with Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;
with Interfaces.C; -- REMOVE THIS

-- Local packages
with Debug;
with Configuration;
with Types; use Types;
with PJSUA;
with Transport_SRTP;

procedure Ada_Pjsua_Test is
   use Ada.Text_IO;
   
   Config           : PJSUA.Config_Type;
   Log_Config       : PJSUA.Logging_Config_Type;
   Account_Config   : PJSUA.Account_Config_Type;
   Account_ID       : Interfaces.C.Int;
   Transport_Config : PJSUA.Transport_Config_Type;
   
begin
   Configuration.Load_Config_File("ada_pjsua_test.conf");
   -- Create pjsua "object" first!
   if PJSUA.Create /= Success then
      return;
   end if;
   
   
   Put_Line ("Verifying SIP URL " & "sip:" & 
	       Configuration.Value("Username") &
	       "@" & Configuration.Value("Realm"));
   
   if PJSUA.Verify_Url("sip:" & Configuration.Value("Username") & "@" &
			 Configuration.Value("Realm")) /= Success then
      Put_Line("Invalid SIP URL");
   else
      Put_Line("SIP URL ok");
   end if;
   
   PJSUA.Config_Default (Config);


   PJSUA.Logging_Config_Default (Log_Config);
   Log_Config.Console_Level := 3;
   PJSUA.Init(Config,Log_Config);
   
   PJSUA.Transport_Config_Default (Transport_Config);
   PJSUA.Transport_Config_Default (Transport_Config);
   Transport_Config.Port  := 5060;
   PJSUA.Transport_Create (PJSUA.PJSIP_TRANSPORT_UDP,Transport_Config);
   
   if PJSUA.Start /= Success then
      Put_Line ("Start failed!");
   else
      Put_Line ("Start OK!");
   end if;
   
   
   -- Set the initial config values
   PJSUA.Account_Config_Default (Account_Config);
   
   Account_Config.Credential_Count := 1;
   
   Account_Config.ID := PJSUA.To_PJ_String
     ("sip:" & Configuration.Value("Username") & "@" &
	Configuration.Value("Realm"));
   
   Account_Config.Registration_URI := 
     PJSUA.To_PJ_String("sip:" & Configuration.Value("Realm"));
   
   Account_Config.Credential_Info(1).Realm 
     := PJSUA.To_PJ_String ("asterisk");
   Account_Config.Credential_Info(1).Scheme 
     := PJSUA.To_PJ_String ("digest");
   Account_Config.Credential_Info(1).Username 
     := PJSUA.To_PJ_String (Configuration.Value("Username"));
   Account_Config.Credential_Info(1).Data_Type := 0;
   Account_Config.Credential_Info(1).Data
     := PJSUA.To_PJ_String (Configuration.Value("Password"));
   
   if PJSUA.Account_Add(Account_Config,Account_ID) /= Success then
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
	--  pjsua_config_default(&cfg);
	--  cfg.cb.on_incoming_call = &on_incoming_call;
	--  cfg.cb.on_call_media_state = &on_call_media_state;
	--  cfg.cb.on_call_state = &on_call_state;
   
   
   
   --  status = pjsua_init(&cfg, &log_cfg, NULL);
	--  if (status != PJ_SUCCESS) error_exit("Error in pjsua_init()", status);
   
exception
   when Error : others =>
      Debug.Log
	("Got undefined exception: " & Exception_Information(Error),Debug.Fatal);
end Ada_Pjsua_Test;
