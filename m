From: Jean-Michel DILLY <jm@dilly.me>
Subject: Re: [RFC PATCH 1/4] netfilter: ip6t_NPT: Fix checksuming.
Date: Sun, 3 Feb 2013 23:31:36 +0100
Message-ID: <7A8FC7E1-A45C-4805-B91C-FB144C3EF41C@dilly.me>
References: <5104227C.3030306@linux-ipv6.org> <5107DFDF.4050504@gmail.com> <20130131100417.GA6358@localhost> <510A94D6.40407@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: multipart/signed; boundary="Apple-Mail=_88F5C3F1-491F-438C-85EB-D4328943F3B9"; protocol="application/pkcs7-signature"; micalg=sha1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
To: Ulrich Weber <ulrich.weber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.dillydally.fr ([87.98.128.188]:47093 "EHLO
	mail.dillydally.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab3BCWbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:31:41 -0500
In-Reply-To: <510A94D6.40407@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Apple-Mail=_88F5C3F1-491F-438C-85EB-D4328943F3B9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

Looks good from here. :)

Regards,
JMichel DILLY

Le 31 janv. 2013 =E0 16:59, Ulrich Weber a =E9crit :

> =46rom my side, apply yoshofuji patches and my
> onces complement patch, that worked for me ;)
>=20
> I can do some more testing tomorrow with different
> addresses and ranges if nobody else finds time...
>=20
> Cheers
> Ulrich
>=20
>=20
> On 01/31/13 11:04, Pablo Neira Ayuso wrote:
>> Hi,
>>=20
>> On Tue, Jan 29, 2013 at 03:42:39PM +0100, Ulrich Weber wrote:
>>> Hi Yoshofuji,
>>>=20
>>> thanks for your patches! If I add a onces complement
>>> to the return value of csum_fold() it works for my setup.
>> Any consensus on the fix for this? I'd like to have some solution =
into
>> 3.8-rc.
>>=20
>> Thanks.
>>=20
>>> On 01/26/13 19:37, YOSHIFUJI Hideaki wrote:
>>>> Cast __wsum from/to __sum16 is wrong.  Instead, apply appropriate
>>>> conversion function: csum_unfold() or csum_fold().
>>>>=20
>>>> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
>>>> ---
>>>>  net/ipv6/netfilter/ip6t_NPT.c |    6 +++---
>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>=20
>>>> diff --git a/net/ipv6/netfilter/ip6t_NPT.c =
b/net/ipv6/netfilter/ip6t_NPT.c
>>>> index 7302b0b..3ff281b 100644
>>>> --- a/net/ipv6/netfilter/ip6t_NPT.c
>>>> +++ b/net/ipv6/netfilter/ip6t_NPT.c
>>>> @@ -30,7 +30,7 @@ static int ip6t_npt_checkentry(const struct =
xt_tgchk_param *par)
>>>>  				(__force =
__wsum)npt->dst_pfx.in6.s6_addr16[i]);
>>>>  	}
>>>>  -	npt->adjustment =3D (__force __sum16) csum_sub(src_sum, =
dst_sum);
>>>> +	npt->adjustment =3D csum_fold(csum_sub(src_sum, dst_sum));
>>>>  	return 0;
>>>>  }
>>>>  @@ -66,8 +66,8 @@ static bool ip6t_npt_map_pfx(const struct =
ip6t_npt_tginfo *npt,
>>>>  			return false;
>>>>  	}
>>>>  -	sum =3D (__force __sum16) csum_add((__force =
__wsum)addr->s6_addr16[idx],
>>>> -			 npt->adjustment);
>>>> +	sum =3D csum_fold(csum_add(csum_unfold((__force =
__sum16)addr->s6_addr16[idx]),
>>>> +				 csum_unfold(npt->adjustment)));
>>>>  	if (sum =3D=3D CSUM_MANGLED_0)
>>>>  		sum =3D 0;
>>>>  	*(__force __sum16 *)&addr->s6_addr16[idx] =3D sum;
>>> =46rom 40e0c6d86514a8dcc80f18fbe8a2945c6ee78f6d Mon Sep 17 00:00:00 =
2001
>>> From: Ulrich Weber <ulrich.weber@sophos.com>
>>> Date: Tue, 29 Jan 2013 15:24:21 +0100
>>> Subject: [PATCH] netfilter: ip6t_NTP: Use onces complement of =
csum_fold
>>>=20
>>> we need a 16bit value but not folded
>>>=20
>>> Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
>>> ---
>>>  net/ipv6/netfilter/ip6t_NPT.c |    6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>=20
>>> diff --git a/net/ipv6/netfilter/ip6t_NPT.c =
b/net/ipv6/netfilter/ip6t_NPT.c
>>> index 74e171d..61a9b95 100644
>>> --- a/net/ipv6/netfilter/ip6t_NPT.c
>>> +++ b/net/ipv6/netfilter/ip6t_NPT.c
>>> @@ -35,7 +35,7 @@ static int ip6t_npt_checkentry(const struct =
xt_tgchk_param *par)
>>>  	src_sum =3D csum_partial(&npt->src_pfx.in6, =
sizeof(npt->src_pfx.in6), 0);
>>>  	dst_sum =3D csum_partial(&npt->dst_pfx.in6, =
sizeof(npt->dst_pfx.in6), 0);
>>>  -	npt->adjustment =3D csum_fold(csum_sub(src_sum, dst_sum));
>>> +	npt->adjustment =3D ~csum_fold(csum_sub(src_sum, dst_sum));
>>>  	return 0;
>>>  }
>>>  @@ -71,8 +71,8 @@ static bool ip6t_npt_map_pfx(const struct =
ip6t_npt_tginfo *npt,
>>>  			return false;
>>>  	}
>>>  -	sum =3D csum_fold(csum_add(csum_unfold((__force =
__sum16)addr->s6_addr16[idx]),
>>> -				 csum_unfold(npt->adjustment)));
>>> +	sum =3D ~csum_fold(csum_add(csum_unfold((__force =
__sum16)addr->s6_addr16[idx]),
>>> +				  csum_unfold(npt->adjustment)));
>>>  	if (sum =3D=3D CSUM_MANGLED_0)
>>>  		sum =3D 0;
>>>  	*(__force __sum16 *)&addr->s6_addr16[idx] =3D sum;
>>> --=20
>>> 1.7.9.5
>>>=20
>=20


