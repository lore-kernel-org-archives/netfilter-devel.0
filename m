From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 16:15:42 +0100
Message-ID: <20151124151542.GA20972@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
 <20151124102445.GE2683@salvia>
 <20151124103105.GE1740@breakpoint.cc>
 <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59241 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbbKXPPp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 10:15:45 -0500
Content-Disposition: inline
In-Reply-To: <20151124113341.GO2310@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:

Sorry for late reply.

> >  chain ct_trace {
> > 	 type filter hook prerouting priority 0;
> > 	 tcp dport 22 ct state new label set trace
> > 	 ct label trace meta set nftrace 1
> >  }
> > 
> >  chain ct_trace_out {
> > 	 type filter hook output priority 0;
> > 	 ct label trace meta set nftrace 1
> >  }
> > 
> > Which would do in/out tracing without any additional code
> > (except the label set support, of course).
> 
> That's of course one possibilty but it lacks one important point, we could
> not trace the first packet going through conntrack.

Right, hooks that run 'earlier' than conntrack would not be able to
use ct state matching.

I'm not sure if thats a real issue, we could just use stateless matching
based on ip addresses and ports.

Lastly, I do think that we'll eventually have a ct expression to
actually do tracking for us rather than the implicit hooking we have
right now (my plan was to add this for nft bridge family conntrack
support).

> > I think we would first have to identify possible interesting tracing points.
> > Did you have anything specific in mind?
> 
> I guess the hooks themselves, probably helper invocation and/or results,
> possibly interesting points within helpers, errors in protocol tracking,
> basically I think a good starting point would be what we now have as global
> tracing points.

Ok, I see.  I'll think about this some more.

But I don't see why we could not build it upon the proposed
infrastructure; we do not have a rule handle and we might need to add
further attributes to identify where exactly we are at the moment.

In the patchset proposed here, 'where we are' is defined like this:

NFT_TRACETYPE_PACKET -> in a nft meta rule
(this trace type is followed by NFT_TRACETYPE_RULE one and only exists
 so we don't include packet data all the time.)
Alternative would be to remove NFT_TRACETYPE_PACKET and
always include payload info instead.

NFT_TRACETYPE_RULE   -> contains rule handle to figure out where we are
NFT_TRACETYPE_RETURN -> also contains rule handle
NFT_TRACETYPE_POLICY -> no rule handle, 'only' chain and table name

IOW, the current types are very much bolted to rule evaulation.

To support ct/helper etc. events  we would need to add new types, e.g.
NFT_TRACETYPE_CT, NFT_TRACETYPE_CT_L3PROTO, ... or whatever.

Main problem I see is how the 'where we are' info should be provided
and how to include what is happening.

We already have an attribute for verdicts, but that won't be enough.
Adding NFTA_TRACE_FILENAME/LINENO seems wrong to me since that would
be a pure development thing and we already have tools like perf probe
for that.

I don't see anything in the current proposal that would not allow to use
it for further netfilter trace events, however, at least for conntrack
i suspect it might make more sense to extend ctnetlink instead.
