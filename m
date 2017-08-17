From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 01/16] libnftables: introduce library
Date: Thu, 17 Aug 2017 10:57:50 +0200
Message-ID: <20170817085750.GS16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-2-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44437 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751586AbdHQI5v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 04:57:51 -0400
Content-Disposition: inline
In-Reply-To: <20170816204310.3371-2-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:42:55PM +0200, Eric Leblond wrote:
[...]
> diff --git a/src/libnftables.c b/src/libnftables.c
> new file mode 100644
> index 0000000..215179a
> --- /dev/null
> +++ b/src/libnftables.c
> @@ -0,0 +1,53 @@
> +/*
> + * Copyright (c) 2017 Eric Leblond <eric@regit.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <nftables/nftables.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <nftables.h>
> +#include <parser.h>
> +#include <iface.h>
> +#include <netlink.h>
> +#include <erec.h>
> +#include <libmnl/libmnl.h>
> +#include <mnl.h>
> +
> +#include <unistd.h>
> +#include <fcntl.h>
> +
> +
> +unsigned int max_errors = 10;
> +unsigned int numeric_output;
> +unsigned int ip2name_output;
> +unsigned int handle_output;
> +#ifdef DEBUG
> +unsigned int debug_level;
> +#endif

I guess these global variables have to die. I tried static linking (for
quick testing without installing) which didn't work because max_errors
is then redefined here. (There is a stale one in main.c which you
probably just forgot to remove.)

Maybe max_errors could become part of struct nft_ctx? Alternatively I
would make it static and add a getter to be used from parser_bison.y.

The remaining ones apart from debug_level are leftovers, they live in
struct output_ctx now.

I am not sure where debug_level really belongs to. One one hand, it has
something to do with printing, so struct output_ctx. On the other,
nft_ctx would have to be made reachable from all places where debug
output happens.

Maybe the whole debugging infrastructure (i.e. debug data dumpers and
printers) should be exported to the application?

> +
> +void nft_global_init(void)
> +{
> +	mark_table_init();
> +	realm_table_rt_init();
> +	devgroup_table_init();
> +	realm_table_meta_init();
> +	ct_label_table_init();
> +	gmp_init();
> +#ifdef HAVE_LIBXTABLES
> +	xt_init();
> +#endif
> +}
> +
> +void nft_global_deinit(void)
> +{
> +	ct_label_table_exit();
> +	realm_table_rt_exit();
> +	devgroup_table_exit();
> +	realm_table_meta_exit();
> +	mark_table_exit();
> +}

How about calling these from nft_context_new() and nft_context_free()?

Cheers, Phil
