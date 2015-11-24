From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 10:53:00 +0000
Message-ID: <20151124105300.GK2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
 <20151124102445.GE2683@salvia>
 <20151124103105.GE1740@breakpoint.cc>
 <20151124103938.GB3014@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44774 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbbKXKxF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:53:05 -0500
Content-Disposition: inline
In-Reply-To: <20151124103938.GB3014@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Pablo Neira Ayuso wrote:
> On Tue, Nov 24, 2015 at 11:31:05AM +0100, Florian Westphal wrote:
> > > > +		if (nfnetlink_has_listeners(pkt->net, NFNLGRP_NFTABLES))
> > > > +			prefer_native_trace = true;
> > > > +		else
> > > > +			__nft_trace_packet(pkt, chain, rulenum, type);
> > > 
> > > For this very specific case I prefer a sysctl that we can remove
> > > moving forward, then remove this code and default to the new tracing
> > > infrastructure once we have indications that adoption of this new
> > > tracing infrastructure has been massively adopted instead of the
> > > existing one.
> > 
> > So you're saying
> > 
> > sysctl nft_old_trace = 1;
> > 
> > and then do
> > 
> > nf_tables_trace_notify(..)
> > if (nft_old_trace)
> > 	__nft_trace_packet();
> > 
> > ?
> 
> What I'm trying to avoid is the initial race that we'll have.
> 
> I mean, with this approach the user will likely enable the tracing
> from the rule, then will launch nft trace. In that case, he will be
> getting traces from the old way for a little while until you get one
> process subscribed to this.

On more thing to consider it interaction with other netfilter subsystems.

F.i. I think it would be very useful to have per connection tracing, so
we'd store a flag in the nfct and transfer it to every packet. This would
make them show up in the nft ruleset, but what about tracing in specific
points of conntrack/NAT itself? Can we send them to the same group and
make them integrate with ruleset tracing?
