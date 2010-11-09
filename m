From: Frederic Leroy <fredo@starox.org>
Subject: Re: [arptables] rfc: add classify target
Date: Tue, 9 Nov 2010 22:38:18 +0100
Message-ID: <20101109223818.41c07321@caresse>
References: <20101107152636.56f62235@caresse>
	<alpine.LNX.2.01.1011071616150.21289@obet.zrqbmnf.qr>
	<4CD959D6.1090705@trash.net>
	<20101109161047.GB25549@sd-11162.dedibox.fr>
	<4CD98746.4050100@pandora.be>
	<20101109211834.4da8e412@caresse>
	<alpine.LNX.2.01.1011092121210.10710@obet.zrqbmnf.qr>
	<20101109213439.2f44ec6e@caresse>
	<alpine.LNX.2.01.1011092226050.24069@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:49061 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0KIVh0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:37:26 -0500
In-Reply-To: <alpine.LNX.2.01.1011092226050.24069@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le Tue, 9 Nov 2010 22:27:53 +0100 (CET),
Jan Engelhardt <jengelh@medozas.de> a =C3=A9crit :

>=20
> On Tuesday 2010-11-09 21:34, Frederic Leroy wrote:
> >> On Tuesday 2010-11-09 21:18, Frederic Leroy wrote:
> >> >
> >> >For the kernel part,I didn't add modalias command because the
> >> >userspace don't work yet :
> >> >
> >> ># ./arptables -A OUTPUT -o eth0 -j CLASSIFY --set-class 0:7
> >> >x_tables: arp_tables: CLASSIFY target: used from hooks INPUT, but
> >> >only usable from FORWARD/OUTPUT/POSTROUTING
> >>=20
> >> Here we have a perfect example of the dentrimentality of code
> >> duplication. Hooray for NF_ARP_* not matching NF_INET_*.
> >
> >It was what saying me that it would be a lot of work. Move arptables
> >to match NF_INET_*=20
>=20
> The actual work is minimal - since you just need to change the values
> of the NF_ARP_ constants. The problem is that it is shared with
> userspace.

If I remember correctly what I've see sunday, there is some arrays of
size : number of NF_ARP*
There is some code with ->hook[NF_xxx]=3Dyyy

Moreover, when I turned debug on, it outputs me warnings with overflow
on these arrays when I switched to NF_INET.

--=20
=46r=C3=A9d=C3=A9ric Leroy
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
