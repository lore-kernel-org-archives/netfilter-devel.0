From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables-addons 1.32/ipset-GENL 5.2
Date: Thu, 06 Jan 2011 03:11:39 +0100
Message-ID: <4D2524DB.8090408@netfilter.org>
References: <alpine.LNX.2.01.1101040456270.11091@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36511 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab1AFCLp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:11:45 -0500
In-Reply-To: <alpine.LNX.2.01.1101040456270.11091@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/01/11 05:14, Jan Engelhardt wrote:
> '=E3=81=A1=E3=82=8F
>=20
> So a few people had been asking on whether ipset 5.x will be bundled=20
> along with Xtables-addons. Naturally this is a difficult question=20
> because ipset-5 wants a kernel patch. But yes, it is included as of X=
t-a=20
> 1.32 (just out).
>=20
> It has been augmented to not require the patch anymore, by moving it=20
> over from nfnetlink (booo) to genetlink which does not depend on stat=
ic=20
> numbers, though you will need at least Linux 2.6.35 for this GENL=20
> variant in both compilation and at runtime.

Not depending of static numbers is a good thing to me because it makes
the whole user-space simpler since: a) you don't have to send a message
to perform the initial family ID lookup and b) you don't have to
subscribe to genl control events (which is required since the the
floating family number may change if the module is unloaded).

> (As such, ipset-5 is deactivated by default in Xt-a 1.32 and needs to=
 be=20
> turned on in mconfig.)
>=20
> Xt-a files at the usual place.
>=20
> The plain genl patch to ipset-5 can be found as a commit at=20
> git://dev.medozas.de/ipset in the "genl" branch. It has received a ru=
n=20
> through the testsuite (as far as it went until ospf), and I take that=
 as=20
> an indication that proxying the protocol onto genl was successful.

This is going to confuse everyone. Since ipset-5 will be submitted into
mainline soon, some distributors may start packaging the user-space gen=
l
binaries. Then, once we have it into the kernel, the distributed versio=
n
will not work with the one running upon nfnetlink.

I think it's way easier to submit a patch to reserve the subsystem ID
for ipset than adding this genl compatibility layer.

BTW, Jozsef, do you plan to submit ipset for the next linux kernel
release cycle?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
