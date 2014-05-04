From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC] Bridge: do not defragment packets unless connection
 tracking is enabled
Date: Mon, 5 May 2014 01:01:16 +0200
Message-ID: <20140504230116.GA3852@localhost>
References: <20140430092905.GA4318@localhost>
 <5363BC86.6050608@parallels.com>
 <20140502225522.GA12404@breakpoint.cc>
 <20140503233908.GA6297@localhost>
 <53669DC3.1050903@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Vasily Averin <vvs@parallels.com>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51022 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbaEDXBZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 19:01:25 -0400
Content-Disposition: inline
In-Reply-To: <53669DC3.1050903@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 04, 2014 at 10:06:27PM +0200, Bart De Schuymer wrote:
> If I understood Vasily correctly, in his setup ip_defrag is being
> called from code that isn't connection tracking. Glancing at the
> code, at least IP virtual server and the code that handles the
> router attention IP option also call ip_defrag.
> 
> Isn't there an easy way to see that the skb contains a defragmented
> IP packet? If there were, then it seems replacing the "skb->nfct !=
> NULL" by "is_defragmented(skb)" would suffice, no?

We didn't find any way that a packet larger than the mtu can hit that
code. The (re-)fragmentation only applies to a skb that fulfills
skb_has_frag_list(), so no need to restrict it.

> I see no reason to artificially restrict defrag/refrag to connection
> tracking.

After Vasily's patch, fragmentation/defragmentation on a bridge will
basically depend on if nf_defrag_ipv4 is loaded or not.
