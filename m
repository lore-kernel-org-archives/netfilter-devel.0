From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: marking IPv6 packets sends them to the wrong interface
Date: Mon, 24 Jan 2011 14:46:57 +0100
Message-ID: <4D3D82D1.6050305@trash.net>
References: <20110123122108.GA30305@darkside.kls.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63335 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1AXNrD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:47:03 -0500
In-Reply-To: <20110123122108.GA30305@darkside.kls.lan>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.01.2011 13:21, Mario 'BitKoenig' Holbe wrote:
> Hello,
> 
> I have a strange issue with netfilter MARK on IPv6 which I cannot
> explain and which I believe to be a kernel bug:
> If I mark outgoing IPv6 packets they appear to be transmitted via the
> wrong physical interface. At least multicast packets - at least some of
> them.
> 
> I'm running a Linux-based router with two local interfaces and radvd
> advertises stateless autoconfiguration information on them.
> If I mark all outgoing IPv6 packets, after some time all hosts on both
> subnets appear to be autoconfigured for both subnets, i.e. they all have
> two IPv6 addresses - one of each subnet and two default routes - one for
> each router interface. Of course, only one of them really works on each
> host.
> 
> The gateway does pretty normal routing, no routing policies,
> particularly no fwmark rules, does no bridging or something like that.
> The network interfaces are Intel driven by e100.
> 
> The following debug session is done with a 2.6.32 kernel, the condensed
> packet information originates from tcpdump:
> 
> Without marking everything runs as it should be.
> Marking eth0 packets results in all advertisements transmitted via eth1.
> The behaviour goes back to normal as soon as the marking disappears.
> Marking eth1 packets doesn't appear to change the normal behaviour at
> the first glance, but with that I experience hiccups after some time of
> inactivity (i.e. from time to time ping6 from one subnet to the other
> gets no answers for the first 6 to 8 packets). 
> 
> I also tried marking with 0xff00 instead of 1 - same results.
> I tested this on kernels 2.6.26, 2.6.32, and 2.6.37 - all show the same
> behaviour.

That probably means that we're not using the correct keys
when rerouting in ip6_route_me_harder(). Just for testing,
please try to disable the ip6_route_me_harder() call in
net/ipv6/netfilter/ip6table_mangle.c::ip6t_mangle_out().

