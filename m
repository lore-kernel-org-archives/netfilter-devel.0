From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 1/4] libnftables: Move library stuff out of main.c
Date: Tue, 24 Oct 2017 17:48:00 +0200
Message-ID: <20171024154800.GA11705@salvia>
References: <20171023153319.13415-1-phil@nwl.cc>
 <20171023153319.13415-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50374 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750897AbdJXPsE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 11:48:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 87767E8EB0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:48:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7697ADA86D
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 17:48:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171023153319.13415-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

Just follow up comments, several things that I think we can polish,
see below.

On Mon, Oct 23, 2017 at 05:33:16PM +0200, Phil Sutter wrote:
[...]
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> new file mode 100644
> index 0000000000000..44d3e95d399e6
> --- /dev/null
> +++ b/include/nftables/nftables.h
> @@ -0,0 +1,58 @@
> +/*
> + * Copyright (c) 2017 Eric Leblond <eric@regit.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +#ifndef LIB_NFTABLES_H
> +#define LIB_NFTABLES_H
> +
> +#define _GNU_SOURCE
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdbool.h>
> +
> +struct nft_ctx;
> +
> +enum debug_level {
> +	DEBUG_SCANNER		= 0x1,
> +	DEBUG_PARSER		= 0x2,
> +	DEBUG_EVALUATION	= 0x4,
> +	DEBUG_NETLINK		= 0x8,
> +	DEBUG_MNL		= 0x10,
> +	DEBUG_PROTO_CTX		= 0x20,
> +	DEBUG_SEGTREE		= 0x40,
> +};
> +
> +enum numeric_level {
> +	NUMERIC_NONE,
> +	NUMERIC_ADDR,
> +	NUMERIC_PORT,
> +	NUMERIC_ALL,
> +};

Just pushed out a patch to prepend NFT_ prefix.

> +/**
> + * Possible flags to pass to nft_ctx_new()
> + */
> +#define NFT_CTX_DEFAULT		0
> +
> +/**
> + * Exit codes returned by nft_run_cmd_from_*()
> + */
> +enum nftables_exit_codes {
> +	NFT_EXIT_SUCCESS	= 0,
> +	NFT_EXIT_FAILURE	= 1,
> +	NFT_EXIT_NOMEM		= 2,
> +	NFT_EXIT_NONL		= 3,
> +};

I think library is currently aborting in case of no-netlink and
no-memory, so these two error codes are not useful.

We would need to change codebase to propagate errors up to the
callers.

Regarding error code, I would go for -1 in case of error instead and 0
in case of success. If failure happens, then set errno with reason, so
we can get rid of these exit codes in a follow up patch?
