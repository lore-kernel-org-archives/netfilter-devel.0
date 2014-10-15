From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 3/3] netfilter: nf_tables: add new expression
 nft_redir
Date: Wed, 15 Oct 2014 12:06:19 +0200
Message-ID: <20141015100619.GC4885@salvia>
References: <20141014172231.5983.37941.stgit@nfdev.cica.es>
 <20141014172242.5983.11604.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43171 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbaJOKE4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:04:56 -0400
Content-Disposition: inline
In-Reply-To: <20141014172242.5983.11604.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 14, 2014 at 07:22:42PM +0200, Arturo Borrero Gonzalez wrote:
> This new expression provides NAT in the redirect flavour, which is to
> redirect packets to local machine.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/net/netfilter/nft_redir.h        |   18 ++++++
>  include/uapi/linux/netfilter/nf_tables.h |   16 +++++
>  net/ipv4/netfilter/Kconfig               |    9 +++
>  net/ipv4/netfilter/Makefile              |    1 
>  net/ipv4/netfilter/nft_redir_ipv4.c      |   76 +++++++++++++++++++++++++
>  net/ipv6/netfilter/Kconfig               |    9 +++
>  net/ipv6/netfilter/Makefile              |    1 
>  net/netfilter/Kconfig                    |    9 +++
>  net/netfilter/Makefile                   |    1 
>  net/netfilter/nft_redir.c                |   93 ++++++++++++++++++++++++++++++
>  10 files changed, 233 insertions(+)
>  create mode 100644 include/net/netfilter/nft_redir.h
>  create mode 100644 net/ipv4/netfilter/nft_redir_ipv4.c
>  create mode 100644 net/netfilter/nft_redir.c
> 
> diff --git a/include/net/netfilter/nft_redir.h b/include/net/netfilter/nft_redir.h
> new file mode 100644
> index 0000000..b6695da
> --- /dev/null
> +++ b/include/net/netfilter/nft_redir.h
> @@ -0,0 +1,18 @@
> +#ifndef _NFT_REDIR_H_
> +#define _NFT_REDIR_H_
> +
> +struct nft_redir {
> +	enum nft_registers	sreg_proto_min:8;
> +	enum nft_registers	sreg_proto_max:8;
> +	u32			flags;

I think you can use u16 to store the flags. So this consumes only 4
bytes in 32-bits arch.

> +};
> +
> +extern const struct nla_policy nft_redir_policy[];
> +
> +int nft_redir_init(const struct nft_ctx *ctx,
> +		   const struct nft_expr *expr,
> +		   const struct nlattr * const tb[]);
> +
> +int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr);
> +
> +#endif /* _NFT_REDIR_H_ */
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index c26df67..8a96a36 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -849,4 +849,20 @@ enum nft_gen_attributes {
>  };
>  #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
>  
> +/**
> + * enum nft_redir_attributes - nf_tables redirect expression netlink attributes
> + *
> + * @NFTA_REDIR_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
> + * @NFTA_REDIR_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
> + * @NFTA_REDIR_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
> + */
> +enum nft_redir_attributes {
> +	NFTA_REDIR_UNSPEC,
> +	NFTA_REDIR_REG_PROTO_MIN,
> +	NFTA_REDIR_REG_PROTO_MAX,
> +	NFTA_REDIR_FLAGS,
> +	__NFTA_REDIR_MAX
> +};
> +#define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
> +

Please, place this new chunk after the masq atributes.

