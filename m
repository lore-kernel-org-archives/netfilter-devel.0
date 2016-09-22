From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: Ensure u8 attributes are loaded
 from u32 within the bounds
Date: Thu, 22 Sep 2016 16:58:36 +0200
Message-ID: <20160922145836.GA15625@salvia>
References: <20160914125959.GA3020@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33356 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756829AbcIVO6s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 10:58:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 844D49D324
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:58:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 708FBDA842
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:58:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2BFF9DA847
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2016 16:58:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160914125959.GA3020@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 14, 2016 at 03:00:02PM +0200, Laura Garcia Liebana wrote:
> Check storage of u32 netlink attributes in smaller resources. This
> validation is usually required when the u32 netlink attributes are being
> stored in a private structure size of u8 in the kernel.

Applied with changes, no need to resend. If I break anything, just
follow up on top.

I have rewritten this description and the documentation on the code a bit.

More changes:

> 4da449a ("netfilter: nft_exthdr: Add size check on u8 nft_exthdr
> attributes")

Always use 12 bytes commit-ids. 4da449a is too short, given the number
of changes we're getting in the kernel tree, this may become ambiguous
at some point so it won't be unique.

You can achieve this via: git log --oneline --abbrev=12

More comments below.

> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  include/net/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c     | 26 ++++++++++++++++++++++++++
>  net/netfilter/nft_bitwise.c       | 10 +++++++++-
>  net/netfilter/nft_byteorder.c     | 17 +++++++++++++++--
>  net/netfilter/nft_cmp.c           |  6 +++++-
>  net/netfilter/nft_exthdr.c        | 19 ++++++++++++-------
>  net/netfilter/nft_immediate.c     |  4 ++++
>  7 files changed, 73 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index f2f1339..608130f 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -127,6 +127,8 @@ static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
>  	return type == NFT_DATA_VERDICT ? NFT_REG_VERDICT : NFT_REG_1 * NFT_REG_SIZE / NFT_REG32_SIZE;
>  }
>  
> +unsigned int nft_parse_u32_check(const struct nlattr *attr, int maxlen,
> +				 u32 *dest);

I have renamed maxlen to max, so this fits in one line.

>  unsigned int nft_parse_register(const struct nlattr *attr);
>  int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
>  
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 7e1c876..d7b000f 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4343,6 +4343,32 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
>  }
>  
>  /**
> + *	nft_parse_u32_check - parse a u32 value to store the value into a
> + *			      smaller resource.
> + *
> + *	@attr: netlink attribute
> + *	@maxlen: maximum value to be stored in dest
> + *	@dest: pointer to the resource
> + *
> + *	Parse and store a given u32 value into a resource. Returns an error
> + *	ERANGE if the value will overload the maxlen, otherwise a 0 will be
> + *	returned and the value is stored into dest.

I've rewritten this a bit.

> + */
> +unsigned int nft_parse_u32_check(const struct nlattr *attr, int maxlen,

I have rename maxlen to max. Probably maxval would have been better,
anyway.

> +				 u32 *dest)
> +{
> +	int reg;

Variable names are important, they provide context when reading the
code. Look, from the 'reg' name it seems we're fetching a register.
However, we are obtaining a value, so I renamed this to val. Try to
select the right name next time.

> +
> +	reg = ntohl(nla_get_be32(attr));
> +	if (reg > maxlen)
> +		return -ERANGE;
> +
> +	*dest = reg;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nft_parse_u32_check);
> +
> +/**
>   *	nft_parse_register - parse a register value from a netlink attribute
>   *
>   *	@attr: netlink attribute
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index d71cc18..e7f23a1 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -14,6 +14,7 @@
>  #include <linux/netlink.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
> +#include <linux/static_key.h>
>  #include <net/netfilter/nf_tables_core.h>
>  #include <net/netfilter/nf_tables.h>
>  
> @@ -52,6 +53,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
>  {
>  	struct nft_bitwise *priv = nft_expr_priv(expr);
>  	struct nft_data_desc d1, d2;
> +	u32 len;
>  	int err;
>  
>  	if (tb[NFTA_BITWISE_SREG] == NULL ||
> @@ -61,7 +63,13 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
>  	    tb[NFTA_BITWISE_XOR] == NULL)
>  		return -EINVAL;
>  
> -	priv->len  = ntohl(nla_get_be32(tb[NFTA_BITWISE_LEN]));
> +	err  = nft_parse_u32_check(tb[NFTA_BITWISE_LEN], U8_MAX,
> +				   &len);
                                   ^^^^

This line break was unnecessary. We can have lines 80-chars long, and
for some reason you broken the line before the limit. I have repaired
this.

> +	if (err < 0)
> +		return err;
> +
> +	priv->len = len;
> +
>  	priv->sreg = nft_parse_register(tb[NFTA_BITWISE_SREG]);
>  	err = nft_validate_register_load(priv->sreg, priv->len);
>  	if (err < 0)
> diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
> index b78c28b..8cac219 100644
> --- a/net/netfilter/nft_byteorder.c
> +++ b/net/netfilter/nft_byteorder.c
> @@ -99,6 +99,7 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
>  			      const struct nlattr * const tb[])
>  {
>  	struct nft_byteorder *priv = nft_expr_priv(expr);
> +	u32 size, len;
>  	int err;
>  
>  	if (tb[NFTA_BYTEORDER_SREG] == NULL ||
> @@ -117,7 +118,13 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
>  		return -EINVAL;
>  	}
>  
> -	priv->size = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_SIZE]));
> +	err = nft_parse_u32_check(tb[NFTA_BYTEORDER_SIZE], U8_MAX,
> +				  &size);

Same here, and everywhere else.

> +	if (err < 0)
> +		return err;
> +
> +	priv->size = size;
> +
>  	switch (priv->size) {
>  	case 2:
>  	case 4:
> @@ -128,7 +135,13 @@ static int nft_byteorder_init(const struct nft_ctx *ctx,
>  	}
>  
>  	priv->sreg = nft_parse_register(tb[NFTA_BYTEORDER_SREG]);
> -	priv->len  = ntohl(nla_get_be32(tb[NFTA_BYTEORDER_LEN]));
> +	err = nft_parse_u32_check(tb[NFTA_BYTEORDER_LEN], U8_MAX,
> +				  &len);
> +	if (err < 0)
> +		return err;
> +
> +	priv->len = len;
> +
>  	err = nft_validate_register_load(priv->sreg, priv->len);
>  	if (err < 0)
>  		return err;
> diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
> index e25b35d..3d31432 100644
> --- a/net/netfilter/nft_cmp.c
> +++ b/net/netfilter/nft_cmp.c
> @@ -84,8 +84,12 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  	if (err < 0)
>  		return err;
>  
> -	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
> +	if (desc.len > U8_MAX)
> +		return -ERANGE;
>  	priv->len = desc.len;
> +
> +	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));

Look, this line has moved for no reason. This just adds noise to the
patch, so modify only the code that you strictly need, to get it
smaller.
