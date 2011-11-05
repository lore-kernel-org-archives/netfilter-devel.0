From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Found a dead-freeze bug, in xt_ipv4options.c -- patch provided
Date: Sat, 5 Nov 2011 15:34:29 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111051530330.28505@frira.zrqbmnf.qr>
References: <1320337726.52658.YahooMailNeo@web39415.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Eivind Naess <eivnaes@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49256 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab1KEOec (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Nov 2011 10:34:32 -0400
In-Reply-To: <1320337726.52658.YahooMailNeo@web39415.mail.mud.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-11-03 17:28, Eivind Naess wrote:
>-static uint32_t ipv4options_rd(const uint8_t *data, int len)
>+static uint32_t ipv4options_rd(const uint8_t *ptr, int len)
>=C2=A0{
>=C2=A0=C2=A0=C2=A0=C2=A0 uint32_t opts =3D 0;
>+=C2=A0=C2=A0=C2=A0 uint32_t olen =3D 0;
>=C2=A0
>=C2=A0=C2=A0=C2=A0=C2=A0 while (len >=3D 2) {
>-=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 opts |=3D 1 << (data[0] & 0x1F)=
;
>-=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 len=C2=A0 -=3D data[1];
>-=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 data +=3D data[1];
>+=C2=A0=C2=A0=C2=A0=20
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 /* Handle special options */
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 switch (*ptr) {
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 case IPOPT_END:
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return opts;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 case IPOPT_NOOP:
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 len--;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ptr++;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 continue;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 }
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=20
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 /* Get the length of the option=
 */
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 olen =3D ptr[1];
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (olen < 2 || olen > len)
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return opts;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=20
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 /* Set the option bit, and incr=
/decr the invariants */
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 opts |=3D 1 << (*ptr & 0x1F);
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 len=C2=A0 -=3D olen;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ptr=C2=A0 +=3D olen;
>=C2=A0=C2=A0=C2=A0=C2=A0 }
>=C2=A0
>=C2=A0=C2=A0=C2=A0=C2=A0 return opts;

Whitespace damage, I had to apply this manually, and in doing so,
reduced the size. You can test the patch from the "v4options" branch,
copied below.

>@@ -36,13 +54,20 @@
>=C2=A0=C2=A0=C2=A0=C2=A0 uint32_t opts =3D 0;
>=C2=A0=C2=A0=C2=A0=C2=A0 uint16_t len=C2=A0 =3D ip_hdrlen(skb) - sizeo=
f(struct iphdr);
>=C2=A0
>-=C2=A0=C2=A0=C2=A0 if (len > 0)
>+=C2=A0=C2=A0=C2=A0 if (len > 0) {
>=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 opts =3D ipv4options_rd((c=
onst void *)iph +
>=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sizeof(struct iphdr), len);
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if(info->flags & XT_V4OPTS_ANY)=
 {
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return=C2=A0=
 !!opts; /* !! to make bool value */
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 }else {
>=C2=A0
>=C2=A0=C2=A0=C2=A0=C2=A0 opts ^=3D info->invert;
>=C2=A0=C2=A0=C2=A0=C2=A0 opts &=3D info->map;
>-=C2=A0=C2=A0=C2=A0 return (info->flags & XT_V4OPTS_ANY) ? opts : opts=
 =3D=3D info->map;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return (opts=
 =3D=3D info->map);
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 }=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0=20
>+=C2=A0=C2=A0=C2=A0 }
>+=C2=A0=C2=A0=C2=A0=20
>+=C2=A0=C2=A0=C2=A0 return 0;
>=C2=A0}

XT_V4OPTS_ANY is meant to match on {any of {the bits present in
info->map}}, not {any of {all possible IPv4 options}} according to
the documentation. The test for XT_V4OPTS_ANY is therefore supposed
to come after the ^ and & operations, and that is what the current
(/^-/) code does AFAICS, or did I miss something?





commit 75cd1d7d6a3747ec297f24f67f589acd8f5a9859
Author: Eivind Naess <eivnaes@yahoo.com>
Date:   Thu Nov 3 09:28:46 2011 -0700

xt_ipv4options: fix an infinite loop
---
 doc/changelog.txt           |    1 +
 extensions/xt_ipv4options.c |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/doc/changelog.txt b/doc/changelog.txt
index 3557175..81fcbdc 100644
--- a/doc/changelog.txt
+++ b/doc/changelog.txt
@@ -5,6 +5,7 @@ Fixes:
 - build: the code actually requires at least iptables 1.4.5 (would yie=
ld a
   compile error otherwise), make sure configure checks for it; update =
INSTALL
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
 	uint32_t opts =3D 0;
=20
 	while (len >=3D 2) {
+		switch (data[0]) {
+		case IPOPT_END:
+			return opts;
+		case IPOPT_NOOP:
+			--len;
+			++data;
+			continue;
+		}
+
+		if (data[1] < 2 || data[1] > len)
+			return opts;
 		opts |=3D 1 << (data[0] & 0x1F);
 		len  -=3D data[1];
 		data +=3D data[1];


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
