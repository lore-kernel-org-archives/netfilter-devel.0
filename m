From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: oob crash w. verdict maps & jumps
Date: Tue, 14 Apr 2015 15:28:38 +0100
Message-ID: <20150414142837.GB7874@acer.localdomain>
References: <20150414135023.GC13744@breakpoint.cc>
 <20150414140330.GA7874@acer.localdomain>
 <20150414141757.GD13744@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47392 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbbDNO2m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2015 10:28:42 -0400
Content-Disposition: inline
In-Reply-To: <20150414141757.GD13744@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.04, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > > So account for d2.len (8), but then later copy a size of set->dlen (16) in
> > > nft_set_elem_init:
> > > 
> > > 3272         if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
> > > 3273                 memcpy(nft_set_ext_data(ext), data, set->dlen);
> > > 
> > > Could someone please look at this?  I'm not sure what the intent is/was.
> > > 
> > > My hunch is that the check should be
> > > 
> > >  if (set->dtype != NFT_DATA_VERDICT || d2.len != set->dlen)
> > 
> > We actually only care about userspace provided length for data.
> > The verdict representation is internal, so we want to determine
> > the size ourselves.
> 
> I see, makes sense.
> 
> > > and libnftnl should also send a dlen of 16, like it already does for
> > > accept/drop.
> > 
> > I'm surprsided, because in nf_tables_newset, for verdict maps we do:
> > 
> >                         desc.dlen = sizeof(struct nft_verdict);
> > 
> > in nft_verdict_init() we do:
> > 
> >                 desc->len = sizeof(data->verdict);
> > 
> > So it should work out. I don't see how we could have arrived at the
> > value 8.
> 
> Thanks for the hint, we set dlen size to sizeof(void*) in this function,
> this makes the error go away:

Crap :)

> @@ -4355,7 +4355,7 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
>  
>                 chain->use++;
>                 data->verdict.chain = chain;
> -               desc->len = sizeof(data);
> +               desc->len = sizeof(*data);
>                 break;
>         }
> 
> Perhaps it would be better to set desc->len unconditionally, seems we want to set it to 16 unconditionally
> regardless of data->verdict.code?

Yeah, that seems unnecessary error prone. Lets set it to sizeof(data->verdict)
unconditionally I would say.
