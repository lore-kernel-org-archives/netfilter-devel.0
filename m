From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: oob crash w. verdict maps & jumps
Date: Tue, 14 Apr 2015 15:03:31 +0100
Message-ID: <20150414140330.GA7874@acer.localdomain>
References: <20150414135023.GC13744@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47200 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbbDNODg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Apr 2015 10:03:36 -0400
Content-Disposition: inline
In-Reply-To: <20150414135023.GC13744@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.04, Florian Westphal wrote:
> Hi.
> 
> Looks like we can memcpy more than we allocated in nft_set_elem_init().
> 
> reproducer:
> 
> nft -f /etc/nftables/ipv4-filter
> nft add map filter ipmap '{ type ipv4_addr : verdict; }'
> nft add chain filter foo
> nft add element filter ipmap { 1.2.3.4 : jump foo }
> 
> -> we scribble over elem private size
> 
> You can see this when turning on SLUB debugging and deleting the jump
> element again, we get 'Redzone overwritten'.
> 
> In nft_add_set_elem() we try to account for the length:
> 
> 3372 
> 3373         if (nla[NFTA_SET_ELEM_DATA] != NULL) {
> 3374                 err = nft_data_init(ctx, &data, sizeof(data), &d2,
> 3375                                     nla[NFTA_SET_ELEM_DATA]);
> 3376                 if (err < 0)
> 3377                         goto err2;
> [..]
>  
> 
> 3380                 if (set->dtype != NFT_DATA_VERDICT && d2.len != set->dlen)
> 3381                         goto err3;
> 3401                 nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, d2.len);
> 3402         }
> 
> but in above 'nft add element filter ipmap { 1.2.3.4 : jump foo }'
> 
> We have dtype NFT_DATA_VERDICT, d2.len of 8, and set->dlen of 16.

Is that on x86 (32 bit)?

> So account for d2.len (8), but then later copy a size of set->dlen (16) in
> nft_set_elem_init:
> 
> 3272         if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
> 3273                 memcpy(nft_set_ext_data(ext), data, set->dlen);
> 
> Could someone please look at this?  I'm not sure what the intent is/was.
> 
> My hunch is that the check should be
> 
>  if (set->dtype != NFT_DATA_VERDICT || d2.len != set->dlen)

We actually only care about userspace provided length for data.
The verdict representation is internal, so we want to determine
the size ourselves.

> and libnftnl should also send a dlen of 16, like it already does for
> accept/drop.

I'm surprsided, because in nf_tables_newset, for verdict maps we do:

                        desc.dlen = sizeof(struct nft_verdict);

in nft_verdict_init() we do:

                desc->len = sizeof(data->verdict);

So it should work out. I don't see how we could have arrived at the
value 8.
