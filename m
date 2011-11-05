From: Eivind Naess <eivnaes@yahoo.com>
Subject: Re: Found a dead-freeze bug, in xt_ipv4options.c -- patch provided
Date: Sat, 5 Nov 2011 13:04:32 -0700 (PDT)
Message-ID: <1320523472.84883.YahooMailNeo@web39407.mail.mud.yahoo.com>
References: <1320337726.52658.YahooMailNeo@web39415.mail.mud.yahoo.com> <alpine.LNX.2.01.1111051530330.28505@frira.zrqbmnf.qr> <1320513044.59476.YahooMailNeo@web39407.mail.mud.yahoo.com> <alpine.LNX.2.01.1111051847570.14742@frira.zrqbmnf.qr>
Reply-To: Eivind Naess <eivnaes@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm11-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.240]:34554 "HELO
	nm11-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752218Ab1KEUFd convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Nov 2011 16:05:33 -0400
In-Reply-To: <alpine.LNX.2.01.1111051847570.14742@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,
That change looks good to me as it provides the same functionality. I'l=
l re-test on my end on Monday. Thanks you for accepting the suggested p=
atch despite the extra work on your end.


Regards,

- Eivind



----- Original Message -----
=46rom: Jan Engelhardt <jengelh@medozas.de>
To: Eivind Naess <eivnaes@yahoo.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Sent: Saturday, November 5, 2011 11:20 AM
Subject: Re: Found a dead-freeze bug, in xt_ipv4options.c -- patch prov=
ided

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
>Date:=A0=A0 Thu Nov 3 09:28:46 2011 -0700
>
>xt_ipv4options: fix an infinite loop
>---
>doc/changelog.txt=A0 =A0 =A0 =A0 =A0=A0 |=A0 =A0 1 +
>extensions/xt_ipv4options.c |=A0=A0 11 +++++++++++
>2 files changed, 12 insertions(+), 0 deletions(-)
>
>diff --git a/doc/changelog.txt b/doc/changelog.txt
>index 3557175..81fcbdc 100644
>--- a/doc/changelog.txt
>+++ b/doc/changelog.txt
>@@ -5,6 +5,7 @@ Fixes:
>- build: the code actually requires at least iptables 1.4.5 (would yie=
ld a
>=A0=A0 compile error otherwise), make sure configure checks for it; up=
date INSTALL
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
>=A0=A0=A0 uint32_t opts =3D 0;
>
>=A0=A0=A0 while (len >=3D 2) {
>+=A0=A0=A0 =A0=A0=A0 switch (data[0]) {
>+=A0=A0=A0 =A0=A0=A0 case IPOPT_END:
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return opts;
>+=A0=A0=A0 =A0=A0=A0 case IPOPT_NOOP:
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 --len;
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 ++data;
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 continue;
>+=A0=A0=A0 =A0=A0=A0 }
>+
>+=A0=A0=A0 =A0=A0=A0 if (data[1] < 2 || data[1] > len)
>+=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return opts;
>=A0=A0=A0 =A0=A0=A0 opts |=3D 1 << (data[0] & 0x1F);
>=A0=A0=A0 =A0=A0=A0 len=A0 -=3D data[1];
>=A0=A0=A0 =A0=A0=A0 data +=3D data[1];
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
