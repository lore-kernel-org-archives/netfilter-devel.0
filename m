From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next:nf_tables-experiments PATCH 3/4] nf_tables: Add
 support for IPv6 NAT expression
Date: Thu, 15 Nov 2012 13:29:08 +0100
Message-ID: <20121115122908.GB2271@1984>
References: <1352970952-3447-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1352970952-3447-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44890 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767581Ab2KOM3Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:29:16 -0500
Content-Disposition: inline
In-Reply-To: <1352970952-3447-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi again Tomasz,

Comment below:

On Thu, Nov 15, 2012 at 11:15:51AM +0200, Tomasz Bursztyka wrote:
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  include/linux/netfilter/nf_tables.h |   6 ++-
>  net/netfilter/nft_nat.c             | 100 +++++++++++++++++++++++++++---------
>  2 files changed, 79 insertions(+), 27 deletions(-)
> 
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index f42cc9d..7ab2d65 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -395,8 +395,10 @@ enum nft_nat_types {
>  enum nft_nat_attributes {
>  	NFTA_NAT_UNSPEC,
>  	NFTA_NAT_TYPE,
> -	NFTA_NAT_REG_ADDR_MIN,
> -	NFTA_NAT_REG_ADDR_MAX,
> +	NFTA_NAT_REG_ADDR_MIN_V4,
> +	NFTA_NAT_REG_ADDR_MAX_V4,
> +	NFTA_NAT_REG_ADDR_MIN_V6,
> +	NFTA_NAT_REG_ADDR_MAX_V6,
>  	NFTA_NAT_REG_PROTO_MIN,
>  	NFTA_NAT_REG_PROTO_MAX,
>  	__NFTA_NAT_MAX
> diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
> index ea9854e..ca5b0da 100644
> --- a/net/netfilter/nft_nat.c
> +++ b/net/netfilter/nft_nat.c
> @@ -13,6 +13,7 @@
>  #include <linux/init.h>
>  #include <linux/skbuff.h>
>  #include <linux/ip.h>
> +#include <linux/string.h>
>  #include <linux/netlink.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter_ipv4.h>
> @@ -26,8 +27,10 @@
>  #include <net/ip.h>
>  
>  struct nft_nat {
> -	enum nft_registers      sreg_addr_min:8;
> -	enum nft_registers      sreg_addr_max:8;
> +	enum nft_registers      sreg_addr_min_v4:8;
> +	enum nft_registers      sreg_addr_max_v4:8;
> +	enum nft_registers      sreg_addr_min_v6:8;
> +	enum nft_registers      sreg_addr_max_v6:8;

Suggestion: Couldn't we get this patch a bit smaller by adding int
family and the NFTA_NAT_FAMILY attribute?

>  	enum nft_registers      sreg_proto_min:8;
>  	enum nft_registers      sreg_proto_max:8;
>  	enum nf_nat_manip_type  type;
> @@ -43,9 +46,15 @@ static void nft_nat_eval(const struct nft_expr *expr,
>  	struct nf_nat_range range;
>  
>  	memset(&range, 0, sizeof(range));
> -	if (priv->sreg_addr_min) {
> -		range.min_addr.ip = data[priv->sreg_addr_min].data[0];
> -		range.max_addr.ip = data[priv->sreg_addr_max].data[0];
> +	if (priv->sreg_addr_min_v4) {
> +		range.min_addr.ip = data[priv->sreg_addr_min_v4].data[0];
> +		range.max_addr.ip = data[priv->sreg_addr_max_v4].data[0];
> +		range.flags |= NF_NAT_RANGE_MAP_IPS;
> +	} else if (priv->sreg_addr_min_v6) {
> +		memcpy(range.min_addr.ip6, data[priv->sreg_addr_min_v4].data,
> +		       sizeof(struct nft_data));
> +		memcpy(range.max_addr.ip6, data[priv->sreg_addr_max_v6].data,
> +		       sizeof(struct nft_data));
>  		range.flags |= NF_NAT_RANGE_MAP_IPS;
>  	}
>  
> @@ -60,11 +69,13 @@ static void nft_nat_eval(const struct nft_expr *expr,
>  }
>  
>  static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
> -	[NFTA_NAT_TYPE]		 = { .type = NLA_U32 },
> -	[NFTA_NAT_REG_ADDR_MIN]	 = { .type = NLA_U32 },
> -	[NFTA_NAT_REG_ADDR_MAX]	 = { .type = NLA_U32 },
> -	[NFTA_NAT_REG_PROTO_MIN] = { .type = NLA_U32 },
> -	[NFTA_NAT_REG_PROTO_MAX] = { .type = NLA_U32 },
> +	[NFTA_NAT_TYPE]			= { .type = NLA_U32 },
> +	[NFTA_NAT_REG_ADDR_MIN_V4]	= { .type = NLA_U32 },
> +	[NFTA_NAT_REG_ADDR_MAX_V4]	= { .type = NLA_U32 },
> +	[NFTA_NAT_REG_ADDR_MIN_V6]	= { .type = NLA_U32 },
> +	[NFTA_NAT_REG_ADDR_MAX_V6]	= { .type = NLA_U32 },
> +	[NFTA_NAT_REG_PROTO_MIN]	= { .type = NLA_U32 },
> +	[NFTA_NAT_REG_PROTO_MAX]	= { .type = NLA_U32 },
>  };
>  
>  static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> @@ -87,22 +98,45 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  		return -EINVAL;
>  	}
>  
> -	if (tb[NFTA_NAT_REG_ADDR_MIN]) {
> -		priv->sreg_addr_min = ntohl(nla_get_be32(
> -						tb[NFTA_NAT_REG_ADDR_MIN]));
> -		err = nft_validate_input_register(priv->sreg_addr_min);
> +	if ((tb[NFTA_NAT_REG_ADDR_MIN_V4] && tb[NFTA_NAT_REG_ADDR_MIN_V6]) ||
> +	    (tb[NFTA_NAT_REG_ADDR_MIN_V4] && tb[NFTA_NAT_REG_ADDR_MAX_V6]) ||
> +	    (tb[NFTA_NAT_REG_ADDR_MAX_V4] && tb[NFTA_NAT_REG_ADDR_MIN_V6]) ||
> +	    (tb[NFTA_NAT_REG_ADDR_MAX_V4] && tb[NFTA_NAT_REG_ADDR_MAX_V6]))
> +		return -EINVAL;
> +
> +	if (tb[NFTA_NAT_REG_ADDR_MIN_V4]) {
> +		priv->sreg_addr_min_v4 = ntohl(nla_get_be32(
> +						tb[NFTA_NAT_REG_ADDR_MIN_V4]));
> +		err = nft_validate_input_register(priv->sreg_addr_min_v4);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	if (tb[NFTA_NAT_REG_ADDR_MAX_V4]) {
> +		priv->sreg_addr_max_v4 = ntohl(nla_get_be32(
> +						tb[NFTA_NAT_REG_ADDR_MAX_V4]));
> +		err = nft_validate_input_register(priv->sreg_addr_max_v4);
> +		if (err < 0)
> +			return err;
> +	} else
> +		priv->sreg_addr_max_v4 = priv->sreg_addr_min_v4;
> +
> +	if (tb[NFTA_NAT_REG_ADDR_MIN_V6]) {
> +		priv->sreg_addr_min_v6 = ntohl(nla_get_be32(
> +						tb[NFTA_NAT_REG_ADDR_MIN_V6]));
> +		err = nft_validate_input_register(priv->sreg_addr_min_v6);
>  		if (err < 0)
>  			return err;
>  	}
>  
> -	if (tb[NFTA_NAT_REG_ADDR_MAX]) {
> -		priv->sreg_addr_max = ntohl(nla_get_be32(
> -						tb[NFTA_NAT_REG_ADDR_MAX]));
> -		err = nft_validate_input_register(priv->sreg_addr_max);
> +	if (tb[NFTA_NAT_REG_ADDR_MAX_V6]) {
> +		priv->sreg_addr_max_v6 = ntohl(nla_get_be32(
> +						tb[NFTA_NAT_REG_ADDR_MAX_V6]));
> +		err = nft_validate_input_register(priv->sreg_addr_max_v4);
>  		if (err < 0)
>  			return err;
>  	} else
> -		priv->sreg_addr_max = priv->sreg_addr_min;
> +		priv->sreg_addr_max_v6 = priv->sreg_addr_min_v6;
>  
>  	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
>  		priv->sreg_proto_min = ntohl(nla_get_be32(
> @@ -139,12 +173,28 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  		break;
>  	}
>  
> -	if (nla_put_be32(skb,
> -			 NFTA_NAT_REG_ADDR_MIN, htonl(priv->sreg_addr_min)))
> -		goto nla_put_failure;
> -	if (nla_put_be32(skb,
> -			 NFTA_NAT_REG_ADDR_MAX, htonl(priv->sreg_addr_max)))
> -		goto nla_put_failure;
> +	if (priv->sreg_addr_min_v4) {
> +		if (nla_put_be32(skb,
> +				 NFTA_NAT_REG_ADDR_MIN_V4,
> +				 htonl(priv->sreg_addr_min_v4)))
> +			goto nla_put_failure;
> +		if (nla_put_be32(skb,
> +				 NFTA_NAT_REG_ADDR_MAX_V4,
> +				 htonl(priv->sreg_addr_max_v4)))
> +			goto nla_put_failure;
> +	}
> +
> +	if (priv->sreg_addr_min_v6) {
> +		if (nla_put_be32(skb,
> +				 NFTA_NAT_REG_ADDR_MIN_V6,
> +				 htonl(priv->sreg_addr_min_v6)))
> +			goto nla_put_failure;
> +		if (nla_put_be32(skb,
> +				 NFTA_NAT_REG_ADDR_MAX_V6,
> +				 htonl(priv->sreg_addr_max_v6)))
> +			goto nla_put_failure;
> +	}
> +
>  	if (nla_put_be32(skb,
>  			 NFTA_NAT_REG_PROTO_MIN, htonl(priv->sreg_proto_min)))
>  		goto nla_put_failure;
> -- 
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
