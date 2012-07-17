package Sip_Event is
   
   type Event_Id_E is -- pjsip_event_id_e
     (Unknown,
      Timer,
      TX_Msg,
      RX_Msg,
      Transport_Error,
      TSX_State,
      User);
   pragma Convention (C, Event_Id_E);
   
   type Event_Type is record
      Prev : access Event_Type;  -- /usr/local/include/pjsip/sip_event.h:83
      Next : access Event_Type;  -- /usr/local/include/pjsip/sip_event.h:83
      C_Type : aliased Event_Id_E;  -- /usr/local/include/pjsip/sip_event.h:87
      -- TODO
      --      C_Body : anon986_anon1741_union;  -- /usr/local/include/pjsip/sip_event.h:153
   end record;
   pragma Convention (C_Pass_By_Copy, Event_Type);  -- /usr/local/include/pjsip/sip_event.h:80
   -- TODO, insert pragma statement
end Sip_Event;   
