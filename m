From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH RESEND] Add element count to hash headers
Date: Tue, 03 Mar 2015 21:34:06 -0600
Message-ID: <54F67D2E.5050003@akamai.com>
References: <1424289208-6164-1-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000203030500050400010704"
Cc: Eric B Munson <emunson@akamai.com>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay08.akamai.com ([96.6.114.112]:44628 "EHLO
	prod-mail-xrelay08.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757189AbbCDDeI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 22:34:08 -0500
In-Reply-To: <1424289208-6164-1-git-send-email-emunson@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000203030500050400010704
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 02/18/2015 01:53 PM, Eric B Munson wrote:
> It would be useful for userspace to query the size of an ipset hash,
> however, this data is not exposed to userspace outside of counting the
> number of member entries.  This patch uses the attribute
> IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
> exported to userspace.  This field is then printed by the userspace
> tool for hashes.
>
> Because it is only meaningful for hashes to report their size, the
> output is conditional on the set type.  To do this checking the
> MATCH_TYPENAME macro was moved to utils.h.
>
> Signed-off-by: Eric B Munson <emunson@akamai.com>
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Josh Hunt <johunt@akamai.com>
> ---
>   include/libipset/utils.h                     |  3 +++
>   kernel/net/netfilter/ipset/ip_set_hash_gen.h |  3 ++-
>   lib/errcode.c                                |  2 --
>   lib/session.c                                | 14 ++++++++++++--
>   4 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/include/libipset/utils.h b/include/libipset/utils.h
> index 3cd29da..ceedd45 100644
> --- a/include/libipset/utils.h
> +++ b/include/libipset/utils.h
> @@ -19,6 +19,9 @@
>   #define STRCASEQ(a, b)		(strcasecmp(a, b) =3D=3D 0)
>   #define STRNCASEQ(a, b, n)	(strncasecmp(a, b, n) =3D=3D 0)
>
> +/* Match set type names */
> +#define MATCH_TYPENAME(a, b)    STRNEQ(a, b, strlen(b))
> +
>   /* Stringify tokens */
>   #define _STR(c)			#c
>   #define STR(c)			_STR(c)
> diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/=
netfilter/ipset/ip_set_hash_gen.h
> index 885105b..2000a20 100644
> --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1040,7 +1040,8 @@ mtype_head(struct ip_set *set, struct sk_buff *sk=
b)
>   		goto nla_put_failure;
>   #endif
>   	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) |=
|
> -	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
> +	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
> +	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(h->elements)))
>   		goto nla_put_failure;
>   	if (unlikely(ip_set_put_flags(skb, set)))
>   		goto nla_put_failure;
> diff --git a/lib/errcode.c b/lib/errcode.c
> index 8eb275b..3881121 100644
> --- a/lib/errcode.c
> +++ b/lib/errcode.c
> @@ -148,8 +148,6 @@ static const struct ipset_errcode_table list_errcod=
e_table[] =3D {
>   	{ },
>   };
>
> -#define MATCH_TYPENAME(a, b)	STRNEQ(a, b, strlen(b))
> -
>   /**
>    * ipset_errcode - interpret a kernel error code
>    * @session: session structure
> diff --git a/lib/session.c b/lib/session.c
> index 013d9d8..07f3396 100644
> --- a/lib/session.c
> +++ b/lib/session.c
> @@ -931,6 +931,10 @@ list_create(struct ipset_session *session, struct =
nlattr *nla[])
>   		safe_dprintf(session, ipset_print_number, IPSET_OPT_MEMSIZE);
>   		safe_snprintf(session, "\nReferences: ");
>   		safe_dprintf(session, ipset_print_number, IPSET_OPT_REFERENCES);
> +		if (MATCH_TYPENAME(type->name , "hash:")) {
> +			safe_snprintf(session, "\nNum Entries: ");
> +			safe_dprintf(session, ipset_print_number, IPSET_OPT_ELEMENTS);
> +		}
>   		safe_snprintf(session,
>   			session->envopts & IPSET_ENV_LIST_HEADER ?
>   			"\n" : "\nMembers:\n");
> @@ -940,10 +944,16 @@ list_create(struct ipset_session *session, struct=
 nlattr *nla[])
>   		safe_dprintf(session, ipset_print_number, IPSET_OPT_MEMSIZE);
>   		safe_snprintf(session, "</memsize>\n<references>");
>   		safe_dprintf(session, ipset_print_number, IPSET_OPT_REFERENCES);
> +		safe_snprintf(session, "</references>\n");
> +		if (MATCH_TYPENAME(type->name , "hash:")) {
> +			safe_snprintf(session, "<numentries>");
> +			safe_dprintf(session, ipset_print_number, IPSET_OPT_ELEMENTS);
> +			safe_snprintf(session, "</numentries>\n");
> +		}
>   		safe_snprintf(session,
>   			session->envopts & IPSET_ENV_LIST_HEADER ?
> -			"</references>\n</header>\n" :
> -			"</references>\n</header>\n<members>\n");
> +			"</header>\n" :
> +			"</header>\n<members>\n");
>   		break;
>   	default:
>   		break;
>

Jozsef

Can you clarify what you're looking for when you mentioned (in a=20
previous mail) "I don't like any change which
affects the userspace but not expressed in new set type revision."? Are=20
we breaking ABI here by adding a new field to print out the # of=20
elements in a hash? Would it be better to default this to off and only=20
print it if a new flag were presented?

I guess I don't see why we should rev all of the hash types for this=20
change when we're not really adding any functionality to them. We can=20
rev the ver of the library to signify a change here. Would that help?

If we do need to add a new revision I think we may want to step back and =

make sure there's no other information we want to expose first and if=20
there is do it all in one shot to minimize the # of revisions.

Thanks for your help.
Josh


--------------ms000203030500050400010704
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOOjCC
BjYwggUeoAMCAQICChsbaFcAAAAAAAQwDQYJKoZIhvcNAQEFBQAwGDEWMBQGA1UEAxMNQWth
bWFpUEtJUm9vdDAeFw0wOTA2MDMxMzE2MjFaFw0xOTA2MDMxMzI2MjFaMF4xEzARBgoJkiaJ
k/IsZAEZFgNjb20xFjAUBgoJkiaJk/IsZAEZFgZha2FtYWkxFDASBgoJkiaJk/IsZAEZFgRj
b3JwMRkwFwYDVQQDExBBa2FtYWlQS0lJc3N1aW5nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAoqPGGQN5Xz5QhjrAOiR5ZeKJ877eOxX2Ais/T5cLkVeRoJCv18uNcEhuRqbD
l9G47784PzZi8nkjNbblwyXg8ZSweWnz1en5ZeDMdO6XQ8eQrKGMJ2FN70WUbW8uDJRw6oGc
nsLvcFiN3lKRi/RdSSuO649Tkfzq+A9zFcxABosmmYDCSJ1+B6noMarjHG62AjwjPotnJo95
wR7raXs+JRDsBVPXazas8aPduNyN/yBN/ianrjc/AKi2vzRETb98qvv3h2GWdif7nBew1UN2
dIKmImH3AA5djlfpjU4NtP+XCoBHUtaLg7Npi7+GsYLcmB0b63L02cs9QCXA4oOeawIDAQAB
o4IDOjCCAzYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUB+y0jq9nhlSI772zFFdJz4JM
vxQwCwYDVR0PBAQDAgGGMBAGCSsGAQQBgjcVAQQDAgECMCMGCSsGAQQBgjcVAgQWBBSoJ9lb
Qyx7FwMht3LPL4u8ambeJDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAW
gBTYPTvz/hw6QnfgXMovZhPk2qAFDDCCATAGA1UdHwSCAScwggEjMIIBH6CCARugggEXhiJo
dHRwOi8vYWthbWFpcGtpL0FrYW1haVBLSVJvb3QuY3JshjhodHRwOi8vYWthbWFpcGtpLmRm
dzAxLmNvcnAuYWthbWFpLmNvbS9Ba2FtYWlQS0lSb290LmNybIaBtmxkYXA6Ly8vQ049QWth
bWFpUEtJUm9vdCxDTj11c21hMWNhLXBraTAsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNl
cnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9ZnIsREM9YWRzdmM/Y2Vy
dGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlv
blBvaW50MIIBTgYIKwYBBQUHAQEEggFAMIIBPDA7BggrBgEFBQcwAoYvaHR0cDovL2FrYW1h
aXBraS91c21hMWNhLXBraTBfQWthbWFpUEtJUm9vdC5jcnQwUQYIKwYBBQUHMAKGRWh0dHA6
Ly9ha2FtYWlwa2kuZGZ3MDEuY29ycC5ha2FtYWkuY29tL3VzbWExY2EtcGtpMF9Ba2FtYWlQ
S0lSb290LmNydDCBqQYIKwYBBQUHMAKGgZxsZGFwOi8vL0NOPUFrYW1haVBLSVJvb3QsQ049
QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3Vy
YXRpb24sREM9ZnIsREM9YWRzdmM/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNl
cnRpZmljYXRpb25BdXRob3JpdHkwDQYJKoZIhvcNAQEFBQADggEBADkqmsMzAXzel+sFb7Z3
lFZ3uydL4mgSW5taIvqlvy7gAFfWaAgkurkKqzDSVT4TRGH7eJP1yVK/L2R6oII4e6NlJFM1
iyD+AFhPR7qVzOAnrDlJD/v9q0JZBNDvNQSSApRMHQ0VYRuMC1HruQexFvqDBoqjJ1oEGYWt
hlOt+sLWXwqQxBILOGt0vcsUx/QJX3FRhLjEri+aO0XVBdRaNiZyB50kmhNelgWRPT5OsDuz
17HVVF6R8KpDzOKCJ1nS/eUxW9nkxH0E5/BC2Q0IMP9TGxKs4j8qKTW2gbqOBDekUsWFDgvv
6HJlYSDJNwqy0j38ANOSuw0LPg6v6nLsDx0wggf8MIIG5KADAgECAgoTYXOLAAIAAigzMA0G
CSqGSIb3DQEBBQUAMF4xEzARBgoJkiaJk/IsZAEZFgNjb20xFjAUBgoJkiaJk/IsZAEZFgZh
a2FtYWkxFDASBgoJkiaJk/IsZAEZFgRjb3JwMRkwFwYDVQQDExBBa2FtYWlQS0lJc3N1aW5n
MB4XDTE1MDIxMzE4MzExM1oXDTE2MDIwODE4MzExM1owgZoxCzAJBgNVBAYTAlVTMQswCQYD
VQQIEwJMQTEUMBIGA1UEBxMLQmF0b24gUm91Z2UxHDAaBgNVBAoTE0FrYW1haSBUZWNobm9s
b2dpZXMxFzAVBgNVBAsTDkFVVE8tYm9zLWxwd2cxMQ8wDQYDVQQDEwZqb2h1bnQxIDAeBgkq
hkiG9w0BCQEWEWpvaHVudEBha2FtYWkuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAzxQoup1klYJieZ6uN6IMb6lFdHeZGlffdRqOrMeNAy+KSvvPILFyXC1vgC2qUqNg
s5Fd+nxllz2mAy2ZcfUqouAvZ3ZRvl1Vfxjyly8JN79l13s8blmLIv9un5ZYz6+FqfMj2Kw0
BID8hwPtFaXaN6b9VfQFK0+YClcWgD16b2+nNHsk2i3i66PVLenQoevbqyuYdeNeLqy1ii23
e+ArCBPVVlKdfkNM2ESITCxf+QB0+bJvvZAuzUwTE3dCZSjh+OZypbVgxYOmH3s8s47Z6VwB
gG2oNTEvGgOtkHp+djMyVuVw8WbeQ6Sw3rlFiKdH6IifiX3VDDsNgDxgUwpjkwIDAQABo4IE
fTCCBHkwCwYDVR0PBAQDAgWgMDMGA1UdJQQsMCoGCCsGAQUFBwMHBggrBgEFBQcDAgYKKwYB
BAGCNwoDBAYIKwYBBQUHAwQwMQYDVR0RBCowKKAmBgorBgEEAYI3FAIDoBgMFmpvaHVudEBj
b3JwLmFrYW1haS5jb20wHQYDVR0OBBYEFPWmxTJxq6CehFEehJO5GDpqrQDRMB8GA1UdIwQY
MBaAFAfstI6vZ4ZUiO+9sxRXSc+CTL8UMIIBOQYDVR0fBIIBMDCCASwwggEooIIBJKCCASCG
JWh0dHA6Ly9ha2FtYWlwa2kvQWthbWFpUEtJSXNzdWluZy5jcmyGO2h0dHA6Ly9ha2FtYWlw
a2kuZGZ3MDEuY29ycC5ha2FtYWkuY29tL0FrYW1haVBLSUlzc3VpbmcuY3JshoG5bGRhcDov
Ly9DTj1Ba2FtYWlQS0lJc3N1aW5nLENOPXVzbWExY2EtcGtpMSxDTj1DRFAsQ049UHVibGlj
JTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1mcixE
Qz1hZHN2Yz9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JM
RGlzdHJpYnV0aW9uUG9pbnQwggG8BggrBgEFBQcBAQSCAa4wggGqMFkGCCsGAQUFBzAChk1o
dHRwOi8vYWthbWFpcGtpL3VzbWExY2EtcGtpMS5rZW5kYWxsLmNvcnAuYWthbWFpLmNvbV9B
a2FtYWlQS0lJc3N1aW5nKDIpLmNydDBvBggrBgEFBQcwAoZjaHR0cDovL2FrYW1haXBraS5k
ZncwMS5jb3JwLmFrYW1haS5jb20vdXNtYTFjYS1wa2kxLmtlbmRhbGwuY29ycC5ha2FtYWku
Y29tX0FrYW1haVBLSUlzc3VpbmcoMikuY3J0MIGsBggrBgEFBQcwAoaBn2xkYXA6Ly8vQ049
QWthbWFpUEtJSXNzdWluZyxDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049
U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1mcixEQz1hZHN2Yz9jQUNlcnRpZmljYXRl
P2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTAtBggrBgEFBQcwAYYh
aHR0cDovL2FrYW1haW9jc3AuYWthbWFpLmNvbS9vY3NwMDwGCSsGAQQBgjcVBwQvMC0GJSsG
AQQBgjcVCILO5TqHuNQtgYWLB6LjIYbSD4FJhOTfBYGQ+hQCAWQCARswQQYJKwYBBAGCNxUK
BDQwMjAKBggrBgEFBQcDBzAKBggrBgEFBQcDAjAMBgorBgEEAYI3CgMEMAoGCCsGAQUFBwME
MEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUr
DgMCBzAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQUFAAOCAQEAec0NVVWdFyr65dI5+++fSveF
tyfbeT7JhzLTznuJBmHAsAxmKr/kPeXrOkc4Go3KvL9sJ2ONOWBAcMKDqfALHWCdcsRZLLvh
bwaAY4sObcDF0ocrY8Qzs9Qu4W9uxsuHoqxjzShsmiTEQge0314XEi1f9YxhJei7JZKNUaUo
tAJSx1DwaczB4hCdZJFQY+5fp9uw4bQ/yFNojd8/MqUBPtoUNCV3Oi5DPDisGyKHBLAydkrT
9b1Nxr29D5iHzytvrVsqGRyMFwiUJwh3DVy0bW6Lrre5vYt1oT2+Ti5N0FYYSN4w0jjxifZt
Ww9KODGYudRDweuNPQVoVpcLQB0rUjGCA14wggNaAgEBMGwwXjETMBEGCgmSJomT8ixkARkW
A2NvbTEWMBQGCgmSJomT8ixkARkWBmFrYW1haTEUMBIGCgmSJomT8ixkARkWBGNvcnAxGTAX
BgNVBAMTEEFrYW1haVBLSUlzc3VpbmcCChNhc4sAAgACKDMwCQYFKw4DAhoFAKCCAccwGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMzA0MDMzNDA2WjAj
BgkqhkiG9w0BCQQxFgQUoGikAUq+HaZtt8bLkG+719wVgYowbAYJKoZIhvcNAQkPMV8wXTAL
BglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDAN
BggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDB7BgkrBgEEAYI3EAQxbjBs
MF4xEzARBgoJkiaJk/IsZAEZFgNjb20xFjAUBgoJkiaJk/IsZAEZFgZha2FtYWkxFDASBgoJ
kiaJk/IsZAEZFgRjb3JwMRkwFwYDVQQDExBBa2FtYWlQS0lJc3N1aW5nAgoTYXOLAAIAAigz
MH0GCyqGSIb3DQEJEAILMW6gbDBeMRMwEQYKCZImiZPyLGQBGRYDY29tMRYwFAYKCZImiZPy
LGQBGRYGYWthbWFpMRQwEgYKCZImiZPyLGQBGRYEY29ycDEZMBcGA1UEAxMQQWthbWFpUEtJ
SXNzdWluZwIKE2FziwACAAIoMzANBgkqhkiG9w0BAQEFAASCAQCV9NOH9GJWnJb8DG9dMdHo
DMrxv+tjSavextfi5Ah9TOw8M/XkaibjW1NEc2FYtfjmEWTctf/AfICgiepq2dLEwac9FOMr
QhWPLH4gsYfZjw79q8wFHV0iJ3bETr4drIUrYW5S8AWAiVBfrRRpmayXKNcVtdkV0IR4lWjT
TKEFLetIIDnylQ1adV6H1VAfqi0KRdBZiKv7Fa/dU1x0pqblwTqqtsLi9jBHN2nVfzsaKAWG
WeDsFQGv13wddpch21B0I5GUVW9Y7rT6049LW3aitlqvZs3sZe6ru4OLCs53/dm0acVBov3G
s4bvc4tKq9JyqocEKmnd75UeeHsAXyoTAAAAAAAA
--------------ms000203030500050400010704--
