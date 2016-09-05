From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH] netfilter: nft_hash: Add hash offset value
Date: Mon, 5 Sep 2016 11:58:24 +0200
Message-ID: <20160905095823.GA23680@sonyv>
References: <20160905083655.GA15395@sonyv>
 <20160905091028.GA2469@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35654 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932444AbcIEJ6b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 05:58:31 -0400
Received: by mail-wm0-f67.google.com with SMTP id a6so1213821wmc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Sep 2016 02:58:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160905091028.GA2469@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 05, 2016 at 11:10:28AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 05, 2016 at 10:36:57AM +0200, Laura Garcia Liebana wrote:
> > Add support to pass through an offset to the hash value. With this
> > feature, the sysadmin is able to generate a hash with a given
> > offset value.
> > 
> > Example:
> > 
> > 	meta mark set jhash ip saddr mod 2 seed 0xabcd sum 100
> > 
> > This option generates marks according to the source address from 100 to
> > 101.
> > 
> > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h |  2 ++
> >  net/netfilter/nft_hash.c                 | 13 +++++++++++--
> >  2 files changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index 4dbeeed..8026684 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -764,6 +764,7 @@ enum nft_meta_keys {
> >   * @NFTA_HASH_LEN: source data length (NLA_U32)
> >   * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
> >   * @NFTA_HASH_SEED: seed value (NLA_U32)
> > + * @NFTA_HASH_SUM: Hash offset value (NLA_U32)
> >   */
> >  enum nft_hash_attributes {
> >  	NFTA_HASH_UNSPEC,
> > @@ -772,6 +773,7 @@ enum nft_hash_attributes {
> >  	NFTA_HASH_LEN,
> >  	NFTA_HASH_MODULUS,
> >  	NFTA_HASH_SEED,
> > +	NFTA_HASH_SUM,
> >  	__NFTA_HASH_MAX,
> >  };
> >  #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
> > diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> > index b7e3b40..8ab04d9 100644
> > --- a/net/netfilter/nft_hash.c
> > +++ b/net/netfilter/nft_hash.c
> > @@ -23,6 +23,7 @@ struct nft_hash {
> >  	u8			len;
> >  	u32			modulus;
> >  	u32			seed;
> > +	u32			sum;
> >  };
> >  
> >  static void nft_hash_eval(const struct nft_expr *expr,
> > @@ -35,7 +36,7 @@ static void nft_hash_eval(const struct nft_expr *expr,
> >  
> >  	h = reciprocal_scale(jhash(data, priv->len, priv->seed), priv->modulus);
> >  
> > -	regs->data[priv->dreg] = h;
> > +	regs->data[priv->dreg] = priv->sum + h;
> >  }
> >  
> >  const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
> > @@ -44,6 +45,7 @@ const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
> >  	[NFTA_HASH_LEN]			= { .type = NLA_U32 },
> >  	[NFTA_HASH_MODULUS]		= { .type = NLA_U32 },
> >  	[NFTA_HASH_SEED]		= { .type = NLA_U32 },
> > +	[NFTA_HASH_SUM]			= { .type = NLA_U32 },
> >  };
> >  
> >  static int nft_hash_init(const struct nft_ctx *ctx,
> > @@ -60,6 +62,11 @@ static int nft_hash_init(const struct nft_ctx *ctx,
> >  	    !tb[NFTA_HASH_MODULUS])
> >  		return -EINVAL;
> >  
> > +	if (tb[NFTA_HASH_SUM])
> > +		priv->sum = ntohl(nla_get_be32(tb[NFTA_HASH_SUM]));
> > +	else
> > +		priv->sum = 0;
> 
> There is a corner case that we should reject from the kernel, I think
> this is:
> 
>         if (priv->sum + priv->modulus - 1 < priv->sum)
>                 return -EOVERFLOW;
> 
> We'll handle this from userspace anyway too, but I think it's easy to
> reject this crazy this.

Such case shouldn't happen cause the modulus must be > 1. The init()
provides:

        priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
        if (priv->modulus <= 1)
                return -ERANGE;


