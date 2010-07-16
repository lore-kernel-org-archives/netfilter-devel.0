From: Bas van Sisseren <bas@quarantainenet.nl>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 15:23:28 +0200
Message-ID: <4C405D50.6020306@quarantainenet.nl>
References: <4C402DBD.3010007@quarantainenet.nl> <4C40539A.6080607@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.quarantaine.net ([217.114.102.88]:53092 "EHLO
	main.qone.quarantainenet.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965247Ab0GPNXg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 09:23:36 -0400
In-Reply-To: <4C40539A.6080607@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pascal,

On 16/07/10 14:42, Pascal Hambourg wrote:
> Bas van Sisseren a =E9crit :
>>
>> When redirecting, the destination address is replaced by the first
>> ip-address on the receiving interface.
>=20
> As described in the iptables manpage.
>=20
>> If the packet originally was sent to the second ip-address (or third=
,
>> fourth, etc..), this patch doesn't change the destination ip.
>=20
> Is this patch in reaction to the recent thread "iptables not forwardi=
ng
> port 443" in the netfilter user list from someone who stumbled into t=
his
> issue ?

I didn't read that thread. Although this patch would probably solve tha=
t issue.


> My thoughts :
> 1) The iptables manpage would need to be updated accordingly.
>=20
> 2) I wonder whether it is really useful. The purpose of REDIRECT is t=
o
> make sure a packet is redirected to the local machine itself without =
the
> need to care about the machine's address (just as MASQUERADE). If you
> don't want to change the destination address or need finer control ov=
er
> it, I believe DNAT can be used instead. Can you provide a use case ?

It's a honeypot system with advanced routing and a lot of ip-addresses.=
 The
honeypot is running as non-root, which complicates usage of ports < 102=
4.
The REDIRECT rule helps us to redirect the connection to higher
port-numbers. With REDIRECT, we can request the original dst ip:port wi=
th
the SO_ORIG_DST sockopt. With DNAT the SO_ORIG_DST is not available.

Besides that, we have to run some services on multiple port-numbers
(sometimes even varying per ip-address). Using only one listening socke=
t
instead of 1000 sockets really helps then.

We can redirect all those connections to the interface's first address.=
 In
fact, this is what we do now. But now and then it is confusing (e.g whe=
n
building ip-range check rules in the filter INPUT chain), and we also s=
eem
to trigger routing problems (might be in combination with advanced rout=
ing).



> 3) Why restrict only to the addresses attached to the receiving
> interface ? Why not extend to any address attached to a host's
> interface, or even any local address (such as the whole 127.0.0.0/8
> prefix) ?

I don't see any use for that. :-)


--=20
Bas van Sisseren <bas@quarantainenet.nl>
Quarantainenet
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
