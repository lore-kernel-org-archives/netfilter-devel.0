From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 23:30:44 +0000
Message-ID: <20151125233043.GF20093@macbook.localdomain>
References: <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
 <20151125173240.GG30712@macbook.localdomain>
 <20151125222710.GK23215@breakpoint.cc>
 <20151125230412.GB20093@macbook.localdomain>
 <20151125231648.GM23215@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:62600 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750972AbbKYXar (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 18:30:47 -0500
Content-Disposition: inline
In-Reply-To: <20151125231648.GM23215@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > > True, good point.  In that case I would propose to get rid of "packet"
> > > message type completely.
> > > 
> > > Instead we'd include all the info that we currently have in "packet"
> > > (i.e. vlanid, headers) on the first message type fired on each nft_do_chain()
> > > invocation.
> > > 
> > > We can also move IIF/OIF info to this 'initial' message
> > > (which might be of any type depending on the ruleset, due to POLICY
> > >  type we would however always send at least one, even if there are no
> > >  matches).
> > > 
> > > The price to be paid would be a new variable that we have to keep
> > > on-stack to know when we can elide the extra packet data.
> > > 
> > > Does that sound reasonable?
> > 
> > Sure, but is that really easier than including an unconditional (well,
> > skb->nf_trace == 1) call to nf_tables_trace_notify() before entering
> > the main loop? I don't see anything wrong the the packet message itself,
> > just thinking it might be useful to emit one more in this specific
> > spot.
> 
> Its not easier, but it will keep the number of messages lower.
> 
> AFAIU with nf_tables_trace_notify() for each nft_do_chain() we will
> have one more message for each table/hook combo...  Hmm...

Yeah that's really a bit unfortunate since we actually only care about the
first chain on every hook I guess. Basically once per hook, but it seems we
really need to use once per base chain unless we go deeper down in the stack.

> I I'll see how painful the extra test for 'i have sent packet data
> for this nft_do_chain invocation' is, if its too complicated
> I'll move the nf_tables_trace_notify from nft_meta to nft_do_chain.
> 
> Let me know in case you spot a problem with that rationale.

No, that seems reasonable to me.
