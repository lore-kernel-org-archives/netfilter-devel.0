From: Quinton Hoole <quinton@hoole.biz>
Subject: Mangling IP Options
Date: Thu, 02 Jun 2005 09:31:42 +0200
Message-ID: <429EB5DE.7090203@hoole.biz>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms000300080707060209040800"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms000300080707060209040800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi

I'm trying to write a target to mangle IP options fields, but I'm new to 
netfilter (and linux, for that matter) and am struggling to understand 
some of the kernel data structures.  In particular I need to know where 
to insert/overwrite IP options fields.  I'm using Fabrice's 
ipt_IPV4OPTSTRIP.c as a starting point, as it clears the fields I'm 
wanting to alter.

What I don't quite understand is the difference between the ip_options 
structure in:

(unsigned char *)(skb.nh.iph) + sizeof (struct iphdr) /* skb is a 
(struct sk_buff *) */

and the one in:

IPCB(skb)->opt

which is a macro that expands to:

((struct inet_skb_parm)(skb->cb))-opt

Why two copies of the ip_options in two different places?  The one 
appears to be a compiled version of the other?
The other thing I don't get is where the actual IP options fields 
reside, and in what format?  I have RFC791, and know the structure of 
the options in the IP packet, but clearly this is not identical to the 
structure of struct ip_options, which has a mysterious

unsigned char __data[0]

field at the end.  I assume the stuff is in there, but how do I decode this?

Any help much appreciated.

Q



