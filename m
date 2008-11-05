From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: IPv6 conntrack support for neighbour discovery
Date: Wed, 05 Nov 2008 13:44:05 +0900 (JST)
Message-ID: <200811050444.mA54i7wa004551@toshiba.co.jp>
References: <20081030145218.5395c3fe@hiperon.ws.hirg>
	<491056FF.8030801@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Marek.Szuba@if.pw.edu.pl, netfilter-devel@vger.kernel.org,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:42474 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYKEFWV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 00:22:21 -0500
Received: from imx12.toshiba.co.jp (imx12 [61.202.160.132])
	by imx9.toshiba.co.jp  with ESMTP id mA54oB1V011997
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Wed, 5 Nov 2008 13:50:11 +0900 (JST)
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id mA54i84R002769
	for <netfilter-devel@vger.kernel.org>; Wed, 5 Nov 2008 13:44:08 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id mA54i8Pc005940
	for netfilter-devel@vger.kernel.org; Wed, 5 Nov 2008 13:44:08 +0900 (JST)
Received: from mx2.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id mA54i7x0027753
	for <netfilter-devel@vger.kernel.org>; Wed, 5 Nov 2008 13:44:07 +0900 (JST)
In-Reply-To: <491056FF.8030801@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> This patch seems fine to me. Yasuyuki, what do you think?

In short: nf_conntrack_proto_icmpv6.c does not help for protocols using
their messages. conntrack helper is better.


In detail:

A solicitation and advertisement does not construct 'connection'
in most cases. Because the destination of solicitation is typically
multicast address, and the source address of advertisement for replying=
 is
typically unicast address.

In the first place, static configuration is better for their messages.

Even if you add their ICMPv6 types to nf_coonntrack_proto_icmpv6.c,
you will need to configure rules to allow IPv6 stack to receive
Router/Neighbor Solicitation/Advertisement with all-node or solicited
multicast address.

=46or example, IPv6 node sends neighbor solicitation to
solicited multicast address to resolve L2 address. If you block it
on your node, then other nodes (including routers) cannot resolve
L2 address of your node. Also Duplicated Address Detection (DAD) does n=
ot
work.

What threat you want to avoid ? If it is spoofed router advertisement
to all-nodes multicast address, conntrack helper is better.
It would expect advertisement with the specific destination address
(all-node multicast address or the link-local/global unicast address on=
 your
node), only when your node sends router solicitation (with the all-node
multicast address or the unicast address of router as destination addre=
ss).

But I don't recommend to block unsolicited router advertisement.
If many hosts block it on a link, that results in increasing traffic
on the link by solicitation. And hosts would not be able to know
the change of configuration on router in short time.

=46YI: IIRC SEcure Neighbor Discovery (SEND) is the current solution fr=
om
IETF guys, but I don't know the implementation for Linux.

-- Yasuyuki Kozakai

=46rom: Patrick McHardy <kaber@trash.net>
Date: Tue, 04 Nov 2008 15:06:55 +0100

> Marek Szuba wrote:
> > Hello everyone,
> >=20
> > Following a suggestion I was given at the kernel Bugzilla I am
> > forwarding this here.
> >=20
> > It has come to my attention lately that the only two ICMPv6 packet
> > types which IPv6 conntrack allows at present to initiate new
> > connections are "echo request" and "node information query"; all ot=
her
> > types appearing in this context are considered invalid. In particul=
ar,
> > this includes two neighbour-discovery types specified in RFC 2461:
> > "router solicitation" and "neighbour solicitation" - meaning that i=
f a
> > server drops all INVALID packets early in its INPUT or OUTPUT chain=
 of
> > IPv6 netfilter's filter table, neither of the two can be received f=
rom
> > clients. Given that router solicitation is used for stateless netwo=
rk
> > autoconfiguration and neighbour solicitation is an IPv6 equivalent =
of
> > ARP requests, having these two dropped can be quite bad - especiall=
y
> > the latter, as it pretty much kills IPv6 over Ethernet.
> >=20
> > Steps to reproduce:
> >=20
> > 1. Obtain an IPv6 address assigned to an Ethernet interface of host=
 A
> > (link-local will do);
> > 2. If necesssary, flush all ip6tables filter chains on host A and s=
et
> > their policies to ACCEPT;
> > 3. From host B on the same Ethernet network, ping6 the aforemention=
ed IP
> > address to verify that everything works;
> > 4. On host A, run something like "ip6tables -I INPUT 1 -m state --s=
tate
> > INVALID -j DROP";
> > 5. Try to repeat step 3. This time the ping should fail and counter=
s
> > associated with the aforementioned rule should increment;
> > 6. Repeat all the above using OUTPUT instead of INPUT, with the sam=
e
> > final result.
> >=20
> > BTW. This problem was discovered and (hopefully) fixed collaborativ=
ely
> > by =A3ukasz Stelmach <steelman@post.pl> and myself, please attribut=
e both
> > of us should the patch make it into code repositories.
> >=20
> > Attaching a proposed solution to the problem - the enclosed patch a=
dds
> > "router solicitation" and "neighbour solicitation" to the list of
> > ICMPv6 types IPv6 conntrack considers allowed to initiate new
> > connections. Note that in principle "router advertisement" ICMPv6
> > packets could also be considered valid-new, as e.g. radvd periodica=
lly
> > advertises its presence to the local network - as however it is not
> > necessary to let this through as new to have things work (plus we
> > aren't that big on broadcasting, even on supposedly-secure networks=
),
> > the patch only adds solicitations to the list.
>=20
> This patch seems fine to me. Yasuyuki, what do you think?
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
