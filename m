From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 14:42:02 +0200
Message-ID: <4C40539A.6080607@plouf.fr.eu.org>
References: <4C402DBD.3010007@quarantainenet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Bas van Sisseren <bas@quarantainenet.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:54204 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965326Ab0GPMmI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:42:08 -0400
In-Reply-To: <4C402DBD.3010007@quarantainenet.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Bas van Sisseren a =E9crit :
>=20
> When redirecting, the destination address is replaced by the first
> ip-address on the receiving interface.

As described in the iptables manpage.

> If the packet originally was sent to the second ip-address (or third,
> fourth, etc..), this patch doesn't change the destination ip.

Is this patch in reaction to the recent thread "iptables not forwarding
port 443" in the netfilter user list from someone who stumbled into thi=
s
issue ?

My thoughts :
1) The iptables manpage would need to be updated accordingly.

2) I wonder whether it is really useful. The purpose of REDIRECT is to
make sure a packet is redirected to the local machine itself without th=
e
need to care about the machine's address (just as MASQUERADE). If you
don't want to change the destination address or need finer control over
it, I believe DNAT can be used instead. Can you provide a use case ?

3) Why restrict only to the addresses attached to the receiving
interface ? Why not extend to any address attached to a host's
interface, or even any local address (such as the whole 127.0.0.0/8
prefix) ?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