--------------ms000300080707060209040800
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJMzCC
AvQwggJdoAMCAQICAw5bdTANBgkqhkiG9w0BAQQFADBiMQswCQYDVQQGEwJaQTElMCMGA1UE
ChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNv
bmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwHhcNMDUwMzI4MTIyNjMzWhcNMDYwMzI4MTIyNjMz
WjBoMQ4wDAYDVQQEEwVIb29sZTEWMBQGA1UEKhMNUXVpbnRvbiBSb2JpbjEcMBoGA1UEAxMT
UXVpbnRvbiBSb2JpbiBIb29sZTEgMB4GCSqGSIb3DQEJARYRcXVpbnRvbkBob29sZS5iaXow
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC2t2P0XVPSgHFYzIz5VYiJgV1Sl+Oa
WGweARrZV3zD99eElbJ/+FjlNz5B1NEhuEpWCBFUWk6aOQX3fe5FEY4PGgqTjUh9nISs+WJ1
/0XX+BPBEj81Jf39lKU01fKhT7nBbcJkH4xzSXUTzRwYVBRtd/rn03Ohx/RLvQJty30C4OJH
TI9QMjsas1pYF9nxD9UfjDRiWVD/t7ul+ObBHF2dJs0Gzd9atLaqL0KTqPgiN9lvEmtv2nL5
cFcAwSTVbyI3MY/rCVKH/SEYtTz9QlXSEDwcLkr3jrBHFLiTGteFStnbqThVXcnEagogLvpr
rfZlyBiPXLJBYcmEJmtPNqAPAgMBAAGjLjAsMBwGA1UdEQQVMBOBEXF1aW50b25AaG9vbGUu
Yml6MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEEBQADgYEAvYtE54g0h4KpYONj2VgB3+vu
Xtnj7YtUpUWW+cpgYIZ+YbGVhzV79zuBN36EaEFEJRs4SWtjPe39BbzXmnkc/pt25o8zan9c
5L2jM7WN8lXKSBT8m7+VbDtOfxtlM/8WSJbiESPJIIRzOoXio3KSsVLbiY5vGh8jajUBqce/
YaMwggL0MIICXaADAgECAgMOW3UwDQYJKoZIhvcNAQEEBQAwYjELMAkGA1UEBhMCWkExJTAj
BgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA1MDMyODEyMjYzM1oXDTA2MDMyODEy
MjYzM1owaDEOMAwGA1UEBBMFSG9vbGUxFjAUBgNVBCoTDVF1aW50b24gUm9iaW4xHDAaBgNV
BAMTE1F1aW50b24gUm9iaW4gSG9vbGUxIDAeBgkqhkiG9w0BCQEWEXF1aW50b25AaG9vbGUu
Yml6MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtrdj9F1T0oBxWMyM+VWIiYFd
UpfjmlhsHgEa2Vd8w/fXhJWyf/hY5Tc+QdTRIbhKVggRVFpOmjkF933uRRGODxoKk41IfZyE
rPlidf9F1/gTwRI/NSX9/ZSlNNXyoU+5wW3CZB+Mc0l1E80cGFQUbXf659Nzocf0S70Cbct9
AuDiR0yPUDI7GrNaWBfZ8Q/VH4w0YllQ/7e7pfjmwRxdnSbNBs3fWrS2qi9Ck6j4IjfZbxJr
b9py+XBXAMEk1W8iNzGP6wlSh/0hGLU8/UJV0hA8HC5K946wRxS4kxrXhUrZ26k4VV3JxGoK
IC76a632ZcgYj1yyQWHJhCZrTzagDwIDAQABoy4wLDAcBgNVHREEFTATgRFxdWludG9uQGhv
b2xlLmJpejAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBAUAA4GBAL2LROeINIeCqWDjY9lY
Ad/r7l7Z4+2LVKVFlvnKYGCGfmGxlYc1e/c7gTd+hGhBRCUbOElrYz3t/QW815p5HP6bduaP
M2p/XOS9ozO1jfJVykgU/Ju/lWw7Tn8bZTP/FkiW4hEjySCEczqF4qNykrFS24mObxofI2o1
AanHv2GjMIIDPzCCAqigAwIBAgIBDTANBgkqhkiG9w0BAQUFADCB0TELMAkGA1UEBhMCWkEx
FTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTESMBAGA1UEBxMJQ2FwZSBUb3duMRowGAYDVQQKExFU
aGF3dGUgQ29uc3VsdGluZzEoMCYGA1UECxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZp
c2lvbjEkMCIGA1UEAxMbVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIENBMSswKQYJKoZIhvcN
AQkBFhxwZXJzb25hbC1mcmVlbWFpbEB0aGF3dGUuY29tMB4XDTAzMDcxNzAwMDAwMFoXDTEz
MDcxNjIzNTk1OVowYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5n
IChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5n
IENBMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEpjxVc1X7TrnKmVoeaMB1BHCd3+n/
ox7svc31W/Iadr1/DDph8r9RzgHU5VAKMNcCY1osiRVwjt3J8CuFWqo/cVbLrzwLB+fxH5E2
JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTXp6a7n2XRxSpUhQ9IBH+nttE8YQRAHmQZcmC3+wID
AQABo4GUMIGRMBIGA1UdEwEB/wQIMAYBAf8CAQAwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDov
L2NybC50aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFsRnJlZW1haWxDQS5jcmwwCwYDVR0PBAQD
AgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTEzODANBgkqhkiG
9w0BAQUFAAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82L8D0HFAg
k3A8/a3hYWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr394fWxghO
rvbqNOUQGls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCAzswggM3AgEBMGkwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAgMOW3UwCQYFKw4DAhoFAKCC
AacwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDUwNjAyMDcz
MTQyWjAjBgkqhkiG9w0BCQQxFgQU7o0t9hrrzOgzMtoTBSrpPPtCaG4wUgYJKoZIhvcNAQkP
MUUwQzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgweAYJKwYBBAGCNxAEMWswaTBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECAw5bdTB6BgsqhkiG9w0BCRACCzFroGkwYjEL
MAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAgMOW3UwDQYJKoZI
hvcNAQEBBQAEggEABeatb4mYHIEKS9k1/pBO8RRex0/aDdO/B+3b3WZh04KXS+KRB2O1Noo6
E8zbEmNcu07cpGX89fI4CM5yvR+oN35uo6L2ayAFG8qhDXGhiQO/BSP9XOm2wsfGWDuxXYu2
v75Ru9lR5xQeEuQlA1V1vwZm7vD1L/4eeMpSLglOb6pNBpEiJHjCexyj81/jKm6Zcskjcicj
fqR2JQEGB8UB3ZY+cfF/mSQBcPg9REHYPnk6fq+sZo3nRixTKWQUkQkLDhIrn1r5g5G7/Lih
xeMfZWg+MBu5RoGXGPuPAIA96cx+gw8opV+rTJDmqAKPAGpWTQfzR+qnWguUE/xPLCxCSgAA
AAAAAA==
--------------ms000300080707060209040800--
