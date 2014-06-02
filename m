From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 2/2] netfilter: nf_tables: split nft_log in
 AF-specific modules
Date: Mon, 2 Jun 2014 13:38:50 +0200
Message-ID: <20140602113850.GB17123@localhost>
References: <20140602112614.2928.43293.stgit@nfdev.cica.es>
 <20140602112620.2928.42032.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55034 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbaFBLjG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:39:06 -0400
Content-Disposition: inline
In-Reply-To: <20140602112620.2928.42032.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 02, 2014 at 01:26:20PM +0200, Arturo Borrero Gonzalez wrote:
> diff --git a/net/netfilter/nft_log_inet.c b/net/netfilter/nft_log_inet.c
> new file mode 100644
> index 0000000..b982df8
> --- /dev/null
> +++ b/net/netfilter/nft_log_inet.c
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
> + * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
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
> +#include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_log.h>
> +#include <linux/netdevice.h>
> +#include <net/netfilter/nft_log.h>
> +#include <net/netfilter/ipv4/nft_log_ipv4.h>
> +#include <net/netfilter/ipv6/nft_log_ipv6.h>
> +
> +static void nft_log_inet_eval(const struct nft_expr *expr,
> +			      struct nft_data data[NFT_REG_MAX + 1],
> +			      const struct nft_pktinfo *pkt)
> +{
> +	switch (pkt->ops->pf) {
> +	case NFPROTO_IPV4:
> +		nft_log_ipv4_eval(expr, data, pkt);

missing break here. Otherwise, it falls back on the IPv6 code too.

> +	case NFPROTO_IPV6:
> +		nft_log_ipv6_eval(expr, data, pkt);

Not really needed, but my suggestion is to add it here as well for
consistency.
