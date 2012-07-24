with System;
with Interfaces.C.Strings; use Interfaces.C.Strings;

package body Callbacks is
   procedure On_Incoming_Call (Account_ID : PJSUA.Account_ID_Type;
			       Call_ID    : PJSUA.Call_Id_Type;
			       RX_Data    : SIP_Transport.RX_Data_Type) is
      use Types;
      -- Call_Information : Pjsua.Call_Info_type;
      Reason : aliased Types.String_T := PJSUA.To_PJ_String (New_String(""));
   begin
      -- PJSUA.Call_Get_Info (Call_ID, Call_Information);
      -- Put_Line ("Got call from: "); -- Call_Information.remote_info.slen
      if PJSUA.Call_Answer
	(Call_ID, 200, 
	 Reason'access,
	 System.Null_Address) /= Success then
	 Debug.Log ("Could not pickup call",Debug.Error);
      end if;
      
   end On_Incoming_Call;
end Callbacks;
