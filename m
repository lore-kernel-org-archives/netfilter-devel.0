From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 12:29:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107151113410.25266@frira.zrqbmnf.qr>
References: <4E1F0F88.3090704@student.ulg.ac.be> <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be> <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <4E1FD4B0.3030505@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Terry_Mo=C3=ABs?= <T.Moes@student.ulg.ac.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Philip Craig <philipjcraig@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54184 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965046Ab1GOK3G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:29:06 -0400
In-Reply-To: <4E1FD4B0.3030505@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-07-15 07:48, Philip Craig wrote:

>On Fri, Jul 15, 2011 at 9:15 AM, Jan Engelhardt <jengelh@medozas.de> w=
rote:
>>On Thursday 2011-07-14 18:27, Terry Mo=C3=83=C2=ABs wrote:
>>
>>>Multi-Homing. One network can be a client of several ISPs in order t=
o
>>>ensure redundancy or in order to reduce costs. These different ISPs
>>>will assign the client different prefixes.[...]
>>
>>[...About the problems, but also possibilities, about switching=20
>>the link of a connection's packets in the middle of the connection...=
]
>
>[...] The goal here is to have multiple ISP links, and use them for=20
>redundancy/load balancing[...] at a connection level, not to have the=20
>same connection go over both links.
>
>So neither of those reasons stops you from:
>- creating a new connection via ISP2 using SRC2
>- using multiple connections from SRC1 and SRC2 simultaneously
>
>IPv4 NAT allows you to do the above without needing multiple addresses=
=20
>on your internal network, and without needing each client on your=20
>internal network to choose which ISP to use for each connection.

Without the knowledge of which address will be chosen, a client will=20
sooner or later run into ETE problems because it does not know which=20
address to write into its data stream. Always assume that this data=20
stream is armored (visible, but unmodifiable without breaking a=20
signature) or even encrypted (invisible, implies armored).


>It also ensures that the reply packets come back on the same link.=20
>Maybe IPv6 has solved that problem, but I'm not aware of how.

Well, I am thinking about whether MIP or a form thereof could be of use=
=2E=20
(Answer: not directly, because a server cannot realistically have two=20
routes to two different fd00::1.)

[ BTW Terry: fec0::/ that you are using in your NAT66_slides.pdf are=20
deprecated since 2004. ]

What we want: ETEC, i.e. webserver can potentially backconnect (subject=
=20
to any firewalling rules) to an arbitrary port of 1. the src address of=
=20
the packet and/or 2. the address(es) contained in the armored data=20
stream.

Step 1. To satisfy point 1, NAT bindings are supposed to be a 1:1=20
binding (i.e. ignoring all L4 components // L4 wildcard). NAT bindings=20
may be created on the fly as a packet traverses the NAT device. Whether=
=20
that is stateful or stateless is left to the implementation.

Step 2. A client may send addresses inside the data stream. The client=20
shall emit a DST header containing a 2-tuple of addresses used in the=20
armored/encrypted communication procedure, e.g.

	<i-address, p-address>
	<fc00::1, fc00::1>
afterw.	<fc00::1, 2001:db8::1>

(I chose DST so that it is not stripped at a router. A HBH header that=20
each router reproduces would do the same, though that would probably=20
need extra routing software support.)

During NAT traversal, only the p-address is changed. A server can now=20
substitute "fc00::1" appearing in the datastream by "2001:db8::1" to be=
=20
able to connect.

Naturally, this needs application support, and given there are already =
a=20
handful of solutions with application support, maybe this is not as=20
ideal as one of such preexisting solutions. Anyhow, the upside is that=20
this would only require application support at the receiver side, which=
=20
means that a client does not need to discover its own addresses in=20
advance (like UPNP/IGD if I read it right). The issue with in-advance=20
address discovery would be that it may be outdated again once used.=20
Also, the header approach does not need protocol modifications.

Step 3. Since I guess some people will whine again that their=20
oh-so-secret internal addresses that mean nothing to the outside world=20
are visible, the client can actually utilize fake addresses in both the=
=20
armored data stream, and the DST header.

	<::2, fc00::1>
afterw.	<::2, 2001:db8::1>

Since the application support is already given by step 2, this step is=20
practically for free.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
