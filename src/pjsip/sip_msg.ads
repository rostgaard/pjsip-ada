with System;
with Interfaces.C;
with Interfaces.C.Strings;

with Pool;
with Types;
with SIP_URI;

package SIP_Msg is
   package C renames Interfaces.C;
   

   type Header_Enum is 
     (H_ACCEPT,
      H_ACCEPT_ENCODING_UNIMP,
      H_ACCEPT_LANGUAGE_UNIMP,
      H_ALERT_INFO_UNIMP,
      H_ALLOW,
      H_AUTHENTICATION_INFO_UNIMP,
      H_AUTHORIZATION,
      H_CALL_ID,
      H_CALL_INFO_UNIMP,
      H_CONTACT,
      H_CONTENT_DISPOSITION_UNIMP,
      H_CONTENT_ENCODING_UNIMP,
      H_CONTENT_LANGUAGE_UNIMP,
      H_CONTENT_LENGTH,
      H_CONTENT_TYPE,
      H_CSEQ,
      H_DATE_UNIMP,
      H_ERROR_INFO_UNIMP,
      H_EXPIRES,
      H_FROM,
      H_IN_REPLY_TO_UNIMP,
      H_MAX_FORWARDS,
      H_MIME_VERSION_UNIMP,
      H_MIN_EXPIRES,
      H_ORGANIZATION_UNIMP,
      H_PRIORITY_UNIMP,
      H_PROXY_AUTHENTICATE,
      H_PROXY_AUTHORIZATION,
      H_PROXY_REQUIRE_UNIMP,
      H_RECORD_ROUTE,
      H_REPLY_TO_UNIMP,
      H_REQUIRE,
      H_RETRY_AFTER,
      H_ROUTE,
      H_SERVER_UNIMP,
      H_SUBJECT_UNIMP,
      H_SUPPORTED,
      H_TIMESTAMP_UNIMP,
      H_TO,
      H_UNSUPPORTED,
      H_USER_AGENT_UNIMP,
      H_VIA,
      H_WARNING_UNIMP,
      H_WWW_AUTHENTICATE,
      H_OTHER);
   pragma Convention (C, Header_Enum);
   for Header_Enum'Size use C.Unsigned'Size;
   
   type Msg_Type_Enum is 
     (REQUEST_MSG,
      RESPONSE_MSG);
   pragma Convention (C, Msg_Type_Enum);
   
   type Method_Enum is 
     (INVITE,
      CANCEL,
      ACK,
      BYE,
      REGISTER,
      OPTIONS,
      OTHER);
   pragma Convention (C, Method_Enum);
   
   type Header_Vptr_Type is record
      Clone : access function 
	(Pool   : access Pool.Pool_Type;
	 Header : System.Address) 
	return System.Address;
      
      Shallow_Clone : access function 
	(Pool   : access Pool.Pool_Type;
	 Header : System.Address) 
	return System.Address;
      
      Print_On : access function
           (Header : System.Address;
            Buffer : Interfaces.C.Strings.chars_ptr;
            Length : Types.Size_T) 
	   return C.Int;
   end record;
   pragma Convention (C_Pass_By_Copy, Header_Vptr_Type);
   
   type Media_Type is record
      c_type : aliased Types.String_T;
      c_subtype : aliased Types.String_T;
      param : aliased SIP_URI.Parameter_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, Media_Type);
   
   type Header_Type is record
      Previous : access Header_Type;
      Next     : access Header_Type;
      H_type   : aliased Header_Enum;  -- Type
      Name     : aliased Types.String_T;
      Sname    : aliased Types.String_T;
      Vptr     : access Header_Vptr_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, Header_Type);
   
   type Body_Type is record
      Content_Type : aliased Media_Type;
      Data         : System.Address;
      Length       : aliased C.unsigned;
      
      Print_Body   : access function
	(Message_Body : access Body_Type;
	 Buffer       : C.Strings.Chars_Ptr;
	 Length       : Types.Size_T) return C.int;
      
      Clone_Data   : access function
	(Pool   : access Pool.Pool_Type;
	 Data   : System.Address;
	 Length : C.unsigned) 
	return System.Address;
   end record;
   pragma Convention (C_Pass_By_Copy, Body_type);
   
   type Method_Type is record
      ID   : aliased Method_Enum;
      Name : aliased Types.String_T;
   end record;
   pragma Convention (C_Pass_By_Copy, Method_Type);
   
   type Request_Line_Type is record
      Method : aliased Method_Type;
      Uri    : access SIP_URI.URI_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, Request_Line_Type);

   type Status_Line_Type is record
      Code   : aliased C.Int;
      Reason : aliased Types.String_T;
   end record;
   pragma Convention (C_Pass_By_Copy, Status_Line_Type);   
   
   type Line_Type (Status_Line : C.unsigned := 0) is record
      case Status_Line is
         when 0 =>
            Request : aliased Request_Line_Type;
         when others =>
            Status : aliased Status_Line_Type;
      end case;
   end record;
   pragma Convention (C_Pass_By_Copy, Line_Type);
   pragma Unchecked_Union (Line_Type);
   
   type Message_Type is record
      Msg_Type : aliased Msg_Type_Enum;
      Line     : Line_Type;
      Header   : aliased Header_Type;
      Msg_Body : access Body_Type;
   end record;
   pragma Convention (C_Pass_By_Copy, Message_Type);
   
   
   
end SIP_Msg;
