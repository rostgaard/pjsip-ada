with System;

package IOqueue is
   type IOqueue_Internal_Data_Type is array (1 .. 32) of System.Address; -- void*
   type IOqueue_Op_Key_Type is record
      Internal_Data   : aliased IOqueue_Internal_Data_Type;
      Activesock_Data : System.Address; -- void*
      User_Data       : System.Address; -- void*
   end record;
   pragma Convention (C_Pass_By_Copy, IOqueue_Op_Key_Type);
   
end IOqueue;
