From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Thu, 26 Nov 2015 00:16:48 +0100
Message-ID: <20151125231648.GM23215@breakpoint.cc>
References: <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
 <20151125173240.GG30712@macbook.localdomain>
 <20151125222710.GK23215@breakpoint.cc>
 <20151125230412.GB20093@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35052 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbbKYXQu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 18:16:50 -0500
Content-Disposition: inline
In-Reply-To: <20151125230412.GB20093@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > True, good point.  In that case I would propose to get rid of "packet"
> > message type completely.
> > 
> > Instead we'd include all the info that we currently have in "packet"
> > (i.e. vlanid, headers) on the first message type fired on each nft_do_chain()
> > invocation.
> > 
> > We can also move IIF/OIF info to this 'initial' message
> > (which might be of any type depending on the ruleset, due to POLICY
> >  type we would however always send at least one, even if there are no
> >  matches).
> > 
> > The price to be paid would be a new variable that we have to keep
> > on-stack to know when we can elide the extra packet data.
> > 
> > Does that sound reasonable?
> 
> Sure, but is that really easier than including an unconditional (well,
> skb->nf_trace == 1) call to nf_tables_trace_notify() before entering
> the main loop? I don't see anything wrong the the packet message itself,
> just thinking it might be useful to emit one more in this specific
> spot.

Its not easier, but it will keep the number of messages lower.

AFAIU with nf_tables_trace_notify() for each nft_do_chain() we will
have one more message for each table/hook combo...  Hmm...

I I'll see how painful the extra test for 'i have sent packet data
for this nft_do_chain invocation' is, if its too complicated
I'll move the nf_tables_trace_notify from nft_meta to nft_do_chain.

Let me know in case you spot a problem with that rationale.

Thanks!
