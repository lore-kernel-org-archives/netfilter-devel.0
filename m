From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH RFC] Bridge: do not defragment packets unless connection
 tracking is enabled
Date: Sun, 04 May 2014 22:06:27 +0200
Message-ID: <53669DC3.1050903@pandora.be>
References: <20140430092905.GA4318@localhost> <5363BC86.6050608@parallels.com> <20140502225522.GA12404@breakpoint.cc> <20140503233908.GA6297@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Vasily Averin <vvs@parallels.com>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:50198 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaEDUGf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 16:06:35 -0400
In-Reply-To: <20140503233908.GA6297@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso schreef op 4/05/2014 1:39:
> I think we still may see IP packets larger than the mtu in that path.
> It would be a rare case since we need that the bridge has different
> (smaller) mtu than the sender, but still possible. The is_skb_forwardable()
> check in the current tree snapshot comes just a bit later, so if we
> remove that skb->nfct, the bridge will fragment large packets.
>
> In general, I believe bridges should silently drop packets that are
> larger than the mtu and they should perform no fragmentation handling,
> no gathering and no [re]fragmentation. They are transparent devices
> that operate at layer 2.

I agree. I don't think it's a good idea to commit code that would do 
fragmentation of IP packets that weren't defragmented first.

> The conntrack case is a special case that forces us to enable
> fragmentation handling since we get sort of a bridge that inspects
> layer 3 and 4 packet information. So we have sort of, let's call it, a
> mutant bridge.
>
> We also have the tproxy target and the socket match, they seem to
> require defragmentation as well, I'm afraid the skb->nfct check will
> not help for those cases. I think that we need some counter to know
> how many clients we have that require the gathering + fragmentation
> code, so if we have at least one, we have to enable it.

If I understood Vasily correctly, in his setup ip_defrag is being called 
from code that isn't connection tracking. Glancing at the code, at least 
IP virtual server and the code that handles the router attention IP 
option also call ip_defrag.

Isn't there an easy way to see that the skb contains a defragmented IP 
packet? If there were, then it seems replacing the "skb->nfct != NULL" 
by "is_defragmented(skb)" would suffice, no?
I see no reason to artificially restrict defrag/refrag to connection 
tracking.

cheers,

Bart

