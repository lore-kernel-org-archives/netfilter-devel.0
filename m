From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nft_nth: match every n packets
Date: Tue, 26 Jul 2016 18:17:34 +0200
Message-ID: <20160726161734.GA21936@salvia>
References: <20160726142207.GA18550@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49384 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbcGZQRo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 12:17:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 89B571B7F91
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 18:17:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 76DDEFAB48
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 18:17:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4B4D3FAB48
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 18:17:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160726142207.GA18550@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 26, 2016 at 04:22:10PM +0200, Laura Garcia Liebana wrote:
> Add support for the nth expression in netfilter. A nft_nth structure is created with dreg (to store the result into a given register), data (a nft_data structure to store the input value, it must be > 0), every (to store the data) and counter (to store atomically the current value).

Please, break lines at 80 characters for patch descriptions.

More comments below.

> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  include/net/netfilter/nft_nth.h          |  31 +++++++
>  include/uapi/linux/netfilter/nf_tables.h |  15 ++++
>  net/netfilter/Kconfig                    |   6 ++
>  net/netfilter/Makefile                   |   1 +
>  net/netfilter/nft_nth.c                  | 145 +++++++++++++++++++++++++++++++
>  5 files changed, 198 insertions(+)
>  create mode 100644 include/net/netfilter/nft_nth.h
>  create mode 100644 net/netfilter/nft_nth.c
> 
> diff --git a/include/net/netfilter/nft_nth.h b/include/net/netfilter/nft_nth.h
> new file mode 100644
> index 0000000..0d8788d
> --- /dev/null
> +++ b/include/net/netfilter/nft_nth.h
> @@ -0,0 +1,31 @@
> +#ifndef _NFT_NTH_H_
> +#define _NFT_NTH_H_
> +
> +struct nft_nth {
> +	enum nft_registers      dreg:8;
> +	struct nft_data         data;

You don't need this data variable, see below why.

> +	u32		every;
> +	struct nft_nth_priv *master __attribute__((aligned(8)));

You can remove this master pointer, this was only required by xtables.

Declare atomic_t counter here and initialize it from init().

> +};
> +
> +struct nft_nth_priv {
> +	atomic_t counter;
> +} ____cacheline_aligned_in_smp;
> +
> +extern const struct nla_policy nft_nth_policy[];
> +
> +int nft_nth_init(const struct nft_ctx *ctx,
> +		 const struct nft_expr *expr,
> +		 const struct nlattr * const tb[]);
> +
> +int nft_nth_dump(struct sk_buff *skb,
> +		 const struct nft_expr *expr);
> +
> +void nft_nth_eval(const struct nft_expr *expr,
> +		  struct nft_regs *regs,
> +		  const struct nft_pktinfo *pkt);
> +
> +void nft_nth_destroy(const struct nft_ctx *ctx,
> +		     const struct nft_expr *expr);

You don't need this header file. Make nft_nth_init() and other
function static, see below.

> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 6a4dbe0..5ba075a 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -1076,4 +1076,19 @@ enum nft_trace_types {
>  	__NFT_TRACETYPE_MAX
>  };
>  #define NFT_TRACETYPE_MAX (__NFT_TRACETYPE_MAX - 1)
> +
> +/**
> + * enum nft_nth_attributes - nf_tables nth expression netlink attributes
> + * @NFTA_NTH_UNSPEC: unspecified attribute
> + * @NFTA_NTH_DREG: destination register (NLA_U32)
> + * @NFTA_NTH_DATA: source data (NLA_NESTED)

Rename NTH_DATA to NTH_EVERY.

> + */
> +enum nft_nth_attributes {
> +	NFTA_NTH_UNSPEC,
> +	NFTA_NTH_DREG,
> +	NFTA_NTH_DATA,
> +	__NFTA_NTH_MAX
> +};
> +#define NFTA_NTH_MAX	(__NFTA_NTH_MAX - 1)
> +
>  #endif /* _LINUX_NF_TABLES_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 95e757c..6f00d01 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -474,6 +474,12 @@ config NFT_META
>  	  This option adds the "meta" expression that you can use to match and
>  	  to set packet metainformation such as the packet mark.
>  
> +config NFT_NTH
> +	tristate "Netfilter nf_tables nth module"
> +	help
> +	  This option adds the "nth" expression that you can use to match a
> +	  packet every a specific given value.
> +
>  config NFT_CT
>  	depends on NF_CONNTRACK
>  	tristate "Netfilter nf_tables conntrack module"
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 6913454..2378f00 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -80,6 +80,7 @@ obj-$(CONFIG_NF_TABLES_NETDEV)	+= nf_tables_netdev.o
>  obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
>  obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
>  obj-$(CONFIG_NFT_META)		+= nft_meta.o
> +obj-$(CONFIG_NFT_NTH)		+= nft_nth.o
>  obj-$(CONFIG_NFT_CT)		+= nft_ct.o
>  obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
>  obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
> diff --git a/net/netfilter/nft_nth.c b/net/netfilter/nft_nth.c
> new file mode 100644
> index 0000000..d0a5387
> --- /dev/null
> +++ b/net/netfilter/nft_nth.c
> @@ -0,0 +1,145 @@
> +/*
> + * Copyright (c) 2016 Laura Garcia <nevola@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/netlink.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <linux/in.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/smp.h>
> +#include <linux/static_key.h>
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables_core.h>
> +#include <net/netfilter/nft_nth.h>
> +
> +void nft_nth_eval(const struct nft_expr *expr,
> +		  struct nft_regs *regs,
> +		  const struct nft_pktinfo *pkt)
> +{
> +	struct nft_nth *nth = nft_expr_priv(expr);
> +	u32 nval, oval;
> +
> +	do {
> +		oval = atomic_read(&nth->master->counter);
> +		nval = (oval+1 < nth->every) ? oval+1 : 0;
> +	} while (atomic_cmpxchg(&nth->master->counter, oval, nval) != oval);
> +
> +	memcpy(&regs->data[nth->dreg], &nth->master->counter, sizeof(u32));
> +}
> +EXPORT_SYMBOL_GPL(nft_nth_eval);
> +
> +const struct nla_policy nft_nth_policy[NFTA_NTH_MAX + 1] = {
> +	[NFTA_NTH_DREG]	= { .type = NLA_U32 },
> +	[NFTA_NTH_DATA]	= { .type = NLA_NESTED },
> +};
> +
> +int nft_nth_init(const struct nft_ctx *ctx,
> +		 const struct nft_expr *expr,
> +		 const struct nlattr * const tb[])

This should be:

static int nft_nth_init(const struct nft_ctx *ctx,
                        const struct nft_expr *expr,
                        const struct nlattr * const tb[])

Same thing for every function.

> +{
> +	struct nft_nth *nth = nft_expr_priv(expr);
> +	struct nft_data_desc desc;
> +	int err = 0;
> +
> +	err = nft_data_init(NULL, &nth->data,
> +			    sizeof(nth->data), &desc,
> +			    tb[NFTA_NTH_DATA]);
> +	if (err < 0)
> +		goto err;
> +
> +	memcpy(&nth->every, &nth->data, sizeof(u32));
> +	if (nth->every == 0)
> +		return -EINVAL;

You can simplify this above to something like:

        priv->every = ntohl(nla_get_be32(tb[NFTA_NTH_EVERY]));

> +
> +	nth->dreg = nft_parse_register(tb[NFTA_NTH_DREG]);
> +
> +	nth->master = kzalloc(sizeof(*nth->master), GFP_KERNEL);
> +	if (!nth->master)
> +		return -ENOMEM;
> +	atomic_set(&nth->master->counter, 0);
> +
> +err:
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(nft_nth_init);

No need to export these symbols.