>  #endif /* _LINUX_NF_TABLES_H */
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index a300e2c..8358b2d 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -119,6 +119,15 @@ config NFT_MASQ_IPV4
>  	  This is the expression that provides IPv4 masquerading support for
>  	  nf_tables.
>  
> +config NFT_REDIR_IPV4
> +	tristate "IPv4 redirect support for nf_tables"
> +	depends on NF_TABLES_IPV4
> +	depends on NFT_REDIR
> +	select NF_NAT_REDIRECT_IPV4
> +	help
> +	  This is the expression that provides IPv4 redirect support for
> +	  nf_tables.
> +
>  config NF_NAT_SNMP_BASIC
>  	tristate "Basic SNMP-ALG support"
>  	depends on NF_CONNTRACK_SNMP
> diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
> index 34e436c..902bcd1 100644
> --- a/net/ipv4/netfilter/Makefile
> +++ b/net/ipv4/netfilter/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
>  obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
>  obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
>  obj-$(CONFIG_NFT_MASQ_IPV4) += nft_masq_ipv4.o
> +obj-$(CONFIG_NFT_REDIR_IPV4) += nft_redir_ipv4.o
>  obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
>  
>  # generic IP tables 
[...]
> diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
> new file mode 100644
> index 0000000..1d414a7
> --- /dev/null
> +++ b/net/netfilter/nft_redir.c
> @@ -0,0 +1,93 @@
> +/*
> + * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/netlink.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_nat.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nft_redir.h>
> +
> +const struct nla_policy nft_redir_policy[NFTA_REDIR_MAX + 1] = {
> +	[NFTA_REDIR_REG_PROTO_MIN]	= { .type = NLA_U32 },
> +	[NFTA_REDIR_REG_PROTO_MAX]	= { .type = NLA_U32 },
> +	[NFTA_REDIR_FLAGS]		= { .type = NLA_U32 },
> +};
> +EXPORT_SYMBOL_GPL(nft_redir_policy);
> +
> +int nft_redir_init(const struct nft_ctx *ctx,
> +		   const struct nft_expr *expr,
> +		   const struct nlattr * const tb[])
> +{
> +	struct nft_redir *priv = nft_expr_priv(expr);
> +	int err;
> +
> +	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
> +		priv->sreg_proto_min = ntohl(nla_get_be32(
> +						tb[NFTA_REDIR_REG_PROTO_MIN]));

I prefer this:

		priv->sreg_proto_min =
                        ntohl(nla_get_be32(tb[NFTA_REDIR_REG_PROTO_MIN]));


> +		err = nft_validate_input_register(priv->sreg_proto_min);
> +		if (err < 0)
> +			return err;
> +	}

No else here? ->sreg_proto_min is left uninitialized.

> +
> +	if (tb[NFTA_REDIR_REG_PROTO_MAX]) {
> +		priv->sreg_proto_max = ntohl(nla_get_be32(
> +						tb[NFTA_REDIR_REG_PROTO_MAX]));

Same thing here.

> +		err = nft_validate_input_register(priv->sreg_proto_max);
> +		if (err < 0)
> +			return err;
> +	} else
> +		priv->sreg_proto_max = priv->sreg_proto_min;

Missing brackets wrapping around this 'else'.

> +
> +	if (tb[NFTA_REDIR_FLAGS]) {
> +		priv->flags = ntohl(nla_get_be32(tb[NFTA_REDIR_FLAGS]));
> +		if (priv->flags & ~NF_NAT_RANGE_MASK)
> +			return -EINVAL;
> +	}
> +
> +

extra line, remove it.

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nft_redir_init);
> +
> +int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +{
> +	const struct nft_redir *priv = nft_expr_priv(expr);
> +
> +	if (priv->sreg_proto_min) {
> +		if (nla_put_be32(skb, NFTA_REDIR_REG_PROTO_MIN,
> +				 htonl(priv->sreg_proto_min)))
> +			goto nla_put_failure;
> +		if (nla_put_be32(skb, NFTA_REDIR_REG_PROTO_MAX,
> +				 htonl(priv->sreg_proto_max)))
> +			goto nla_put_failure;
> +	}
> +
> +	if (priv->flags != 0) {
> +		if (nla_put_be32(skb, NFTA_REDIR_FLAGS, htonl(priv->flags)))
> +			goto nla_put_failure;
> +	}
> +
> +	if (priv->flags == 0)
> +		return 0;
> +
> +	if (nla_put_be32(skb, NFTA_REDIR_FLAGS, htonl(priv->flags)))
> +		goto nla_put_failure;

These 10 lines above are freak. I guess you can refactor this to:

        if (priv->flags != 0 &&
            nla_put_...
                goto nla_put_failure;
