From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match
Date: Fri, 4 Jul 2008 01:02:02 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807040054120.1890@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu> <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031425530.1816@blackhole.kfki.hu>
 <alpine.LNX.1.10.0807031511310.23294@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031517350.1816@blackhole.kfki.hu> <alpine.LNX.1.10.0807031612330.23294@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807032348310.3107@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41926 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbYGCXCF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:02:05 -0400
In-Reply-To: <Pine.LNX.4.64.0807032348310.3107@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-07-04 00:02, Jozsef Kadlecsik wrote:
>> 
>> User-defines chains return to the main chain once control runs off
>> their end. Since the main chain has a default policy, I do not see
>> aproblem.
>
>That means we'd not support multiple routing tables with default
>routes. We'd loose an important functionality, which is
>unacceptable.

Routing tables become xtables chains. We would not lose anything.
In fact, you would gain the possibilty to jump to further chains,
something not possible in routing today.

rt input:

ip rule fwmark 5 table 5
ip rule fwmark 6 table 6
ip route add 10.10.96.2/32 dev eth2 table 5
ip route add via 10.10.96.1 dev eth0 table 5 # default route
ip route add via 10.11.96.1 dev eth1 table 6 # default orute

in xtables (ROUTE is a terminating target):

-N table5
-N table6
-A table5 -d 10.10.96.2 -j ROUTE --dev eth2
-A table5 -j ROUTE --via 10.10.96.1 --dev eth0  # default route!
-A table6 -j ROUTE --via 10.11.96.1 --dev eth1  # also a default
-A ROUTING -m mark --mark 5 -j table5
-A ROUTING -m mark --mark 6 -j table6


>> Because traditional routing tables can have no default route,
>> xtables should not be forced to have one either.
>
>Routing tables can have default route. Most of the time this is the main 
>point when using multiple routing tables: source routing via another
>default route.

It is very easy to not have a default gateway.

ip route flush
ip route add 10.10.96.0/20 dev eth0

Try pinging 134.76.12.5 with that. Will fail with Network Unreachable.
The xtables representation henceforth:

-A ROUTING -d 10.10.96.0/20 -j ROUTE --dev eth0
-A ROUTING -j ROUTE --unreachable

or alternatively something like -P ROUTING UNREACHABLE.
