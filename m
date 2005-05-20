From: Quinton Hoole <quinton@hoole.biz>
Subject: Re: Mangling IP Options fields
Date: Fri, 20 May 2005 15:47:00 +0200
Message-ID: <428DEA54.40803@hoole.biz>
References: <42889454.6040300@hoole.biz> <4288E9D7.10306@outerspace.dyndns.org>
	<428C8D66.3030908@hoole.biz> <428DC758.7060503@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha1; boundary="------------ms020501080207030808050509"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <428DC758.7060503@ufomechanic.net>
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

--------------ms020501080207030808050509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry - turns out I was using an old patch-o-matic.  Once  got the right 
one, everything worked fine.

Q

Amin Azez wrote:

> Apologies if these comments (below) seem obvious:
>
> Quinton Hoole wrote:
>
>> Warning - no help text file could be found in either
>> /usr/src/linux/net/ipv4/netfilter/Config.help
>> or /usr/src/linux/Documentation/Configure.help
>> fgrep: /usr/src/linux/net/ipv4/netfilter/Config.in: No such file or 
>> directory
>
> ...
>
>> I installed the kernel source RPM according to the instructions in 
>> the FC3  (http://fedora.redhat.com/docs/release-notes/fc3/x86/), 
>> which places  the kernel source in
>>
>> /usr/src/redhat/BUILD/kernel-2.6.11/linux-2.6.11
>>
>> For convenience I  created a symbolic link from /usr/src/linux to the 
>> above.
>
>
> So, do:
> ls -l /usr/src/linux/net/ipv4/netfilter
> and see what you get, if it doesn't work then you may need to adjust 
> your symbolic link to point to 
> /usr/src/redhat/BUILD/kernel-2.6.11/linux-2.6.11/somewhereelse
>
> I presume there is a net folder somewhere under 
> /usr/src/redhat/BUILD/kernel-2.6.11/linux-2.6.11?
>
> It is the folder that includes this net folder that needs to be 
> symlinked to /usr/src/linux.
>
> Sam
>
>

--------------ms020501080207030808050509
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
AacwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDUwNTIwMTM0
NzAwWjAjBgkqhkiG9w0BCQQxFgQUj9OxuQfWWSLFa5vCCJQHSwwXgL4wUgYJKoZIhvcNAQkP
MUUwQzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgweAYJKwYBBAGCNxAEMWswaTBiMQswCQYDVQQGEwJaQTElMCMG
A1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBl
cnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECAw5bdTB6BgsqhkiG9w0BCRACCzFroGkwYjEL
MAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAgMOW3UwDQYJKoZI
hvcNAQEBBQAEggEAIjbHUtAFuyhzvtxLu12Yz9P8FLbuSiq9kqlcsxgnK/EUKxtySyq3OyBy
Z2kiRfE6vuz1T/Do2kOJcjDV92FqLFEpfaSpDxK0gjNDGxG3kFxN4Y+IIerrLjWOuNxA8xUQ
hqJ6+GF7pWGPdXHbdy/PFsZKtJ5DIufUkPsL8JywnrZRDwQXS4+XC1Nv8mptaBWKX+v90KF6
bILXO7RjUPoiXjLNCWGik78/5rYJqKWZHMCBzzPQwNrYpPKQcAm/Poqa8XXW+p1ZRyNA36Xe
2uWkWUn6lY8ZBcGVr2ObSTqShN57SA61Uy2VwQWggyrEETlyAHNB8xX4lZ3d/zzM6NVivgAA
AAAAAA==
--------------ms020501080207030808050509--
