From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 15:03:55 +0200
Message-ID: <4C4058BB.5000008@plouf.fr.eu.org>
References: <4C402DBD.3010007@quarantainenet.nl> <4C404EAC.7050509@trash.net> <4C4053AB.8050300@quarantainenet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Bas van Sisseren <bas@quarantainenet.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:56568 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965485Ab0GPND5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 09:03:57 -0400
In-Reply-To: <4C4053AB.8050300@quarantainenet.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bas van Sisseren a =E9crit :
>=20
> The problem is that we can't tell the other end to use the first addr=
ess on
> the interface. Some systems use the first address, others use the sec=
ond
> address. When a connection is set up from the remote system to the se=
cond
> address, the original REDIRECT redirects the connection to the config=
ured
> port-number on the first address.
>=20
> It seems way more logical to me to keep the destination address the s=
ame and
> only change the port number if the destination address is locally con=
figured
> on that interface.

Ok, but again, is this really a problem ?

> Assume:
>   eth0 has these addresses:
>     10.1.0.1, netmask 255.255.255.0  (primary address)
>     10.2.0.1, netmask 255.255.255.0
>     10.3.0.1, netmask 255.255.255.0
>     10.4.0.1, netmask 255.255.255.0
>=20
>   and redirects from.. say.. port 80 to 8080
>=20
>   Connections to 10.1.0.1:80 will be redirected to 10.1.0.1:8080
>   But also all connections to 10.2.0.1:80, 10.3.0.1:80 and
>   10.4.0.1:80 will be redirected to 10.1.0.1:8080
>=20
> With the patch, the connection to 10.2.0.1:80 will be redirected to
> 10.2.0.1:8080, 10.3.0.1:80 to 10.3.0.1:8080, etc..

If all you want is to change only the destination port number, you can
use "-j DNAT --to :<newport>" so the destination address won't be
altered. If the box acts as a router and you also want to REDIRECT
packets with a non local address, you can use the addrtype match and
DNAT packets with a local destination address and REDIRECT packets with
a non local destination address.

>>> When redirecting, the destination address is replaced by the first
>>> ip-address on the receiving interface.

By the way, I wonder what happens if the interface has no IP address
(unnumbered).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
