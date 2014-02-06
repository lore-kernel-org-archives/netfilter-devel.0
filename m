From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nft_rbtree: fix chain use underflow with
 intervals and map
Date: Thu, 6 Feb 2014 17:17:38 +0000
Message-ID: <20140206171738.GA24768@macbook.localnet>
References: <1391702434-4103-1-git-send-email-pablo@netfilter.org>
 <20140206160857.GA24151@macbook.localnet>
 <20140206162827.GA4400@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35876 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbaBFRRn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:17:43 -0500
Content-Disposition: inline
In-Reply-To: <20140206162827.GA4400@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 06, 2014 at 05:28:27PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 06, 2014 at 04:08:57PM +0000, Patrick McHardy wrote:
> > On Thu, Feb 06, 2014 at 05:00:34PM +0100, Pablo Neira Ayuso wrote:
> > > If you add a rule using intervals+map that introduces a loop, the
> > > error path of the rbtree set decrements the chain refcount for each
> > > side of the interval, leading to a chain use counter underflow.
> > > 
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > >  net/netfilter/nft_rbtree.c |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
> > > index ca0c1b2..b18e88b 100644
> > > --- a/net/netfilter/nft_rbtree.c
> > > +++ b/net/netfilter/nft_rbtree.c
> > > @@ -69,8 +69,10 @@ static void nft_rbtree_elem_destroy(const struct nft_set *set,
> > >  				    struct nft_rbtree_elem *rbe)
> > >  {
> > >  	nft_data_uninit(&rbe->key, NFT_DATA_VALUE);
> > > -	if (set->flags & NFT_SET_MAP)
> > > +	if (set->flags & NFT_SET_MAP &&
> > > +	    !(rbe->flags & NFT_SET_ELEM_INTERVAL_END))
> > >  		nft_data_uninit(rbe->data, set->dtype);
> > > +
> > 
> > That can't be correct. The NFT_SET_ELEM_INTERVAL_END can at the same
> > time begin a new interval, so this code is supposed to be like this.
> > There can also only be a chain reference here if we took one before
> > during initialization.
> 
> >From nf_tables_fill_setelem(...):
> 
>         if (set->flags & NFT_SET_MAP &&
>             !(elem->flags & NFT_SET_ELEM_INTERVAL_END) &&
>             nft_data_dump(skb, NFTA_SET_ELEM_DATA, &elem->data,
>                           set->dtype == NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE,
>                           set->dlen) < 0)
>                 goto nla_put_failure;
> 
> The data part of the element is only dumped if the interval flag is
> not set. I don't see yet why we should call nft_data_uninit(...) if no
> interval_end flag is set then.

Yes, that was wrong. If a new interval begins directly adjacent to another
interval, no SET_ELEM_INTERVAL_END is added. The interval end is allowed to
contain data, but it doesn't serve any purpose and is optional, so we don't
dump it.

> > Please provide a test case so I can try myself.
> 
> nft add table ip filter
> nft add chain ip filter input { type filter hook input priority 0\; }
> nft add chain ip filter chain1
> nft add chain ip filter chain2
> nft add chain ip filter chain3
> 
> nft add rule ip filter input ip saddr vmap { 10.0.0.0/24 : jump chain1, 11.0.0.0/8 : jump chain2, 8.8.8.8 : jump chain3}
> 
> nft add rule ip filter chain1 ip saddr vmap { 10.0.0.0/24 : jump chain1, 11.0.0.0/8 : jump chain2, 8.8.8.8 : jump chain3}

Yes, I can see the problem. I guess I know what's happening:

nft_add_set_elem() is called multiple times and the data of the new element
is still contained in the (uninitialized) stack space and is copied to the
rbtree element. During destruction we do indeed get an underflow.

We have two ways to fix this:

- your patch, but that additionally requires a change to nft_add_set_elem()
  to prohibit the currently optional data on NFT_SET_ELEM_INTERVAL_END
  members. Also nft_hash would need the same change.

- initialize elem.data to NFT_DATA_VALUE

The first variant is "more correct", IIRC this optional data for interval
ends was mainly done to make things easier for userspace.
