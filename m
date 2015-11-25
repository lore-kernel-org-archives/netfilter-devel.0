From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Wed, 25 Nov 2015 11:13:29 +0100
Message-ID: <20151125101329.GH23215@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151125005523.GB27315@macbook.localdomain>
 <20151125083907.GF23215@breakpoint.cc>
 <20151125093554.GA31023@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:32959 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbbKYKNb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 05:13:31 -0500
Content-Disposition: inline
In-Reply-To: <20151125093554.GA31023@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > > > +     if (nla_put_be32(skb, NFTA_TRACE_ID, htonl(hash32_ptr(pkt->skb)))) 
> > 
> > > This could lead to duplicate IDs quite quickly. I can't think of any other
> > > values where we know for sure they will stay constant while the skb is within
> > > netfilter. How about combining this with a per CPU counter or something
> > > similar?
> > 
> > I would not mind, it would result in ID change though for nfqueue case.
> > If thats ok I'll use a pcpu counter that gets incremented when nft_meta
> > sets skb->nftrace=1 and use __this_cpu_read(trace_id) instead (if we
> > have pcpu id counter, is there any point in also using skb address...?)
> 
> Not sure, I guess not.

Ok, I'll move to pcpu id counter in v2

> > > > +	switch (type) {
> > > > +	case NFT_TRACETYPE_POLICY:
> > > > +	case NFT_TRACETYPE_RETURN:
> > > > +	case NFT_TRACETYPE_RULE:
> > > > +		if (nla_put_be32(skb, NFTA_TRACE_VERDICT, htonl(verdict)))
> > > > +			goto nla_put_failure;
> > > 
> > > It would be nice to have the full verdict available, IOW also the jump target.
> > > 
> > > You could simply pass struct nft_verdict to this function and adapt
> > > nft_verdict_dump() to take the attribute value as parameter.
> > 
> > Will add NFTA_TRACE_JUMP/NFTA_TRACE_GOTO for that, ok?
> 
> Any reason not to use the standard verdict encoding? We even have an almost
> ready to use function for that.

Sorry, could you be more specific?
How would you tell userspace where the jump/goto is going to?

What I am doing now in my local version:

NFTA_TRACE_VERDICT is the verbatim result of the hook (i.e. might
contain errno or queue id).

NFTA_TRACE_JUMP_TARGET is the name of the chain that we goto or jump to,
set when verdict == NFT_JUMP/_GOTO.

Alternative suggestions welcome.

This approach means that userspace must try a bit harder to decode
the verdict since we cannot use 'verdict & NF_VERDICT_MASK' if we're
looking at a NFT_* verdict when translating the integer to a string.
