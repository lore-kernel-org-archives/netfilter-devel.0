From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 17:04:31 +0200
Message-ID: <4C4074FF.8080308@plouf.fr.eu.org>
References: <4C402DBD.3010007@quarantainenet.nl> <4C40539A.6080607@plouf.fr.eu.org> <4C405D50.6020306@quarantainenet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Bas van Sisseren <bas@quarantainenet.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:59264 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965695Ab0GPPEf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:04:35 -0400
In-Reply-To: <4C405D50.6020306@quarantainenet.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bas van Sisseren a =E9crit :
>=20
> On 16/07/10 14:42, Pascal Hambourg wrote:
>>
>> 2) I wonder whether it is really useful. The purpose of REDIRECT is =
to
>> make sure a packet is redirected to the local machine itself without=
 the
>> need to care about the machine's address (just as MASQUERADE). If yo=
u
>> don't want to change the destination address or need finer control o=
ver
>> it, I believe DNAT can be used instead. Can you provide a use case ?
>=20
> It's a honeypot system with advanced routing and a lot of ip-addresse=
s. The
> honeypot is running as non-root, which complicates usage of ports < 1=
024.
> The REDIRECT rule helps us to redirect the connection to higher
> port-numbers. With REDIRECT, we can request the original dst ip:port =
with
> the SO_ORIG_DST sockopt. With DNAT the SO_ORIG_DST is not available.

Do you mean SO_ORIGINAL_DST ? I'm surprised it does not work with DNAT.
AFAICS, it uses data from the connection tracking, and it does not
matter how the NAT mapping was created.

>> 3) Why restrict only to the addresses attached to the receiving
>> interface ? Why not extend to any address attached to a host's
>> interface, or even any local address (such as the whole 127.0.0.0/8
>> prefix) ?
>=20
> I don't see any use for that. :-)

Well, I think it would be more consistent with the Linux "weak" host
model (all local addresses belong globally to the host instead of a
single interface) ; we want to redirect a packet to the local host, so
if the original destination address is already a local address, we don'=
t
need to change it.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
