From: Bogdan Siara <siarka2107@interia.pl>
Subject: =?UTF-8?q?Re:_Re:_ipt=5FACCOUNT_1.15_released?=
Date: 15 Apr 2009 12:12:35 +0200
Message-ID: <20090415101235.DF50515F7942@f12.poczta.interia.pl>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: thomas.jarosch@intra2net.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:29223 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759148AbZDOKMl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:12:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch napisa=B3(a):
> Hi Jan,
>=20
> On Tuesday, 14. April 2009 18:10:54 Jan Engelhardt wrote:
> > guess I just forward this to you, as I do not want to touch ACCOUNT
> > just yet.
>=20
> As you already mentioned, I&#039;m not sure it would be a good idea
> to include it as the kernel patch extends the kernel>->user space soc=
ket=20
> operations in include/linux/netfilter_ipv4/ip_tables.h.
>=20
> "ipt_account" is another story as it works differently.
> The lastest patch seems to be for 2.6.19 / iptables 1.3.5,
> though there is some recent activity on the project homepage.

Latest ipt_account support for kernel-2.6.25 and iptables-1.4.1.1
http://code.google.com/p/ipt-account/wiki/Software
I ported this to kernel 2.6.26/27 and iptables-1.4.2 and work fine.
Good idea is pick out very powerfull and preformance both and
ported to xtables-addons or merge mainline :).
I'm sorry for my english.

Bogdan

>=20
> I&#039;m still surprised how many people are using ipt_ACCOUNT,
> somehow it is magnetic to ISPs in central and eastern europe :-)
>=20
> > >Can You prepare ipt_ACCOUNT and ipt_account patches/files supporte=
d
> for
> > >kernel 2.6.29?
>=20
> ipt_ACCOUNT is now ready for 2.6.29.
>=20
> Cheers,
> Thomas
>=20
>=20
>=20



----------------------------------------------------------------------
Oblej swoich znajomych... wirtualnie! ;)
http://link.interia.pl/f2119

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
