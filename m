From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_numgen: add increment counter offset
 value
Date: Mon, 12 Sep 2016 19:08:24 +0200
Message-ID: <20160912170823.GB18041@sonyv>
References: <20160907175646.GA7317@sonyv>
 <20160912164558.GA13182@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32816 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932807AbcILRI2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:08:28 -0400
Received: by mail-wm0-f67.google.com with SMTP id b187so14528125wme.0
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 10:08:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160912164558.GA13182@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2016 at 06:45:58PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 07, 2016 at 07:56:49PM +0200, Laura Garcia Liebana wrote:
> > Add support for an initialization counter value. With this option the
> > sysadmin is able to start the counter when used with the increment type.
> > 
> > Example:
> > 
> > 	meta mark set numgen inc mod 2 sum 100
> > 
> > This will generate marks with the serie 100, 101, 100, 101, ...
> > 
> > Only supported for increment number generation.
> > 
> > Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> > ---
> > Changes in v2:
> > 	- Separate _SUM_ changes with _until_ attribute renaming.
> > 
> >  include/uapi/linux/netfilter/nf_tables.h | 2 ++
> >  net/netfilter/nft_numgen.c               | 9 +++++++--
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index 24161e2..00a689d 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -1128,12 +1128,14 @@ enum nft_trace_types {
> >   * @NFTA_NG_DREG: destination register (NLA_U32)
> >   * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
> >   * @NFTA_NG_TYPE: operation type (NLA_U32)
> > + * @NFTA_NG_SUM: Offset to initiate the counter (NLA_U32)
> >   */
> >  enum nft_ng_attributes {
> >  	NFTA_NG_UNSPEC,
> >  	NFTA_NG_DREG,
> >  	NFTA_NG_MODULUS,
> >  	NFTA_NG_TYPE,
> > +	NFTA_NG_SUM,
> >  	__NFTA_NG_MAX
> >  };
> >  #define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
> > diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
> > index f51a3ed..a5ea3f7 100644
> > --- a/net/netfilter/nft_numgen.c
> > +++ b/net/netfilter/nft_numgen.c
> > @@ -44,6 +44,7 @@ static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
> >  	[NFTA_NG_DREG]		= { .type = NLA_U32 },
> >  	[NFTA_NG_MODULUS]	= { .type = NLA_U32 },
> >  	[NFTA_NG_TYPE]		= { .type = NLA_U32 },
> > +	[NFTA_NG_SUM]		= { .type = NLA_U32 },
> >  };
> >  
> >  static int nft_ng_inc_init(const struct nft_ctx *ctx,
> > @@ -51,13 +52,17 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
> >  			   const struct nlattr * const tb[])
> >  {
> >  	struct nft_ng_inc *priv = nft_expr_priv(expr);
> > +	u32 sum = 0;
> > +
> > +	if (tb[NFTA_NG_SUM])
> > +		sum = ntohl(nla_get_be32(tb[NFTA_NG_SUM]));
> >  
> >  	priv->modulus = ntohl(nla_get_be32(tb[NFTA_NG_MODULUS]));
> > -	if (priv->modulus == 0)
> > +	if (priv->modulus == 0 || sum >= priv->modulus)
> >  		return -ERANGE;
> >  
> >  	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
> > -	atomic_set(&priv->counter, 0);
> > +	atomic_set(&priv->counter, sum);
> 
> Are you sure this will work?
> 
>         nval = (oval + 1 < priv->modulus) ? oval + 1 : 0;
> 
> This is just setting priv->counter to an initial value, then it will
> become zero at some point.
> 

I considered that the offset in the case of 'numgen inc' will be only
applied to initialize the counter to a certain value. Do you mean to
add the offset in every generated value?

Should the random counter behave in the same way?

> I'm going to take Liping's patch that converts:
> 
>         memcpy(&regs->data[priv->dreg], &priv->counter, sizeof(u32));
> 
> to:
> 
>         reg->data[priv->dreg] = nval;
> 
> so you can change this to:
> 
>         reg->data[priv->dreg] = nval + priv->offset;
