-- Ada definitions of the types found in 
-- pjsip/include/pjsip/sip_auth.h
with Interfaces.C;

with Types;
package SIP_Auth is 
   package C renames Interfaces.C;
   
   type Aka_Digest_Callback is access procedure;
   
   type Digest_AKA_Credential_Type is record
      Subscriber_Key                  : Types.String_T;
      Operator_Variant_Key            : Types.String_T;
      Authentication_Management_Field : Types.String_T;
      Callback_To_Create_AKA_Digest   : Aka_Digest_Callback;
   end record;      
   pragma Pack (Digest_AKA_Credential_Type);
   
   type Credential_Info_Type is record
      Realm     : Types.String_T; -- Use "*" to make a credential that can be 
				     -- used to authenticate against any challenge
      Scheme    : Types.String_T; -- e.g. "digest"
      Username  : Types.String_T; 
      Data_Type : C.Int;             -- 0 for plaintext passwd (should be method)
      Data      : Types.String_T; -- Plaintext or hashed digest.
      Extended  : Digest_AKA_Credential_Type;
   end record;
   for Credential_Info_Type'Size use 128*8;
      -- Orig: pjsip_cred_info

end SIP_Auth;
   
