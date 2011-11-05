From: Eivind Naess <eivnaes@yahoo.com>
Subject: Re: Found a dead-freeze bug, in xt_ipv4options.c -- patch provided
Date: Sat, 5 Nov 2011 10:10:44 -0700 (PDT)
Message-ID: <1320513044.59476.YahooMailNeo@web39407.mail.mud.yahoo.com>
References: <1320337726.52658.YahooMailNeo@web39415.mail.mud.yahoo.com> <alpine.LNX.2.01.1111051530330.28505@frira.zrqbmnf.qr>
Reply-To: Eivind Naess <eivnaes@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm22.bullet.mail.sp2.yahoo.com ([98.139.91.92]:22093 "HELO
	nm22.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753878Ab1KERKp convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Nov 2011 13:10:45 -0400
In-Reply-To: <alpine.LNX.2.01.1111051530330.28505@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi Jan,


As far as the security hole goes, only the changes to=20
make it parse the in ipv4options_rd is needed. If my understanding for=20
the option *any* was wrong given the manual, then I'll take that back.=20
Let me know how you want to proceed with this, I can provide you anothe=
r
 patch with the update to ipv4options_rd only, and with proper=20
indentation.


Regards,
- Eivind



----- Original Message -----
=46rom: Jan Engelhardt <jengelh@medozas.de>
To: Eivind Naess <eivnaes@yahoo.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Sent: Saturday, November 5, 2011 7:34 AM
Subject: Re: Found a dead-freeze bug, in xt_ipv4options.c -- patch prov=
ided


On Thursday 2011-11-03 17:28, Eivind Naess wrote:
>-static uint32_t ipv4options_rd(const uint8_t *data, int len)
>+static uint32_t ipv4options_rd(const uint8_t *ptr, int len)
>=A0{
>=A0=A0=A0=A0 uint32_t opts =3D 0;
>+=A0=A0=A0 uint32_t olen =3D 0;
>=A0
>=A0=A0=A0=A0 while (len >=3D 2) {
>-=A0=A0=A0 =A0=A0=A0 opts |=3D 1 << (data[0] & 0x1F);
>-=A0=A0=A0 =A0=A0=A0 len=A0 -=3D data[1];
>-=A0=A0=A0 =A0=A0=A0 data +=3D data[1];
>+=A0=A0=A0=20
>+=A0=A0=A0 =A0=A0=A0 /* Handle special options */
>+=A0=A0=A0 =A0=A0=A0 switch (*ptr) {
>+=A0=A0=A0 =A0=A0=A0 case IPOPT_END:
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return opts;
>+=A0=A0=A0 =A0=A0=A0 case IPOPT_NOOP:
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 len--;
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ptr++;
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 continue;
>+=A0=A0=A0 =A0=A0=A0 }
>+=A0=A0=A0 =A0=A0=A0=20
>+=A0=A0=A0 =A0=A0=A0 /* Get the length of the option */
>+=A0=A0=A0 =A0=A0=A0 olen =3D ptr[1];
>+=A0=A0=A0 =A0=A0=A0 if (olen < 2 || olen > len)
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return opts;
>+=A0=A0=A0 =A0=A0=A0=20
>+=A0=A0=A0 =A0=A0=A0 /* Set the option bit, and incr/decr the invarian=
ts */
>+=A0=A0=A0 =A0=A0=A0 opts |=3D 1 << (*ptr & 0x1F);
>+=A0=A0=A0 =A0=A0=A0 len=A0 -=3D olen;
>+=A0=A0=A0 =A0=A0=A0 ptr=A0 +=3D olen;
>=A0=A0=A0=A0 }
>=A0
>=A0=A0=A0=A0 return opts;

Whitespace damage, I had to apply this manually, and in doing so,
reduced the size. You can test the patch from the "v4options" branch,
copied below.

>@@ -36,13 +54,20 @@
>=A0=A0=A0=A0 uint32_t opts =3D 0;
>=A0=A0=A0=A0 uint16_t len=A0 =3D ip_hdrlen(skb) - sizeof(struct iphdr)=
;
>=A0
>-=A0=A0=A0 if (len > 0)
>+=A0=A0=A0 if (len > 0) {
>=A0=A0=A0=A0 =A0=A0=A0 opts =3D ipv4options_rd((const void *)iph +
>=A0=A0=A0=A0 =A0=A0=A0 =A0=A0=A0=A0=A0=A0 sizeof(struct iphdr), len);
>+=A0=A0=A0 =A0=A0=A0 if(info->flags & XT_V4OPTS_ANY) {
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return=A0 !!opts; /* !! to make bool va=
lue */
>+=A0=A0=A0 =A0=A0=A0 }else {
>=A0
>=A0=A0=A0=A0 opts ^=3D info->invert;
>=A0=A0=A0=A0 opts &=3D info->map;
>-=A0=A0=A0 return (info->flags & XT_V4OPTS_ANY) ? opts : opts =3D=3D i=
nfo->map;
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return (opts =3D=3D info->map);
>+=A0=A0=A0 =A0=A0=A0 }=A0=A0=A0 =A0=A0=A0=20
>+=A0=A0=A0 }
>+=A0=A0=A0=20
>+=A0=A0=A0 return 0;
>=A0}

XT_V4OPTS_ANY is meant to match on {any of {the bits present in
info->map}}, not {any of {all possible IPv4 options}} according to
the documentation. The test for XT_V4OPTS_ANY is therefore supposed
to come after the ^ and & operations, and that is what the current
(/^-/) code does AFAICS, or did I miss something?





commit 75cd1d7d6a3747ec297f24f67f589acd8f5a9859
Author: Eivind Naess <eivnaes@yahoo.com>
Date:=A0  Thu Nov 3 09:28:46 2011 -0700

xt_ipv4options: fix an infinite loop
---
doc/changelog.txt=A0 =A0 =A0 =A0 =A0  |=A0 =A0 1 +
extensions/xt_ipv4options.c |=A0  11 +++++++++++
2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/doc/changelog.txt b/doc/changelog.txt
index 3557175..81fcbdc 100644
--- a/doc/changelog.txt
+++ b/doc/changelog.txt
@@ -5,6 +5,7 @@ Fixes:
- build: the code actually requires at least iptables 1.4.5 (would yiel=
d a
=A0  compile error otherwise), make sure configure checks for it; updat=
e INSTALL
- xt_ECHO: fix kernel warning about RTAX_HOPLIMIT being used
+- xt_ipv4options: fix an infinite loop
Changes:
- xt_ECHO: now calculates UDP checksum
Enhancements:
diff --git a/extensions/xt_ipv4options.c b/extensions/xt_ipv4options.c
index 42481f7..5e9d34c 100644
--- a/extensions/xt_ipv4options.c
+++ b/extensions/xt_ipv4options.c
@@ -20,6 +20,17 @@ static uint32_t ipv4options_rd(const uint8_t *data, =
int len)
=A0=A0=A0 uint32_t opts =3D 0;

=A0=A0=A0 while (len >=3D 2) {
+=A0=A0=A0 =A0=A0=A0 switch (data[0]) {
+=A0=A0=A0 =A0=A0=A0 case IPOPT_END:
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return opts;
+=A0=A0=A0 =A0=A0=A0 case IPOPT_NOOP:
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 --len;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ++data;
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 continue;
+=A0=A0=A0 =A0=A0=A0 }
+
+=A0=A0=A0 =A0=A0=A0 if (data[1] < 2 || data[1] > len)
+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return opts;
=A0=A0=A0 =A0=A0=A0 opts |=3D 1 << (data[0] & 0x1F);
=A0=A0=A0 =A0=A0=A0 len=A0 -=3D data[1];
=A0=A0=A0 =A0=A0=A0 data +=3D data[1];
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
