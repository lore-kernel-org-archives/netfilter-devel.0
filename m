From: Quinton Hoole <quinton@hoole.biz>
Subject: Mangling IP Options fields
Date: Mon, 16 May 2005 14:38:44 +0200
Message-ID: <42889454.6040300@hoole.biz>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms030705060501070900060301"
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

--------------ms030705060501070900060301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi

I've posted this to the netfilter users list, but in retrospect it is 
probably a devel question:

This newbie needs to add and/or rewrite data in the IP Options fields.
The MANGLE chain looks like the place to do this, but I don't see the
appropriate target extensions to achieve it.  It seems easy to mangle
most other fields (DSCP, ECN, TOS, TTL etc) but no mention of the
OPTIONS fields.

Is mangling of IP options fields supported by netfilter/iptables?

I've seen Fabrice's reply to a simimlar question some 3 years back:

https://lists.netfilter.org/pipermail/netfilter-devel/2002-March/006957.html

which indicates that I'll need to do some hacking, but hopefully this 
has changed since then, and someone's done it for me ;-)

If not, I'm going to have to make it happen some how.  Any pointers
towards the recommended approach in this regard would be appreciated.
I'm assuming that I'll have to alter the netfilter/iptables code
appropriately, which is not a problem.  I'll start ploughing through the 
patch-o-matic docs in the mean time ;-)

Thanks in advance...

Quinton

--------------ms030705060501070900060301
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
AacwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDUwNTE2MTIz
ODQ0WjAjBgkqhkiG9w0BCQQxFgQUKEZlSXcBs9xi/nQRfi6frelrTGAwUgYJKoZIhvcNAQkP
MUUwQzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgweAYJKwYBBAGCNxAEMWswaTBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECAw5bdTB6BgsqhkiG9w0BCRACCzFroGkwYjEL
MAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAgMOW3UwDQYJKoZI
hvcNAQEBBQAEggEAl6nDkMShEhyNDQ97mDRqDC+u8R74dXGRAIMbbVUdN0eF4YPU3GMuLw4w
YDL0QKJXClOXvwbl4N2TP/7ZA+3axEi7/iuk8DjtkJpqARQaykvmU/rcgQbr+G2sUkUP4p7/
R523hiRlX1y5ZppFwWnscup2TH1iS4bnsyBKb0rIbZB7UtYeGYd4HG26ndbYoG6rrk/IpWy4
RCxGbpBl+MmWnfW6MryvTRy/KFStHF9RGz3yzxNCZa42J/Y3a8/AP6prXilDBAFaS5eMvQIm
g5XabQxogmM91HxcffqB/VMcHfE4t5o4oalton6Pjdb2BFmNHJgb58vhWXyA28IvBteqMwAA
AAAAAA==
--------------ms030705060501070900060301--
