From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftables v2] Add support for ct set
Date: Fri, 10 Jan 2014 01:50:15 +0100
Message-ID: <20140110005015.GA18032@localhost>
References: <1389170211-7024-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbaAJAuU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:50:20 -0500
Content-Disposition: inline
In-Reply-To: <1389170211-7024-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 08, 2014 at 09:36:51AM +0100, Kristian Evensen wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> This patch adds userspace support for setting properties of tracked connections.
> Currently, the connection mark is supported. This can be used to implemented the
> same functionality as iptables -j CONNMARK --save-mark.

This applies cleanly to libnftables, but I need to request you some
changes.

> v1->v2:
> - Fixed a style error.
> - Improved error handling. Fail if neither sreg nor dreg is set (was already
>   present when parsing XML).
> 
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---
>  include/libnftables/expr.h          |   1 +
>  include/linux/netfilter/nf_tables.h |   2 +
>  src/expr/ct.c                       | 122 ++++++++++++++++++++++++++++--------
>  3 files changed, 100 insertions(+), 25 deletions(-)
> 
> diff --git a/include/libnftables/expr.h b/include/libnftables/expr.h
> index 25455e4..653bbb0 100644
> --- a/include/libnftables/expr.h
> +++ b/include/libnftables/expr.h
> @@ -124,6 +124,7 @@ enum {
>  	NFT_EXPR_CT_DREG	= NFT_RULE_EXPR_ATTR_BASE,
>  	NFT_EXPR_CT_KEY,
>  	NFT_EXPR_CT_DIR,
> +	NFT_EXPR_CT_SREG,
>  };
>  
>  enum {
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index e08f80e..1b6362c 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -526,12 +526,14 @@ enum nft_ct_keys {
>   * @NFTA_CT_DREG: destination register (NLA_U32)
>   * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
>   * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
> + * @NFTA_CT_SREG: source register (NLA_U32)
>   */
>  enum nft_ct_attributes {
>  	NFTA_CT_UNSPEC,
>  	NFTA_CT_DREG,
>  	NFTA_CT_KEY,
>  	NFTA_CT_DIRECTION,
> +	NFTA_CT_SREG,
>  	__NFTA_CT_MAX
>  };
>  #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
> diff --git a/src/expr/ct.c b/src/expr/ct.c
> index 46e3cef..00de64b 100644
> --- a/src/expr/ct.c
> +++ b/src/expr/ct.c
> @@ -24,7 +24,10 @@
>  
>  struct nft_expr_ct {
>  	enum nft_ct_keys        key;
> -	uint32_t		dreg;	/* enum nft_registers */
> +	union {
> +		uint32_t		dreg;	/* enum nft_registers */
> +		uint32_t		sreg;	/* enum nft_registers */
> +	};

I know you have based this patch on the meta/set support, which does
exactly this thing, but I think we have to have two different fields
sreg and dreg (so remove the union), the reason is explain below.

>  	uint8_t			dir;
>  };
>  
> @@ -51,6 +54,9 @@ nft_rule_expr_ct_set(struct nft_rule_expr *e, uint16_t type,
>  	case NFT_EXPR_CT_DREG:
>  		ct->dreg = *((uint32_t *)data);
>  		break;
> +	case NFT_EXPR_CT_SREG:
> +		ct->sreg = *((uint32_t *)data);
> +		break;
>  	default:
>  		return -1;
>  	}
> @@ -73,6 +79,9 @@ nft_rule_expr_ct_get(const struct nft_rule_expr *e, uint16_t type,
>  	case NFT_EXPR_CT_DREG:
>  		*data_len = sizeof(ct->dreg);
>  		return &ct->dreg;
> +	case NFT_EXPR_CT_SREG:
> +		*data_len = sizeof(ct->sreg);
> +		return &ct->sreg;
>  	}
>  	return NULL;
>  }
> @@ -88,6 +97,7 @@ static int nft_rule_expr_ct_cb(const struct nlattr *attr, void *data)
>  	switch(type) {
>  	case NFTA_CT_KEY:
>  	case NFTA_CT_DREG:
> +	case NFTA_CT_SREG:
>  		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
>  			perror("mnl_attr_validate");
>  			return MNL_CB_ERROR;
> @@ -116,6 +126,8 @@ nft_rule_expr_ct_build(struct nlmsghdr *nlh, struct nft_rule_expr *e)
>  		mnl_attr_put_u32(nlh, NFTA_CT_DREG, htonl(ct->dreg));
>  	if (e->flags & (1 << NFT_EXPR_CT_DIR))
>  		mnl_attr_put_u8(nlh, NFTA_CT_DIRECTION, ct->dir);
> +	if (e->flags & (1 << NFT_EXPR_CT_SREG))
> +		mnl_attr_put_u32(nlh, NFTA_CT_SREG, htonl(ct->sreg));
>  }
>  
>  static int
> @@ -131,14 +143,19 @@ nft_rule_expr_ct_parse(struct nft_rule_expr *e, struct nlattr *attr)
>  		ct->key = ntohl(mnl_attr_get_u32(tb[NFTA_CT_KEY]));
>  		e->flags |= (1 << NFT_EXPR_CT_KEY);
>  	}
> -	if (tb[NFTA_CT_DREG]) {
> -		ct->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_CT_DREG]));
> -		e->flags |= (1 << NFT_EXPR_CT_DREG);
> -	}
>  	if (tb[NFTA_CT_DIRECTION]) {
>  		ct->dir = mnl_attr_get_u8(tb[NFTA_CT_DIRECTION]);
>  		e->flags |= (1 << NFT_EXPR_CT_DIR);
>  	}
> +	if (tb[NFTA_CT_DREG]) {
> +		ct->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_CT_DREG]));
> +		e->flags |= (1 << NFT_EXPR_CT_DREG);
> +	} else if (tb[NFTA_CT_SREG]) {
> +		ct->sreg = ntohl(mnl_attr_get_u32(tb[NFTA_CT_SREG]));
> +		e->flags |= (1 << NFT_EXPR_CT_SREG);

I would like to avoid this sort of obscure behaviour. I know that,
from the kernel representation point of view, it doesn't make any
sense to have set both sreg and dreg, but we should not make such
assumption from userspace. If the user sets both sreg and dreg, it's
wrong and the kernel should reply -EINVAL so the user knows that it
has to fix its userspace code. This requires a bit more memory in
userspace, but we don't have the memory restrictions that we have in
kernelspace, so a bit more consumption won't harm.

Please, rework this. It would be good to rework the meta/set part
available in libnftables next-3.14. If you cannot make it, let me know
and I'll schedule time to fix that. Thanks.
