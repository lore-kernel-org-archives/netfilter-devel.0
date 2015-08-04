From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add generation mask to
 table objects
Date: Tue, 4 Aug 2015 11:29:05 +0200
Message-ID: <20150804092905.GA7944@salvia>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <20150804090917.GA6033@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49124 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbbHDJXN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 05:23:13 -0400
Content-Disposition: inline
In-Reply-To: <20150804090917.GA6033@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 11:09:17AM +0200, Patrick McHardy wrote:
> On 04.08, Pablo Neira Ayuso wrote:
> > The dumping of table objects can be inconsistent when interfering with the
> > preparation phase of our 2-phase commit protocol because:
> > 
> > 1) We remove objects from the lists during the preparation phase, that can be
> >    added re-added from the abort step. Thus, we may miss objects that are still
> >    active.
> > 
> > 2) We add new objects to the lists during the preparation phase, so we may get
> >    objects that are not yet active with an internal flag set.
> > 
> > We can resolve this problem with generation masks, as we already do for rules
> > when we expose them to the packet path.
> > 
> > After this change, we always obtain a consistent list as long as we stay in the
> > same generation. The userspace side can detect interferences through the
> > generation counter. If so, it needs to restart.
> > 
> > As a result, we can get rid of the internal NFT_TABLE_INACTIVE flag.
> 
> I have a similar patch queued up, however there seems to be something missing
> in this patch. The lookup functions need to take the genmask into account.

They already do for the deletion case, so we hit -ENOENT for objects
that has been deleted in this batch, so we cannot delete objects
twice.

> Otherwise you can not delete and add a new table in the same batch. The same
> holds for all other object types.

I can with this patch, we always operate with the *next* bit to
indicate that the object will be inactive in the future.

> > +static struct nft_table *nf_tables_table_lookup(struct net *net,
> > +						const struct nft_af_info *afi,
> > +						const struct nlattr *nla,
> > +						bool trans)
> >  {
> >  	struct nft_table *table;
> >  
> > @@ -382,10 +411,10 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
> >  		return ERR_PTR(-EINVAL);
> >  
> >  	table = nft_table_lookup(afi, nla);
> > -	if (table != NULL)
> > -		return table;
> > +	if (table == NULL || (trans && !nft_table_is_active_next(net, table)))
> > +		return ERR_PTR(-ENOENT);
> 
> We really need to check the genid itself, in some cases we *only* want
> currently active tables, f.i. gettable and dumps.

This is what this patch is doing from the dump path.

We shouldn't check if the object is active from the lookup function if
we're in the middle of a transaction, since we hold the lock there is
no way we can see inactive objects in the list. There's only one
transaction at the same time.
