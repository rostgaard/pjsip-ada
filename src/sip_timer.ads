-- Ada definitions of the types found in 
-- pjsip/include/pjsip-ua/sip_timer.h 
with Interfaces.C;

package SIP_Timer is 
   package C renames Interfaces.C;
     type Setting_Type is record
	Minimum_Session_Expiration_Period : C.Unsigned := 90;
	Session_Expiration_Period         : C.Unsigned := 1800;
     end record;
     for Setting_Type'Size use 8*8;
     -- Orig: pjsip_timer_setting
     -- This structure describes Session Timers settings in an invite session.
     -- Periods are defined in seconds
     
end SIP_Timer;
