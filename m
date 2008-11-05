From: Marek Szuba <Marek.Szuba@if.pw.edu.pl>
Subject: Re: IPv6 conntrack support for neighbour discovery
Date: Wed, 5 Nov 2008 13:35:08 +0100
Message-ID: <20081105133508.67b25090@hiperon.ws.hirg>
References: <20081030145218.5395c3fe@hiperon.ws.hirg>
	<491056FF.8030801@trash.net>
	<200811050444.mA54i7XU020102@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from student.if.pw.edu.pl ([194.29.174.5]:53877 "EHLO
	student.if.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYKEMfU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 07:35:20 -0500
In-Reply-To: <200811050444.mA54i7XU020102@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 05 Nov 2008 13:44:05 +0900 (JST)
Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> wrote:

> In short: nf_conntrack_proto_icmpv6.c does not help for protocols
> using their messages. conntrack helper is better.
So what you are suggesting is, someone needs to write such a helper
module. Correct?

> In the first place, static configuration is better for their messages.
Do you mean pre-filling neighbour-discovery cache? If so, I agree with
you on this as far as router discovery is concerned but I don't think
such an approach is viable with neighbour discovery, except possibly on
very small and centrally-managed LANs - any addition or removal of
hosts and/or addresses on the network would require propagating the
change to all machines on it.

> Even if you add their ICMPv6 types to nf_coonntrack_proto_icmpv6.c,
> you will need to configure rules to allow IPv6 stack to receive
> Router/Neighbor Solicitation/Advertisement with all-node or solicited
> multicast address.
True. To be honest, some no-nonsense documentation of what data an IPv6
host must receive/return on what address in order to actually exist on
the network is clearly in order here... I've been working with
setting up IPv6 on various networks for quite a while and it takes much
more work here than with IPv4 to set up a "what isn't explicitly
allowed is forbidden" policy.

> For example, IPv6 node sends neighbor solicitation to
> solicited multicast address to resolve L2 address. If you block it
> on your node, then other nodes (including routers) cannot resolve
> L2 address of your node.
This is precisely the problem I have encountered here.

> What threat you want to avoid ? If it is spoofed router advertisement
> to all-nodes multicast address, conntrack helper is better.
I wasn't trying to avoid any specific threat here, it's just that my
iptables rules always contain a rule which kills packets with state
INVALID and in case of IPv6 on a LAN this breaks resolving of L2
addresses.

> But I don't recommend to block unsolicited router advertisement.
> If many hosts block it on a link, that results in increasing traffic
> on the link by solicitation. And hosts would not be able to know
> the change of configuration on router in short time.
Fair enough.

> FYI: IIRC SEcure Neighbor Discovery (SEND) is the current solution
> from IETF guys, but I don't know the implementation for Linux.
I haven't seen any such implementations yet, then again this doesn't
mean there are none of course.

-- 
MS
