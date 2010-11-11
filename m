From: Patrick McHardy <kaber@trash.net>
Subject: Re: [arptables] rfc: add classify target
Date: Thu, 11 Nov 2010 11:38:41 +0100
Message-ID: <4CDBC7B1.2020101@trash.net>
References: <20101107152636.56f62235@caresse>	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>	<4CD959D6.1090705@trash.net>	<20101109161047.GB25549@sd-11162.dedibox.fr>	<4CD98746.4050100@pandora.be>	<20101109211834.4da8e412@caresse>	<alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr> <20101109215126.502a155e@caresse>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org
To: Frederic Leroy <fredo@starox.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35701 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0KKKik (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:38:40 -0500
In-Reply-To: <20101109215126.502a155e@caresse>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.11.2010 21:51, Frederic Leroy wrote:
> Le Tue, 9 Nov 2010 21:28:09 +0100 (CET),
> Jan Engelhardt <jengelh@medozas.de> a =E9crit :
>=20
>> Alas, when I originally coded NFPROTO_UNSPEC wildcard support,
>> I allowed for same-rev overloading, as in:
>>
>> static struct xt_target classify_tg_reg[] __read_mostly =3D {
>> 	{
>> [...]
>> };
>>
>=20
> Here is a patch against my previous patch with your insights.
> I had time to test it.=20

This seems like the best we can do for now. Does it work as intended?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
