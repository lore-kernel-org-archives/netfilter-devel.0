From: Patrick McHardy <kaber@trash.net>
Subject: Re: IPv6 conntrack support for neighbour discovery
Date: Wed, 05 Nov 2008 10:50:29 +0100
Message-ID: <49116C65.7030405@trash.net>
References: <20081030145218.5395c3fe@hiperon.ws.hirg>	<491056FF.8030801@trash.net> <200811050444.mA54i7F8028119@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Marek.Szuba@if.pw.edu.pl, netfilter-devel@vger.kernel.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33415 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbYKEJug (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:50:36 -0500
In-Reply-To: <200811050444.mA54i7F8028119@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yasuyuki KOZAKAI wrote:
>> This patch seems fine to me. Yasuyuki, what do you think?
> 
> In short: nf_conntrack_proto_icmpv6.c does not help for protocols using
> their messages. conntrack helper is better.
> 
> 
> In detail:
> 
> A solicitation and advertisement does not construct 'connection'
> in most cases. Because the destination of solicitation is typically
> multicast address, and the source address of advertisement for replying is
> typically unicast address.
> 
> In the first place, static configuration is better for their messages.
> 
> Even if you add their ICMPv6 types to nf_coonntrack_proto_icmpv6.c,
> you will need to configure rules to allow IPv6 stack to receive
> Router/Neighbor Solicitation/Advertisement with all-node or solicited
> multicast address.
> 
> For example, IPv6 node sends neighbor solicitation to
> solicited multicast address to resolve L2 address. If you block it
> on your node, then other nodes (including routers) cannot resolve
> L2 address of your node. Also Duplicated Address Detection (DAD) does not
> work.
> 
> What threat you want to avoid ? If it is spoofed router advertisement
> to all-nodes multicast address, conntrack helper is better.
> It would expect advertisement with the specific destination address
> (all-node multicast address or the link-local/global unicast address on your
> node), only when your node sends router solicitation (with the all-node
> multicast address or the unicast address of router as destination address).
> 
> But I don't recommend to block unsolicited router advertisement.
> If many hosts block it on a link, that results in increasing traffic
> on the link by solicitation. And hosts would not be able to know
> the change of configuration on router in short time.
> 
> FYI: IIRC SEcure Neighbor Discovery (SEND) is the current solution from
> IETF guys, but I don't know the implementation for Linux.

Thanks for the detailed explanation.

Marek, could you close the bugzilla report with a link to
Yasuyuki's explanation please? Thanks!
