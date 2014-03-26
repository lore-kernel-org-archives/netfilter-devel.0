From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 1/2] netfilter: nf_tables: move set netlink messages
 into the batch
Date: Wed, 26 Mar 2014 14:03:38 +0100
Message-ID: <20140326130338.GA31813@localhost>
References: <1395779982-3459-1-git-send-email-pablo@netfilter.org>
 <20140326112554.GC452@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60174 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbaCZNDu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:03:50 -0400
Content-Disposition: inline
In-Reply-To: <20140326112554.GC452@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 26, 2014 at 11:25:54AM +0000, Patrick McHardy wrote:
> On Tue, Mar 25, 2014 at 09:39:41PM +0100, Pablo Neira Ayuso wrote:
> > diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> > index e6bc14d..b749e4d 100644
> > --- a/include/net/netfilter/nf_tables.h
> > +++ b/include/net/netfilter/nf_tables.h
> > @@ -222,6 +222,8 @@ static inline void *nft_set_priv(const struct nft_set *set)
> >  
> >  struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
> >  				     const struct nlattr *nla);
> > +struct nft_set *nf_tables_set_lookup2(const struct net *net,
> > +				      const struct nlattr *nla);
> 
> nf_tables_set_lookup_byid?

That looks better.

> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index c88ccbf..3776beb 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -221,6 +221,7 @@ enum nft_set_flags {
> >   * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
> >   * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
> >   * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
> > + * @NFTA_SET_ID: set ID (NLA_U64)
> 
> I think a U32 should be perfectly fine. These are not permanent IDs but just to
> identify new sets contained within a batch, so we can always start at 0.

Yes, I was considering using this also to output the set identifier
for anonymous sets, but the dynamically allocated name should be fine
so I'll stick to u32.

Going back to the idea of using u64 to allocate the set/map names, I
think we have to extend the set name, currently IFNAMSIZ is limited
when mapping the name to set%lld, assuming a large u64 number.

> > +static int nf_tables_set_trans_add(struct list_head *list, struct nft_ctx *ctx,
> > +				   struct nft_set *set)
> > +{
> > +	struct nft_set_trans *strans;
> > +
> > +	strans = kmalloc(sizeof(struct nft_set_trans), GFP_ATOMIC);
> 
> Do we need GFP_ATOMIC?

not really, will swap that to GFP_KERNEL.

> > +	if (strans == NULL)
> > +		return -ENOMEM;
> > +
> > +	strans->set = set;
> > +	strans->ctx = *ctx;
> > +	if (ctx->nla[NFTA_SET_ID])
> > +		strans->id = be64_to_cpu(nla_get_be64(ctx->nla[NFTA_SET_ID]));
> > +
> > +	set->flags |= __NFT_SET_INACTIVE;
> > +	list_add_tail(&strans->list, list);
> > +	return 0;
> > +}
> > +
> >  static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
> >  			    const struct nlmsghdr *nlh,
> >  			    const struct nlattr * const nla[])
> >  static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
> > @@ -2534,7 +2619,8 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
> >  {
> >  	list_del(&binding->list);
> >  
> > -	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
> > +	if (list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS &&
> > +	    !(set->flags & __NFT_SET_INACTIVE))
> 
> Why are we not destroying anonymous inactive sets when unbinding? This means we're
> either aborting or replaying the entire transaction, so it seems we should remove
> them, no?

The set may be already bound to the rule, we skip this here, so the
set is released from the transaction. This is just to avoid a double
free case.

> >  		nf_tables_set_destroy(ctx, set);
> >  }
> >  
