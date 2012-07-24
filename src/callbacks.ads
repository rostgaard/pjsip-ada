with Debug;
with Types;
with PJSUA;
with SIP_Transport;

package Callbacks is
   procedure On_Incoming_Call (Account_ID : PJSUA.Account_ID_Type;
			       Call_ID    : PJSUA.Call_Id_Type;
			       RX_Data    : SIP_Transport.RX_Data_Type);
   -- Automagically picks up an incoming call
end Callbacks;
