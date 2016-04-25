From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 12:59:09 +0200
Message-ID: <20160425105909.GC28797@breakpoint.cc>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60026 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbcDYK7N (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 06:59:13 -0400
Content-Disposition: inline
In-Reply-To: <20160425103522.GB29560@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 21.04, Florian Westphal wrote:
> > Instead of taking the value to set from a source register, userspace
> > passes the bit that we should set as an immediate netlink value.
> > 
> > This follows a similar approach that xtables 'connlabel'
> > match uses, so when user inputs
> > 
> >     ct label set bar
> > 
> > then we will set the bit used by the 'bar' label and leave the rest alone.
> > Pablo suggested to re-use the immediate attributes already used by
> > nft_immediate, nft_bitwise and nft_cmp to re-use as much code as
> > possible.
> > 
> > Just add new NFTA_CT_IMM that contains nested data attributes.
> > We can then use nft_data_init and nft_data_dump for this as well.
> 
> What's the argument against using immediate and a register?

http://marc.info/?l=netfilter-devel&m=145800804914781&w=2

<quote>
> However, with nft, the input is just a register with arbitrary runtime
> content.
> 
> We therefore ask for the upper ceiling we currently have, which is
> enough room to store 128 bits.

We can probably allow passing the label value as attribute to the
nft_ct expression so you don't have to use the upper ceiling. Patrick
suggested something similar for nft_ct set helper support.
</unqote>

> > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > index 4f66cb9..a461c3e 100644
> > --- a/net/netfilter/nft_ct.c
> > +++ b/net/netfilter/nft_ct.c
> > @@ -31,6 +31,15 @@ struct nft_ct_reg {
> >  	};
> >  };
> >  
> > +struct nft_ct_imm {
> > +	enum nft_ct_keys	key:8;
> > +	union {
> > +		u8		set_bit;
> > +	} imm;
> > +	unsigned int		imm_len:8;
> > +	struct nft_data		immediate;
> 
> Is this really needed? It should be possible to reconstruct from the bit, no? 

Yes, I can change that but it seemed much more simple to just stash the
original value/length and dump that via

	if (nft_data_dump(skb, NFTA_CT_IMM, &priv->immediate,
		  NFT_DATA_VALUE, priv->imm_len) < 0)

Rather than rebuilding nft_data for all supported keys
(right now its only one, but there was interest to add helper assignment
 support too).

> > +	err = nft_ct_l3proto_try_module_get(ctx->afi->family);
> > +	if (err < 0)
> > +		return err;
> 
> What about the inet table?

nft_ct_l3proto_try_module_get() dispatches to IPV4 and IPV6 if
afi->family is INET.

> > +#ifdef CONFIG_NF_CONNTRACK_LABELS
> > +	case NFT_CT_LABELS:
> > +		err = -EINVAL;
> > +		if (tb[NFTA_CT_DIRECTION] || priv->imm_len != sizeof(u32))
> 
> Why do we need to store imm_len if the size is fixed?

We don't, but then dumping would be something like

struct nft_data         immediate = {};

switch (key) {
case NFT_CT_LABELS:
	size = sizeof(u32);
	immedate.data[0] = htonl(priv->immediate.data[0]);
	break;
case ...
}

if (nft_data_dump(skb, NFTA_CT_IMM, &immediate,
                  NFT_DATA_VALUE, size)) ...

If that is preferred I can change it accordingly.
