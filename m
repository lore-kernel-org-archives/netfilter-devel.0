From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 21:00:24 +0100
Message-ID: <4CD310D8.2010003@plouf.fr.eu.org>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <4CD29F24.70804@plouf.fr.eu.org> <4CD2C647.2000608@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:64606 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab0KDUA1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:00:27 -0400
In-Reply-To: <4CD2C647.2000608@zytor.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

H. Peter Anvin a =E9crit :
>>>
>>> Now, the upstream (ISP-assigned) prefix changes to 2001:6b2f:1705::=
/48.
>>> RA will handle reassigning addresses to actual downstream hosts, bu=
t
>>> things that explicitly encode IPv6 addresses need to be changed, an=
d
>>> that includes ip6tables, in this case these rules now need to refer=
 to
>>> 2001:6b2f:1705:0000::/52, 2001:62bf:1705:1000::/52 and so on.
>>
>> Are you talking about rules on the router which subnets the block, o=
r on
>> downstream hosts ?
>> Also, is each subnet prefix on a separate link ?
>> Could you provide an example of such rules ?
>=20
> I'm talking about rules on the internal router(s) which separate the=20
> security domains.

Isn't it enough to match the input and/or output interface(s) ?

> I can probably come up with a concrete ruleset, but=20
> it'll take a few days since I'm travelling at the moment.

I am not asking for a complete ruleset, rather a few sample rules and
their purpose.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
