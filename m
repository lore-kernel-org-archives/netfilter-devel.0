From: Patrick McHardy <kaber@trash.net>
Subject: Re: Add seperated timeout for the connections that only receive
 packets in one direction
Date: Mon, 30 Nov 2009 12:10:04 +0100
Message-ID: <4B13A80C.6070607@trash.net>
References: <4B0FA3AA.4070702@trash.net> <4B0FBC5F.8030108@trash.net> <412e6f7f0911292039v74b89b4cieca5e2a043bad43d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47608 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZK3LKD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:10:03 -0500
In-Reply-To: <412e6f7f0911292039v74b89b4cieca5e2a043bad43d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> On Fri, Nov 27, 2009 at 7:47 PM, Patrick McHardy <kaber@trash.net> wrote:
>> They don't need to forward anything, conntrack handles the packet before
>> routing.
>>
> 
> Think about this topologic:
> 
> Attacker -> router1 -> router2 -> ... -> Linux Router -> Apache.
> 
> the packets in the other direction won't be sent to the Linux Router,
> as the other routers will routed them to the other place.

Yes, in that case it could help.

> Case 2:
> 
> Attacker ---+
>                 +-- Linux Router --> WAN
> Victim-------+
> 
> If we do sth. like RPF before entering conntrack, the packets in the
> other direction won't be in.

RPF doesn't help since its also done after conntrack.

