From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: DROP still returns -EPERM to userspace in OUTPUT chain
Date: Sat, 23 May 2009 12:47:56 +0200
Message-ID: <4A17D45C.6040909@netfilter.org>
References: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, wintre <mikeacar@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36503 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbZEWLCT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 May 2009 07:02:19 -0400
In-Reply-To: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
>=20
>=20
> once again, irc snatched this report:
>=20
> |2009-05-20T20:56 < Wintre:#Netfilter>
> |
> |Specifically, when I add a DROP rule to the local firewall, send(2)
> |starts getting EPERM. The netfilter core code includes
> |nf_hook_slow(), which says:
> |
> | /* Returns 1 if okfn() needs to be executed by the caller,
> |  * -EPERM for NF_DROP, 0 otherwise. */
> |
> |So, this seems kind of crazy to me. I always thought drop was
> |supposed to be silent, and changing the return value of send(2),
> |well. Bad. Anybody got a link to a discussion of this issue? Or is i=
t
> |just a plain old bug?
>=20
> I agree with the user here. For now, one had to make use of the
> =E2=80=9CSTEAL=E2=80=9D target [1] to get the real silent drop behavi=
or for the
> OUTPUT chain. Surely that is not the ideal thing either.
> Requesting comments from NF maintainers.

I'm curious, what application would need to ignore that error? Returnin=
g
-EPERM seems to me quite sane to note that the kernel is explicit (via
iptables, for example) not allowing permission to send().

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
