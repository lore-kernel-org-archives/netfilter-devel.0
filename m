From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 23:52:56 +0100
Message-ID: <20151125225256.GL23215@breakpoint.cc>
References: <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35013 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752028AbbKYWw6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 17:52:58 -0500
Content-Disposition: inline
In-Reply-To: <20151125164629.GB30712@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > In case of ethernet, dst is first header field -- not sure if
> > we should re-order it so that src a:b.. dst d: .. is shown.
> > 
> > If you prefer to keep the real header ordering, then we don't
> > need to differentiate between these two.
> 
> I personally generally prefer what I perceive as "logical ordering", which
> is src, dst, ....

Same here.

> > Looks fantastic, I am leaning towards dropping the header formatting
> > from libnftl patch entirely.
> 
> I agree, we could drop the header part and only print the meta data. So we
> can see that something is happening and associate the events with decoded
> messages, but full decoding seems unnecessary.

I could also get rid of all formatting of course, i.e. remove the
libnftnl_trace_*printf functions, so libnftnl would just provide
the nftnl_trace struct to nftables frontend and the internal translation
of netlink messages to that struct.

> > The limitation (same as with my patch) is that if we don't know the
> > value then we cannot pretty-print that L2 header.
> > I don't think thats a problem, we can just move on to NH.
> 
> It depends, f.i. for bridging we can infer it from the hook values. In fact
> proto_ctx_init() already does that correctly for bridging.

Yes, this DEV_TYPE attribute is only included for NFPROTO_NETDEV where L2
could be anything ...

> > > +	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT))
> > > +		printf("verdict %u ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT));
> > 
> > I am working on this.
> > 
> > Dissecting the verdict will happen in libnftnl, so NFTNL_TRACE_VERDICT will return
> > a verdict without extra information.
> > 
> > I'll add NFTNL_TRACE_NFQUEUE_ID to store the upper 16 bits for QUEUE verdicts.
> 
> I don't think that's necessary. All the other verdict parts (actually nft_data)
> simply return the numeric verdict code and also accept them, both for encoded
> DROP_ERRNOS and queue numbers. Is there any reason to diverge from this?

Hmm, to clarify:  The kernel will dump the verdict as-is.
But I don't see why nftables (nft) should have to start dissecting this
to e.g. get the nfqueue number.  So I'd rather put something like the
following into libnftnl and provide accessors for nft rather than
stuff it into the frontend tool:

verdict = mnl_get_ (netlink_data);
switch (verdict) {
case NFT_GOTO:
case NFT_JUMP: t->targetchain = get_target_chain(netlink_data);
case NFT_CONTINUE:
// all other known verdicts here
	trace->verdict = verdict;
	break;
default: /* unknown verdict, or extra data in upper bits */
     switch (verdict & 0xff) {
     case NF_QUEUE:
        trace->verdict = verdict & 0xff;
        trace->queue_id = verdict >> 16;
        break;
     }
 }

Without it, simple tasks like 'translate verdict to string' in nft
require extra exercise to strip away the irrelevant parts of the
verdict code.

Does that seem reasonable?
