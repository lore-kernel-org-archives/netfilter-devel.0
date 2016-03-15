From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/3] netfilter: nftables: add connlabel set
 support
Date: Wed, 16 Mar 2016 00:09:21 +0100
Message-ID: <20160315230921.GD8185@breakpoint.cc>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
 <1458058211-11147-2-git-send-email-fw@strlen.de>
 <20160315170813.GA25284@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56016 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136AbcCOXJW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 19:09:22 -0400
Content-Disposition: inline
In-Reply-To: <20160315170813.GA25284@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Mar 15, 2016 at 05:10:09PM +0100, Florian Westphal wrote:
> > Instead of taking the value to set from a source register, userspace
> > passes the bit that we should set as a netlink attribute.
> > 
> > This follows a similar approach that xtables 'connlabel'
> > match uses, so when user inputs
> > 
> >     ct label set bar
> 
> I think we can introduce:
> 
>         ct label bitset bar
> 
> so this is clear to the user this is just setting the bit at that
> position.

I don't like this one bit ;)

Seriously, I think "label set bar" is fine.

We already treat "ct label foo" correctly without
using "ct label testbit foo", so I like it better
without the extra special-case "bitset" keyword.

> > @@ -777,6 +778,7 @@ enum nft_ct_attributes {
> >  	NFTA_CT_KEY,
> >  	NFTA_CT_DIRECTION,
> >  	NFTA_CT_SREG,
> > +	NFTA_CT_LABEL,
> 
> We can probably add:
> 
>         NFTA_CT_IMM

Right, we can derive the exact type based on the key.

> This would be a nested attribute, then inside there we can define the:
> 
>         NFTA_CT_LABEL

Hmm, why a nested attribute?
What do we gain from that?

Do you want the nested attr so that we can define policies
for the "immediate subtypes"...?

If its the latter, then ok.

I'd then suggest adding a new enum, for instance:

NFTA_CT_IMM_LABEL

That appear as nested attrs inside the NFTA_CT_IMM one.

> > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > index d4a4619..76da69d 100644
> > --- a/net/netfilter/nft_ct.c
> > +++ b/net/netfilter/nft_ct.c
> > @@ -29,6 +29,7 @@ struct nft_ct {
> >  		enum nft_registers	dreg:8;
> >  		enum nft_registers	sreg:8;
> >  	};
> > +	u8			set_label_bit;
> 
> I understand a specific nft_ct_label is too much at this stage, so:
> 
>         union {
>                 u8                      set_label_bit;
>         } imm;

Right, using union imm looks good.

I'll rework this tomorrow, thanks for the quick review.
