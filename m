From: Patrick McHardy <kaber@trash.net>
Subject: Re: IPv6 conntrack support for neighbour discovery
Date: Tue, 04 Nov 2008 15:06:55 +0100
Message-ID: <491056FF.8030801@trash.net>
References: <20081030145218.5395c3fe@hiperon.ws.hirg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Marek Szuba <Marek.Szuba@if.pw.edu.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42205 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYKDOHC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:07:02 -0500
In-Reply-To: <20081030145218.5395c3fe@hiperon.ws.hirg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Marek Szuba wrote:
> Hello everyone,
>=20
> Following a suggestion I was given at the kernel Bugzilla I am
> forwarding this here.
>=20
> It has come to my attention lately that the only two ICMPv6 packet
> types which IPv6 conntrack allows at present to initiate new
> connections are "echo request" and "node information query"; all othe=
r
> types appearing in this context are considered invalid. In particular=
,
> this includes two neighbour-discovery types specified in RFC 2461:
> "router solicitation" and "neighbour solicitation" - meaning that if =
a
> server drops all INVALID packets early in its INPUT or OUTPUT chain o=
f
> IPv6 netfilter's filter table, neither of the two can be received fro=
m
> clients. Given that router solicitation is used for stateless network
> autoconfiguration and neighbour solicitation is an IPv6 equivalent of
> ARP requests, having these two dropped can be quite bad - especially
> the latter, as it pretty much kills IPv6 over Ethernet.
>=20
> Steps to reproduce:
>=20
> 1. Obtain an IPv6 address assigned to an Ethernet interface of host A
> (link-local will do);
> 2. If necesssary, flush all ip6tables filter chains on host A and set
> their policies to ACCEPT;
> 3. From host B on the same Ethernet network, ping6 the aforementioned=
 IP
> address to verify that everything works;
> 4. On host A, run something like "ip6tables -I INPUT 1 -m state --sta=
te
> INVALID -j DROP";
> 5. Try to repeat step 3. This time the ping should fail and counters
> associated with the aforementioned rule should increment;
> 6. Repeat all the above using OUTPUT instead of INPUT, with the same
> final result.
>=20
> BTW. This problem was discovered and (hopefully) fixed collaborativel=
y
> by =C5=81ukasz Stelmach <steelman@post.pl> and myself, please attribu=
te both
> of us should the patch make it into code repositories.
>=20
> Attaching a proposed solution to the problem - the enclosed patch add=
s
> "router solicitation" and "neighbour solicitation" to the list of
> ICMPv6 types IPv6 conntrack considers allowed to initiate new
> connections. Note that in principle "router advertisement" ICMPv6
> packets could also be considered valid-new, as e.g. radvd periodicall=
y
> advertises its presence to the local network - as however it is not
> necessary to let this through as new to have things work (plus we
> aren't that big on broadcasting, even on supposedly-secure networks),
> the patch only adds solicitations to the list.

This patch seems fine to me. Yasuyuki, what do you think?


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
