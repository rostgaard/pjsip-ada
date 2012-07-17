with Interfaces.C;
with Interfaces.C.Strings;
with System;
with Types;

package Pool is
   package C renames Interfaces.C;
   
   type Pool_Factory_Type; 
   type Pool_Type;
   

   type Pool_Block_Type is record
      Previous   : access Pool_Block_Type;
      Next       : access Pool_Block_Type;
      Buffer     : access C.Unsigned_Char;
      Current    : access C.Unsigned_Char;
      Buffer_End : access C.Unsigned_Char;
   end record;
   pragma Convention (C_Pass_By_Copy, Pool_Block_Type);
   
   type Pool_Factory_Policy_Type is record
      Block_Allocate : access function 
	(Factory : access Pool_Factory_Type; 
	 Size    : Types.Size_T) -- Size to allocate
	return System.Address; -- Memory pool
      Block_Free : access procedure
	(Factory : access Pool_Factory_Type;
	 Memory  : System.Address;
	 Size    : Types.Size_T);
      Error_Callback : access procedure 
	(Pool : System.Address; 
	 Size : Types.Size_T);
      Flags : aliased C.unsigned;
   end record;
   pragma Convention (C_Pass_By_Copy, Pool_Factory_Policy_Type);
   
   type Pool_Factory_Type is record
      Policy : aliased Pool_Factory_Policy_Type;
      create_pool : access function
	(arg1 : access Pool_Factory_Type;
	 arg2 : C.Strings.chars_ptr;
	 arg3 : Types.Size_T;
	 arg4 : Types.Size_T;
	 arg5 : access procedure (arg1 : System.Address; arg2 : Types.Size_T)) return access Pool_Type;  -- /usr/local/include/pj/pool.h:682
      Release_Pool : access procedure 
	(arg1 : access Pool_Factory_Type; 
	 arg2 : access Pool_Type);  -- /usr/local/include/pj/pool.h:694
      dump_status : access procedure 
	(arg1 : access Pool_Factory_Type; 
	 arg2 : Types.Boolean_T);  -- /usr/local/include/pj/pool.h:701
      on_block_alloc : access function 
	(arg1 : access Pool_Factory_Type; 
	 arg2 : Types.Size_T) 
	return Types.Boolean_T;  -- /usr/local/include/pj/pool.h:715
      on_block_free : access procedure 
	(arg1 : access Pool_Factory_Type; 
	 arg2 : Types.Size_T);  -- /usr/local/include/pj/pool.h:726
   end record;
   pragma Convention (C_Pass_By_Copy, Pool_Factory_Type);  -- /usr/local/include/pj/pool.h:651
   
   subtype Object_Name_Type is C.Char_Array (1 .. Types.PJ_MAX_OBJ_NAME);
   type Pool_Type is record
      Previous       : access Pool_Type;
      Next           : access Pool_Type;
      Object_name    : aliased Object_Name_Type;
      Factory        : access Pool_Factory_Type;
      Factory_Data   : System.Address;
      Capacity       : aliased Types.size_t;
      Increment_Size : aliased Types.size_t;
      Block_List     : aliased Pool_Block_Type;
      Callback       : access procedure 
	(arg1 : System.Address; arg2 : Types.Size_T);
   end record;
   pragma Convention (C_Pass_By_Copy, Pool_Type);  -- /usr/local/include/pj/pool.h:313

end Pool;   
