From: Frederic Leroy <fredo@starox.org>
Subject: Re: [arptables] rfc: add classify target
Date: Thu, 11 Nov 2010 12:45:05 +0100
Message-ID: <20101111124505.345643a3@caresse>
References: <20101107152636.56f62235@caresse>
	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
	<4CD959D6.1090705@trash.net>
	<20101109161047.GB25549@sd-11162.dedibox.fr>
	<4CD98746.4050100@pandora.be>
	<20101109211834.4da8e412@caresse>
	<alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>
	<20101109215126.502a155e@caresse>
	<4CDBC7B1.2020101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:35033 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab0KKLoL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:44:11 -0500
In-Reply-To: <4CDBC7B1.2020101@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le Thu, 11 Nov 2010 11:38:41 +0100,
Patrick McHardy <kaber@trash.net> a =C3=A9crit :

> On 09.11.2010 21:51, Frederic Leroy wrote:
> > Le Tue, 9 Nov 2010 21:28:09 +0100 (CET),
> > Jan Engelhardt <jengelh@medozas.de> a =C3=A9crit :
> >=20
> >> Alas, when I originally coded NFPROTO_UNSPEC wildcard support,
> >> I allowed for same-rev overloading, as in:
> >>
> >> static struct xt_target classify_tg_reg[] __read_mostly =3D {
> >> 	{
> >> [...]
> >> };
> >>
> >=20
> > Here is a patch against my previous patch with your insights.
> > I had time to test it.=20
>=20
> This seems like the best we can do for now. Does it work as intended?

Yes, it works as intended.=20

Nevertheless, I plan to update kernel and arptables to match NF_INET_*.
I should have time to do it for sunday.=20

--=20
=46r=C3=A9d=C3=A9ric Leroy
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