--Apple-Mail=_88F5C3F1-491F-438C-85EB-D4328943F3B9
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINOzCCBjQw
ggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAn
BgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3MTAyNDIxMDE1NVoX
DTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSsw
KQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFy
dENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOrlr6KMoOMpohBllVHrdRvEg/q6r8jR+EK
75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSMzR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC
+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxD
z2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSDkOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr
/+N2JLKutIxMYqQOJebr/f/h5t95m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0w
ggGpMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFc
fH6WNU7y1LhRgjAfBgNVHSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRa
MFgwJwYIKwYBBQUHMAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYh
aHR0cDovL3d3dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5j
b20vc2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqDCH14qywG
XLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy6QMVQjbbMXlt
UfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPIzKKR9tQW8gGK+2+R
HxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKfKSETEPrHh7p5shuuNktv
sv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HORz9v3vQwR4e3ksLc2JZOAFK+s
sS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9sIPP7ON0fz095HdThKjiVJe6vofq
+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCieuoBJ9OlqmsVWQvifIYf40dJPZkk9YgGT
zWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7tw1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGq
Up/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQG2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb1
9mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIG/zCCBeeg
AwIBAgIDBTcDMA0GCSqGSIb3DQEBBQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYG
A1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcN
MTIxMDMxMTU1MDA2WhcNMTMxMTAxMjI0MzEzWjBNMRkwFwYDVQQNExBSNlpjc09UaFV3OUVUakZZ
MRQwEgYDVQQDDAtqbUBkaWxseS5tZTEaMBgGCSqGSIb3DQEJARYLam1AZGlsbHkubWUwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC7ZFr7S1a9/E9tFyIKx5H4Az7VfJXVZo7ldyxPL04V
Dip7A3UHVvt5TAC5TS3pN+PfuhHBk3YQ8Ed7POnU3IoFb5072cRY/M1lEXOzyoKvuVXtGbeBvs52
XEYALj1hjeOTL5t2CMkf3+SGZiQODsG6qog7hHrL3yh4s9m7htRIh9YCtvkOj6qHZT8sG+vi3WOK
cN42ZaQoSkCKTtAq/2AQPOyyp6e/RVrpwoCdkcGq9aU67utQ8W+4n1/Q9wsN6S1mXYTiFxLPXBaM
+jaF2A+B6f7czdd5EfOsH3wXDYFFzIp254q38vxILpYIHQm874xHXqlBP7OmTm5OC0ZoaJOXAgMB
AAGjggOmMIIDojAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwHQYDVR0OBBYEFBH3QiHt6HLD++agj7rqpy0C0s/iMB8GA1UdIwQYMBaAFFNy7ZKc
4NrLAVx8fpY1TvLUuFGCMBYGA1UdEQQPMA2BC2ptQGRpbGx5Lm1lMIICIQYDVR0gBIICGDCCAhQw
ggIQBgsrBgEEAYG1NwECAjCCAf8wLgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29t
L3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL2ludGVybWVk
aWF0ZS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9y
aXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBD
bGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ks
IHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2Yg
dGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMIGcBggrBgEFBQcCAjCBjzAnFiBTdGFydENv
bSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgECGmRMaWFiaWxpdHkgYW5kIHdhcnJhbnRpZXMg
YXJlIGxpbWl0ZWQhIFNlZSBzZWN0aW9uICJMZWdhbCBhbmQgTGltaXRhdGlvbnMiIG9mIHRoZSBT
dGFydENvbSBDQSBwb2xpY3kuMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wu
Y29tL2NydHUxLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9v
Y3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MxL2NsaWVudC9jYTBCBggrBgEFBQcwAoY2aHR0cDov
L2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMS5jbGllbnQuY2EuY3J0MCMGA1UdEgQc
MBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG9w0BAQUFAAOCAQEAjig6RVvx7JVV
+gN9p/0/9GKNeeKH3WsSqTXKFODqKH8ca2PgkpnT97rZm7o0q8TV7qGRE7rUqDT969NEAQJV5HGE
kTnCA+CS1dGmXOyV4T7LA0vq1uHrjZC8oxabhmFx18GXDg3XWkJ8R7E9u2nfaznlxhf+y/V5xw1n
gWQtOzZV03CUbYQyyy7V5c/eiHt6b08yhgbCgfJHuE5BSeS9CBcxn5fayqQjJTT/Jltj6W2UZeEN
mOqgCxq0Z7hwMcuyuSWYNE4N2FIVeKNciswC9J0CqkCZWOwQpHXK6ik2krcpzjbyk/2wTLkQvZe5
j0sxpOGXDrxOHRE25JD1q5P+rjGCA28wggNrAgEBMIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UE
ChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2ln
bmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGll
bnQgQ0ECAwU3AzAJBgUrDgMCGgUAoIIBrzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0xMzAyMDMyMjMxMzZaMCMGCSqGSIb3DQEJBDEWBBQfhZzvDq1eDrktWsn+wFLI
9lR6CDCBpQYJKwYBBAGCNxAEMYGXMIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYG
A1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwU3
AzCBpwYLKoZIhvcNAQkQAgsxgZeggZQwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYD
VQQDEy9TdGFydENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQIDBTcD
MA0GCSqGSIb3DQEBAQUABIIBALbe2g+3CKNqfYRp4zeq3dlfY19Hnk1q6/2Ei3ejYfxMsFMhj4D1
SGDve1qzeUq23+UbZ29GgeOh+28PP9xndOfKsoCHjkWKfCc1R5a3b7sy6wd0Hl2+M1mDW5f0kRTt
VlAsVsHmF5I5aTaqxQgHKG7MLtmpr+LiH/bOszgfhdQWaIyNGe65N3JUNVhdscaqzJUm5btKomAO
KlIHQh63yDHjnXz2Uu+tA6LDBQoj+aJikGTy//mEiTqKYqAXOmCQgbydgjqtpSfC48REYPrnof7v
Gr0ZF+8JMcPOKVHdbOxrMwDLq/7blvw5da9oULO5qoNyABae7PeLQ04NS6QvQyEAAAAAAAA=

--Apple-Mail=_88F5C3F1-491F-438C-85EB-D4328943F3B9--
