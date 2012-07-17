with Interfaces.C;
with System;

with Types;

package Timer is
   package C renames Interfaces.C;
   
   subtype Timer_Id_T is C.Int;
   
   type Timer_Heap_T is null record;
   type Timer_Entry_Type;
   
   type Timer_Heap_Callback is access procedure 
     (Timer_Heap  : access Timer_Heap_T; -- pj_timer_heap_t *timer_heap,
      Timer_Entry : access Timer_Entry_Type);
   pragma Convention (C,Timer_Heap_Callback);
     
   type Timer_Entry_Type is record
      User_Data      : System.Address;
      ID             : aliased C.int;
      Heap_Calback   : Timer_Heap_Callback;
      U_Timer_Id     : aliased Timer_Id_T;
      U_Timer_Value  : aliased Types.Time_Value_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, Timer_Entry_Type);
   
end Timer;
