From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v2 3/3] netfilter: nf_tables: add new
 expression nft_redir
Date: Thu, 16 Oct 2014 14:05:23 +0200
Message-ID: <20141016120523.GD3346@salvia>
References: <20141016102224.4715.64585.stgit@nfdev.cica.es>
 <20141016102403.4715.34436.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41840 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaJPMD5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:03:57 -0400
Content-Disposition: inline
In-Reply-To: <20141016102403.4715.34436.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 16, 2014 at 12:25:08PM +0200, Arturo Borrero Gonzalez wrote:
> diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
> new file mode 100644
> index 0000000..424cbf1
> --- /dev/null
> +++ b/net/netfilter/nft_redir.c
> @@ -0,0 +1,86 @@
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
> +	[NFTA_REDIR_FLAGS]		= { .type = NLA_U16 },
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
> +		priv->sreg_proto_min =
> +			ntohl(nla_get_be32(tb[NFTA_REDIR_REG_PROTO_MIN]));
> +		err = nft_validate_input_register(priv->sreg_proto_min);
> +		if (err < 0)
> +			return err;


Add the max handling here:

                if (tb[NFTA_REDIR_REG_PROTO_MAX]) {
                        ...
                }
> +	}

The idea is that NFTA_REDIR_REG_PROTO_MAX is only interpreted if
NFTA_REDIR_REG_PROTO_MIN is specified. I'll send a similar patch for
nft_nat.

Thanks Arturo.
