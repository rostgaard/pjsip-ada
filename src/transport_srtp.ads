-- Ada definitions of the types found in 
-- pjmedia/include/pjmedia/transport_srtp.h
-- Part of PJMedia

with Interfaces.C;

package Transport_SRTP is
   package C renames Interfaces.C;
   
   type SRTP_Use_Type is 
     (PJMEDIA_SRTP_DISABLED,
      PJMEDIA_SRTP_OPTIONAL,
      PJMEDIA_SRTP_MANDATORY);
   for SRTP_Use_Type'Size use C.Unsigned'Size; 
   
   
   SRTP_Use_To_C_Int : constant array (SRTP_Use_Type) of C.Int :=
     (PJMEDIA_SRTP_DISABLED  => 0,
      PJMEDIA_SRTP_OPTIONAL  => 1,
      PJMEDIA_SRTP_MANDATORY => 2);
   
   C_Int_To_SRTP_Use : constant array (C.Int range 0 .. 2) of SRTP_Use_Type :=
     (0 => PJMEDIA_SRTP_DISABLED,
      1 => PJMEDIA_SRTP_OPTIONAL,
      2 => PJMEDIA_SRTP_MANDATORY);
end Transport_SRTP;
