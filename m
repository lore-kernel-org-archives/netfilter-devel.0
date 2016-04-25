From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 12:16:39 +0100
Message-ID: <20160425111638.GB30849@macbook.localdomain>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
 <20160425105909.GC28797@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55141 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbcDYLQo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 07:16:44 -0400
Content-Disposition: inline
In-Reply-To: <20160425105909.GC28797@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.04, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > On 21.04, Florian Westphal wrote:
> > > Pablo suggested to re-use the immediate attributes already used by
> > > nft_immediate, nft_bitwise and nft_cmp to re-use as much code as
> > > possible.
> > > 
> > > Just add new NFTA_CT_IMM that contains nested data attributes.
> > > We can then use nft_data_init and nft_data_dump for this as well.
> > 
> > What's the argument against using immediate and a register?
> 
> http://marc.info/?l=netfilter-devel&m=145800804914781&w=2
> 
> <quote>
> > However, with nft, the input is just a register with arbitrary runtime
> > content.
> > 
> > We therefore ask for the upper ceiling we currently have, which is
> > enough room to store 128 bits.
> 
> We can probably allow passing the label value as attribute to the
> nft_ct expression so you don't have to use the upper ceiling. Patrick
> suggested something similar for nft_ct set helper support.
> </unqote>

Helpers are somewhat special because we need to load the modules and get
a reference to the helper structure, so we need the context of what the
immediate will be used for. I'd certainly prefer not to use immediates
since that means we'll need a single rule per assignment. Especially with
helpers it seems a lot nicer to simply use a map.

The alternative to internally handling it would be to some propagating
validation to immediates / sets which invoke the actual user of the data.
So in the case of helpers, we could replace the name by references to
the helper structures and reverse this during dumping.

Regarding connlabels this doesn't really apply though. We expect userspace
to create a reasonable ruleset and anything that does not cause critical
errors is validated in userspace.

> > > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > > index 4f66cb9..a461c3e 100644
> > > --- a/net/netfilter/nft_ct.c
> > > +++ b/net/netfilter/nft_ct.c
> > > @@ -31,6 +31,15 @@ struct nft_ct_reg {
> > >  	};
> > >  };
> > >  
> > > +struct nft_ct_imm {
> > > +	enum nft_ct_keys	key:8;
> > > +	union {
> > > +		u8		set_bit;
> > > +	} imm;
> > > +	unsigned int		imm_len:8;
> > > +	struct nft_data		immediate;
> > 
> > Is this really needed? It should be possible to reconstruct from the bit, no? 
> 
> Yes, I can change that but it seemed much more simple to just stash the
> original value/length and dump that via
> 
> 	if (nft_data_dump(skb, NFTA_CT_IMM, &priv->immediate,
> 		  NFT_DATA_VALUE, priv->imm_len) < 0)
> 
> Rather than rebuilding nft_data for all supported keys
> (right now its only one, but there was interest to add helper assignment
>  support too).

Well, we try to keep the runtime data as compact as possible, so if it is
not *really* needed, I'd suggest reconstructing it.

> > > +	err = nft_ct_l3proto_try_module_get(ctx->afi->family);
> > > +	if (err < 0)
> > > +		return err;
> > 
> > What about the inet table?
> 
> nft_ct_l3proto_try_module_get() dispatches to IPV4 and IPV6 if
> afi->family is INET.

I wasn't aware of that. That's what I would have suggested to do instead :)

> > > +#ifdef CONFIG_NF_CONNTRACK_LABELS
> > > +	case NFT_CT_LABELS:
> > > +		err = -EINVAL;
> > > +		if (tb[NFTA_CT_DIRECTION] || priv->imm_len != sizeof(u32))
> > 
> > Why do we need to store imm_len if the size is fixed?
> 
> We don't, but then dumping would be something like
> 
> struct nft_data         immediate = {};
> 
> switch (key) {
> case NFT_CT_LABELS:
> 	size = sizeof(u32);
> 	immedate.data[0] = htonl(priv->immediate.data[0]);
> 	break;
> case ...
> }
> 
> if (nft_data_dump(skb, NFTA_CT_IMM, &immediate,
>                   NFT_DATA_VALUE, size)) ...
> 
> If that is preferred I can change it accordingly.

Same argument as for the immediate data, we want to keep the size to the
absolute minimum. Storing a fixed value seems rather wasteful.
