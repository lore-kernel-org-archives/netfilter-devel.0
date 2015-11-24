From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 11:27:07 +0100
Message-ID: <20151124102707.GC1740@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124101705.GB2683@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58436 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967AbbKXK1I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:27:08 -0500
Content-Disposition: inline
In-Reply-To: <20151124101705.GB2683@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Nov 24, 2015 at 11:02:06AM +0100, Florian Westphal wrote:
> > nft monitor mode can then decode and display this trace data.
> > 
> > Parts of LL/Network/Transport headers are provided as separate
> > attributes.
> > 
> > Otherwise, printing IP address data becomes virtually impossible
> > for userspace since in the case of the netdev family we really don't
> > want userspace to have to know all the possible link layer types
> > and/or sizes just to display/print an ip address.
> > 
> > We also don't want userspace to have to follow ipv6 header chains
> > to get the s/dport info, the kernel already did this work so just
> > follow suit.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  include/net/netfilter/nf_tables.h        |   6 +
> > +static bool trace_notify_put_data(struct sk_buff *nlskb, u16 type,
> > +				  const struct sk_buff *skb,
> > +				  int off, unsigned int plen)
> 
> Minor nitpick: Probably you can rename this to _fill_*_info for
> consistency with other nf_tables netlink code.

Sure, will do.

> Do you think we can place all this new netlink code in
> net/netfilter/nf_tables_trace.c ? So we leave in the core file only
> our classifier engine.
> 
> I like the attribute definition rename in nf_tables.h, but this code
> we can probably place it away from here.

Ok, I'll see if this is doable without exporting half a dozen of
symbols.

> >  static int nf_tables_table_notify(const struct nft_ctx *ctx, int event)
> >  	case NFT_RETURN:
> > -		nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RETURN);
> > +		if (stackptr)
> 
> Why this new branch?

Right, I should move it to extra patch.  I think its buggy without the
extra if (stackptr) test.

If stackptr is 0, then we're returning from a base chain, i.e.
the policy is evaluated and we have another trace for that.

For old code its not really imporant if rulenum counter is wrong/off,
but for the new infra its important that the *rule ptr is valid.
