From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Found a dead-freeze bug, in xt_ipv4options.c -- patch provided
Date: Sat, 5 Nov 2011 19:20:42 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111051847570.14742@frira.zrqbmnf.qr>
References: <1320337726.52658.YahooMailNeo@web39415.mail.mud.yahoo.com> <alpine.LNX.2.01.1111051530330.28505@frira.zrqbmnf.qr> <1320513044.59476.YahooMailNeo@web39407.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Eivind Naess <eivnaes@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:47397 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab1KESUo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Nov 2011 14:20:44 -0400
In-Reply-To: <1320513044.59476.YahooMailNeo@web39407.mail.mud.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-11-05 18:10, Eivind Naess wrote:

>As far as the security hole goes, only the changes to=20
>make it parse the in ipv4options_rd is needed. If my understanding for=
=20
>the option *any* was wrong given the manual, then I'll take that back.

It seems that your version of "any" is representable using

 --any --flags 1,2,3,4,5,6,7,8,9,10,11,12...,31


>Let me know how you want to proceed with this, I can provide you anoth=
er
>patch with the update to ipv4options_rd only, and with proper=20
>indentation.

I proceeded like this:

>commit 75cd1d7d6a3747ec297f24f67f589acd8f5a9859
>Author: Eivind Naess <eivnaes@yahoo.com>
>Date:=C2=A0  Thu Nov 3 09:28:46 2011 -0700
>
>xt_ipv4options: fix an infinite loop
>---
>doc/changelog.txt=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0  |=C2=A0 =C2=A0 1 =
+
>extensions/xt_ipv4options.c |=C2=A0  11 +++++++++++
>2 files changed, 12 insertions(+), 0 deletions(-)
>
>diff --git a/doc/changelog.txt b/doc/changelog.txt
>index 3557175..81fcbdc 100644
>--- a/doc/changelog.txt
>+++ b/doc/changelog.txt
>@@ -5,6 +5,7 @@ Fixes:
>- build: the code actually requires at least iptables 1.4.5 (would yie=
ld a
>=C2=A0  compile error otherwise), make sure configure checks for it; u=
pdate INSTALL
>- xt_ECHO: fix kernel warning about RTAX_HOPLIMIT being used
>+- xt_ipv4options: fix an infinite loop
>Changes:
>- xt_ECHO: now calculates UDP checksum
>Enhancements:
>diff --git a/extensions/xt_ipv4options.c b/extensions/xt_ipv4options.c
>index 42481f7..5e9d34c 100644
>--- a/extensions/xt_ipv4options.c
>+++ b/extensions/xt_ipv4options.c
>@@ -20,6 +20,17 @@ static uint32_t ipv4options_rd(const uint8_t *data,=
 int len)
>=C2=A0=C2=A0=C2=A0 uint32_t opts =3D 0;
>
>=C2=A0=C2=A0=C2=A0 while (len >=3D 2) {
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 switch (data[0]) {
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 case IPOPT_END:
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return opts;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 case IPOPT_NOOP:
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 --len;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ++data;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 continue;
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 }
>+
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (data[1] < 2 || data[1] > le=
n)
>+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return opts;
>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 opts |=3D 1 << (data[0] & 0x1F);
>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 len=C2=A0 -=3D data[1];
>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 data +=3D data[1];
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
