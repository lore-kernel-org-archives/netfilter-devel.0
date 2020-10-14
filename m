Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963F2C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 12:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266CA20848
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 12:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=orange.com header.i=@orange.com header.b="amWvu0nh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387895AbgJNMof (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 08:44:35 -0400
Received: from relais-inet.orange.com ([80.12.70.34]:30335 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgJNMof (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 08:44:35 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2020 08:44:09 EDT
Received: from opfednr04.francetelecom.fr (unknown [xx.xx.xx.68])
        by opfednr21.francetelecom.fr (ESMTP service) with ESMTP id 4CBBjY5ftrz5wcp;
        Wed, 14 Oct 2020 14:36:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1602678977;
        bh=yLOl+3a0QfEkhIAkH15hxs5ueFmCw6wqgrguwCAHEyM=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=amWvu0nhL9OnrWKM0G/ZVcC3VlSEd0yI8pqOGsV5DUr5SijGBuXfBw47C65LFYSwA
         jpb8yXPHKtslbelgk9qKw/xEkP5W4L594W2vENC7OPGCirfMFgDK617eg4pJsJCE0c
         vbujAfb/sTtrMeYZRb63jO0dKyNYQhug6M26W7CdlpyBxWdGcVpltRwEe5i4FAbJG4
         APysecTzWwHN7FA/L39j/iFzamFeAWaxlAP4d1PhgmkC8xPriZTaDhyKbvQtvfdn+U
         Bdgi9NH+TjskDu2X5YU9FZc4Bg3M7cZ5heWEYxxhfhwiZ6Lb2MdsWwSu+G15tmp/OQ
         yDl1OXkdlS0SA==
Received: from Exchangemail-eme6.itn.ftgroup (unknown [xx.xx.13.38])
        by opfednr04.francetelecom.fr (ESMTP service) with ESMTP id 4CBBjY3hJyz1xpn;
        Wed, 14 Oct 2020 14:36:17 +0200 (CEST)
From:   <timothee.cocault@orange.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: [PATCH] Fixes dropping of small packets in bridge nat
Thread-Topic: [PATCH] Fixes dropping of small packets in bridge nat
Thread-Index: AdaiJfnLCbqjhfLJSFW6PuhIUoGIhg==
Date:   Wed, 14 Oct 2020 12:36:15 +0000
Message-ID: <585B71F7B267D04784B84104A88F7DEE0DB503A6@OPEXCAUBM34.corporate.adroot.infra.ftgroup>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.114.13.245]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=SHA1; boundary="----=_NextPart_000_0000_01D6A237.5E474B80"
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

------=_NextPart_000_0000_01D6A237.5E474B80
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Fixes an error causing small packets to get dropped. skb_ensure_writable
expects the second parameter to be a length in the ethernet payload.=20
If we want to write the ethernet header (src, dst), we should pass 0.
Otherwise, packets with small payloads (< ETH_ALEN) will get dropped.

Signed-off-by: Timoth=E9e COCAULT <timothee.cocault@orange.com>
---
 net/bridge/netfilter/ebt_dnat.c     | 2 +-
 net/bridge/netfilter/ebt_redirect.c | 2 +-
 net/bridge/netfilter/ebt_snat.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c
b/net/bridge/netfilter/ebt_dnat.c
index 12a4f4d93681..3fda71a8579d 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -21,7 +21,7 @@ ebt_dnat_tg(struct sk_buff *skb, const struct
xt_action_param *par)
 {
 	const struct ebt_nat_info *info =3D par->targinfo;
=20
-	if (skb_ensure_writable(skb, ETH_ALEN))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
=20
 	ether_addr_copy(eth_hdr(skb)->h_dest, info->mac);
diff --git a/net/bridge/netfilter/ebt_redirect.c
b/net/bridge/netfilter/ebt_redirect.c
index 0cad62a4052b..307790562b49 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -21,7 +21,7 @@ ebt_redirect_tg(struct sk_buff *skb, const struct
xt_action_param *par)
 {
 	const struct ebt_redirect_info *info =3D par->targinfo;
=20
-	if (skb_ensure_writable(skb, ETH_ALEN))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
=20
 	if (xt_hooknum(par) !=3D NF_BR_BROUTING)
diff --git a/net/bridge/netfilter/ebt_snat.c
b/net/bridge/netfilter/ebt_snat.c
index 27443bf229a3..7dfbcdfc30e5 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -22,7 +22,7 @@ ebt_snat_tg(struct sk_buff *skb, const struct
xt_action_param *par)
 {
 	const struct ebt_nat_info *info =3D par->targinfo;
=20
-	if (skb_ensure_writable(skb, ETH_ALEN * 2))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
=20
 	ether_addr_copy(eth_hdr(skb)->h_source, info->mac);
--=20
2.25.1


------=_NextPart_000_0000_01D6A237.5E474B80
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
Qz1GUoIBADB8BgNVHR8EdTBzMDOgMaAvhi1odHRwOi8vcGtpLWNybC5pdG4uZnRncm91cC9jcmwv
aWdjZ2Z0X3JjYS5jcmwwPKA6oDiGNmh0dHA6Ly9pZ2NnZnQtcmNhLmZyYW5jZXRlbGVjb20uY29t
L2NybC9pZ2NnZnRfcmNhLmNybDBKBgNVHSAEQzBBMD8GByqBegEQDAIwNDAyBggrBgEFBQcCARYm
aHR0cDovL2lnY2dmdC1yY2EuZnJhbmNldGVsZWNvbS5jb20vcGMwDQYJKoZIhvcNAQEFBQADggEB
AAYnlAZbNOHSm110Res4plYBlKidMGviiMNUD6x/Ffgx5wAHq2ze+fxSJ9OFB5VoppVYxr+rH3ys
eTSpIEGyj6rrlBc5wA9mrH8mOyBJvYrUprWyjmxi8c7FA9vHv5Np1/ARHl/Pwlyp3bBY/Sol6ltH
lclR1lVtOSsjrRrch2C+THDcg+axS5Uu+RLofzxio9W159rjLnRku2UgTyZr7bkeI5BnTw35MmfI
cJ3yvDZ91rduKPCLwm0UZHaoIm8FM8R5sxl6Bs0oheoKcY7T/RZ8HLVdPXGntKu9PPFm5sOEAV/f
R3OsIQcUsEFUtYwqqkYpoxWXKF2ggfM2boaBWE0wggbJMIIFsaADAgECAhIRIYAWX66y/DCnj9JS
U8GHVPQwDQYJKoZIhvcNAQEFBQAwgZYxCzAJBgNVBAYTAkZSMRowGAYDVQQKDBFGcmFuY2UgVGVs
ZWNvbSBTQTEkMCIGA1UECwwbV2VzdGVybkVVIE1pZGRsZUVhc3QgQWZyaWNhMRcwFQYDVQQLDA4w
MDAyIDM4MDEyOTg2NjEsMCoGA1UEAwwjR3JvdXBlIEZyYW5jZSBUZWxlY29tIEludGVybmFsIENB
IDEwHhcNMTgxMTI4MDkyMDA5WhcNMjIxMTI4MDkyMDA5WjBwMQswCQYDVQQGEwJGUjEaMBgGA1UE
ChMRRnJhbmNlIFRlbGVjb20gU0ExGTAXBgNVBAMMEENvY2F1bHQgVGltb3RoZWUxKjAoBgkqhkiG
9w0BCQEMG3RpbW90aGVlLmNvY2F1bHRAb3JhbmdlLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAMY3eXynHtaqp+PJ61eWE9j+du9iqfZ+FSCuMo88UPlwgkfT345ScvFr1236+XuC
2/CCY02CPA/6CVgO/YBM583SswIVwwHFgSSL3z7z6GrFBcIcjrJ5+xqLOqHXOOa9ekQEhDmyK/oS
J5ugR2LgKRj4Wg+5bEMFTN9GSaYjA7Y6iNg9pZ4E3qbzveEBF9/IQO2SBdjUab3VvV9fVjfD4v7a
e58tNvRznFxYS9W6DAp2t2TPpl9dXqU3++gybYIT9m4gBmmubzxnD1YHUjlaUMnmzk3Y5Hp53hrn
tj6K3TSYVzvHeuzWlgjvwW39+a3JszRV9r5ZP1pPrmqO2nu9k/8CAwEAAaOCAzQwggMwMA4GA1Ud
DwEB/wQEAwIFIDATBgNVHSUEDDAKBggrBgEFBQcDBDAmBgNVHREEHzAdgRt0aW1vdGhlZS5jb2Nh
dWx0QG9yYW5nZS5jb20wggIhBgNVHR8EggIYMIICFDCB6KCB5aCB4oaB32xkYXA6Ly8vY249R3Jv
dXBlJTIwRnJhbmNlJTIwVGVsZWNvbSUyMEludGVybmFsJTIwQ0ElMjAxLGNuPWlnY2dmdGksQ049
Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRp
b24sREM9YWQsREM9ZnJhbmNldGVsZWNvbSxEQz1mcj9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
P2Jhc2U/b2JqZWN0Y2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgamggaaggaOGgaBsZGFwOi8v
aWdjZ2Z0aS1jYTEtbGRhcC5zaS5mcmFuY2V0ZWxlY29tLmZyL291PWlnY2dmdGlfY2ExLG91PUNB
LG91PUNSTERQLG91PUFDX09OLG91PUlHQ0dyb3VwZSxvPUZyYW5jZVRlbGVjb20/Y2VydGlmaWNh
dGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdGNsYXNzPXBraUNhMDSgMqAwhi5odHRwOi8vcGtp
LWNybC5pdG4uZnRncm91cC9jcmwvaWdjZ2Z0aV9jYTEuY3JsMEWgQ6BBhj9odHRwOi8vaWdjZ2Z0
aS1jYTEtaHR0cC5zaS5mcmFuY2V0ZWxlY29tLmZyL2NybC9pZ2NnZnRpX2NhMS5jcmwwPgYDVR0g
BDcwNTAzBggqgXoBEAwCAjAnMCUGCCsGAQUFBwIBFhlodHRwOi8vcGtpLW9yYW5nZS5jb20vY3Bz
MDwGCCsGAQUFBwEBBDAwLjAsBggrBgEFBQcwAYYgaHR0cDovL3BraS1vY3NwLml0bi5mdGdyb3Vw
L29jc3AwHQYDVR0OBBYEFO+/+v7bNVA50ol4BkoEfvaMfH5ZMB8GA1UdIwQYMBaAFDYcM2fTE1z6
W5/qi7pEZnRG8Xd4MA0GCSqGSIb3DQEBBQUAA4IBAQCjROratSUe9DwXXGw/YWbAm5Jp6RgeZxTp
kWPA76745PJkXRO5u4zFlP0t8RzFCjLLpwhT9jGTJBeKFpj6bcBmHPutl0g6HBgKOlkgR4mBGKdZ
2xdggvZ1tQLcYoI+hOUdJ01byT8X87TWnHe93P2t9hf0630dyOiCW1RHGLiUwzePRtIo7thKTKY+
3V76ee6gYXgq1IVcJRBXZv8B0tZ0BPGC10ekMqe6MOa21BLPUG31giyIWYGStQVliqHtgwwgub4W
Wk/S0as5oXRflT4SZFXWPSzN/SP12buTAxgeUyrlDdA1T/9BOOE1bKOH9TUiTK4DMROXDzVpae2a
tCxsMIIGyTCCBbGgAwIBAgISESHCg+WEv9jSosxlfwy5vQMQMA0GCSqGSIb3DQEBBQUAMIGWMQsw
CQYDVQQGEwJGUjEaMBgGA1UECgwRRnJhbmNlIFRlbGVjb20gU0ExJDAiBgNVBAsMG1dlc3Rlcm5F
VSBNaWRkbGVFYXN0IEFmcmljYTEXMBUGA1UECwwOMDAwMiAzODAxMjk4NjYxLDAqBgNVBAMMI0dy
b3VwZSBGcmFuY2UgVGVsZWNvbSBJbnRlcm5hbCBDQSAxMB4XDTE4MTEyODA5MjAwNVoXDTIyMTEy
ODA5MjAwNVowcDELMAkGA1UEBhMCRlIxGjAYBgNVBAoTEUZyYW5jZSBUZWxlY29tIFNBMRkwFwYD
VQQDDBBDb2NhdWx0IFRpbW90aGVlMSowKAYJKoZIhvcNAQkBDBt0aW1vdGhlZS5jb2NhdWx0QG9y
YW5nZS5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDFoNoSx4vc5MNGSeq1aiQ8
m3H23xF1KFXbL8JyxSMtkPUG14Oin/5+NYWreFSvbRZGOKhI9xHVb/+VY7FOI1t2TO2HBoncJhRT
cJAyUQkTGnb0Bsju1NcG4msYFxKs0EvZZIVJdse6FfVCWVXwGIvKoGTjgkqf8Ur1/3kayHplAOeh
TUC8dl9bp8n8idxuPjg6dtUKEFBiR31Jw8edr6NnDbEPG8Pdg6a9C43RoIgFTUFuiC5CUuBqzFMn
rM4ZKdzbFCIwIKWS4hdOgwvjtCvzROhkPUuSFta0Lo4tbC5eXdxtl2U7DOQNiQjzCrA5Fpw5iEEz
CAIJHBVNO+OsNZLfAgMBAAGjggM0MIIDMDAOBgNVHQ8BAf8EBAMCBsAwEwYDVR0lBAwwCgYIKwYB
BQUHAwQwJgYDVR0RBB8wHYEbdGltb3RoZWUuY29jYXVsdEBvcmFuZ2UuY29tMIICIQYDVR0fBIIC
GDCCAhQwgeiggeWggeKGgd9sZGFwOi8vL2NuPUdyb3VwZSUyMEZyYW5jZSUyMFRlbGVjb20lMjBJ
bnRlcm5hbCUyMENBJTIwMSxjbj1pZ2NnZnRpLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2
aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWFkLERDPWZyYW5jZXRlbGVjb20s
REM9ZnI/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdGNsYXNzPWNSTERpc3Ry
aWJ1dGlvblBvaW50MIGpoIGmoIGjhoGgbGRhcDovL2lnY2dmdGktY2ExLWxkYXAuc2kuZnJhbmNl
dGVsZWNvbS5mci9vdT1pZ2NnZnRpX2NhMSxvdT1DQSxvdT1DUkxEUCxvdT1BQ19PTixvdT1JR0NH
cm91cGUsbz1GcmFuY2VUZWxlY29tP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmpl
Y3RjbGFzcz1wa2lDYTA0oDKgMIYuaHR0cDovL3BraS1jcmwuaXRuLmZ0Z3JvdXAvY3JsL2lnY2dm
dGlfY2ExLmNybDBFoEOgQYY/aHR0cDovL2lnY2dmdGktY2ExLWh0dHAuc2kuZnJhbmNldGVsZWNv
bS5mci9jcmwvaWdjZ2Z0aV9jYTEuY3JsMD4GA1UdIAQ3MDUwMwYIKoF6ARAMAgMwJzAlBggrBgEF
BQcCARYZaHR0cDovL3BraS1vcmFuZ2UuY29tL2NwczA8BggrBgEFBQcBAQQwMC4wLAYIKwYBBQUH
MAGGIGh0dHA6Ly9wa2ktb2NzcC5pdG4uZnRncm91cC9vY3NwMB0GA1UdDgQWBBTF/xfCjlgKe1v6
qwPB26h5I1C/SDAfBgNVHSMEGDAWgBQ2HDNn0xNc+luf6ou6RGZ0RvF3eDANBgkqhkiG9w0BAQUF
AAOCAQEAiGlHrVAgff6+QT04QjzAIasIcP+lhpJvzSD+u+aDAaWeQ1/tRE2avnDpIVN2dm/hxFDY
Hm/g8LHxmxECPoXzU6eWYYllNYJSAr2zhW9seoKe6obc3zBy70c1X9P1QXw9fjE9VfmxEMn5oCLx
2iofY9papFD5gd5fbvVtOimdpWPr6VMtBqS2JXP0eJ/ebma+MmbPZ8IWHSKNSLeelJUSS6y7k+Ms
Vl7Nw6mvIio/3BB07awYJaaOj89aOKzfAuR0i4C2uMFn5mXY47V3Qpt4idzyWkpeqePSlJog6OU4
63/7G5hsTkagQnTrsgbpI0u5LM4Lypv1bcuMX7VCs4huYDGCBGgwggRkAgEBMIGtMIGWMQswCQYD
VQQGEwJGUjEaMBgGA1UECgwRRnJhbmNlIFRlbGVjb20gU0ExJDAiBgNVBAsMG1dlc3Rlcm5FVSBN
aWRkbGVFYXN0IEFmcmljYTEXMBUGA1UECwwOMDAwMiAzODAxMjk4NjYxLDAqBgNVBAMMI0dyb3Vw
ZSBGcmFuY2UgVGVsZWNvbSBJbnRlcm5hbCBDQSAxAhIRIcKD5YS/2NKizGV/DLm9AxAwCQYFKw4D
AhoFAKCCAo8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMDE0
MTIzNjE0WjAjBgkqhkiG9w0BCQQxFgQUrIhNxblA455xSsHbLbA40Jfn8qAwgasGCSqGSIb3DQEJ
DzGBnTCBmjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQB
AjAOBggqhkiG9w0DAgICAIAwBwYFKw4DAgcwDQYIKoZIhvcNAwICAUAwDQYIKoZIhvcNAwICASgw
BwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglghkgBZQMEAgEwgb4GCSsGAQQB
gjcQBDGBsDCBrTCBljELMAkGA1UEBhMCRlIxGjAYBgNVBAoMEUZyYW5jZSBUZWxlY29tIFNBMSQw
IgYDVQQLDBtXZXN0ZXJuRVUgTWlkZGxlRWFzdCBBZnJpY2ExFzAVBgNVBAsMDjAwMDIgMzgwMTI5
ODY2MSwwKgYDVQQDDCNHcm91cGUgRnJhbmNlIFRlbGVjb20gSW50ZXJuYWwgQ0EgMQISESGAFl+u
svwwp4/SUlPBh1T0MIHABgsqhkiG9w0BCRACCzGBsKCBrTCBljELMAkGA1UEBhMCRlIxGjAYBgNV
BAoMEUZyYW5jZSBUZWxlY29tIFNBMSQwIgYDVQQLDBtXZXN0ZXJuRVUgTWlkZGxlRWFzdCBBZnJp
Y2ExFzAVBgNVBAsMDjAwMDIgMzgwMTI5ODY2MSwwKgYDVQQDDCNHcm91cGUgRnJhbmNlIFRlbGVj
b20gSW50ZXJuYWwgQ0EgMQISESGAFl+usvwwp4/SUlPBh1T0MA0GCSqGSIb3DQEBAQUABIIBAFzN
OA/2EB6zDJ86Ni0uUZ/a3QxoZSE+9zXPj12kofHZdjBrXM+T5vJ9rRYvOULog9C1ULCOSS3QmFLY
nmCWDXqRMD5IE0we4tJfQevbOpYInhdwXfATpiQW8TKuxofMoOYp1J9aX9Ln6lMYq2oeZwv7w7bo
zTLWws/Gy4VXTZzTEwhX4DpcAVVC41SjHbTkW+ZYrNRwL/ZcocgxuUM28I9vrjW31jV7yjKLS6pA
SjHXolmpS8NRfWP8ho5qKPPxAfXUp88n6YqSSBg2A1vezY60zIfFbdb/oBPuiu81srkwT5qEvEPY
EiXYPZhm8ZnXwxZWS50m0AgP7oE6pxbc64cAAAAAAAA=

------=_NextPart_000_0000_01D6A237.5E474B80--
