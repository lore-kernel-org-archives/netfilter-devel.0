From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Tue, 24 Nov 2015 16:35:50 +0100
Message-ID: <20151124153550.GC20972@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-4-git-send-email-fw@strlen.de>
 <20151124102445.GE2683@salvia>
 <20151124103105.GE1740@breakpoint.cc>
 <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59304 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbbKXPfw convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 10:35:52 -0500
Content-Disposition: inline
In-Reply-To: <20151124152649.GK14478@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 24.11, Florian Westphal wrote:
> > We already have an attribute for verdicts, but that won't be enough.
> > Adding NFTA_TRACE_FILENAME/LINENO seems wrong to me since that would
> > be a pure development thing and we already have tools like perf probe
> > for that.
> 
> Yes absolutely. We have a few things that provide stable identifiers, f.i.
> hooks, helper names, protocol names, subsystems (conntrack/NAT/TCP names
> will not change), ...

Ok, so that should work within this proposed set, we would need to add
new attributes and types:

e.g. NFT_TRACETYPE_CT which then can set NFTA_TRACE_HELPER_NAME or any other
new attr we want/need.

> If we need more granularity we need to define some stable sub-identifiers.
> 
> > I don't see anything in the current proposal that would not allow to use
> > it for further netfilter trace events, however, at least for conntrack
> > i suspect it might make more sense to extend ctnetlink instead.
> 
> Sure, I'm just saying we should consider this. ctnetlink is more about
> ct events, not really about the packets.

Right.

> I just think it makes sense to
> have a unified view of tracing because you run into ordering issues if you
> send events using multiple subsystems. There's also a big advantage in
> being able to use a simple tool like nft for all your tracing needs compared
> to combining nft, nfnetlink_log and ctnetlink data to get the full picture.

Yes, I see.  This makes sense.  I'm withdrawing the ctnetlink comment.
We have extensions for nflog and nfqueue to serialize the CT object
entirely withing nfnetlink_log/queue, might also add
NFTA_TRACE_CT as a nested attribute that contains the entire ct object.

> I'm all for including all the data we need to get a good picture like you
> have now, I just want to make sure we don't make decisions that prevent us
> from extending it to other subsystems later on.

Ok.  Basically I'm going to ignore all of your comments here, since I
would first like to get the v1 'right' before extending it to more
subsystems.

IFF you see anything that prevents us from doing such extension, please
yell.  But AFAICS the proposed attributes and types should be fine wrt.
extensibility.

I'm going to add new netlink group for the trace events and will address
all the other comments.

Thanks for reviewing!
