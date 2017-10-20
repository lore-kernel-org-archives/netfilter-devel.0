From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/7] libnftables: Move library stuff out of main.c
Date: Fri, 20 Oct 2017 14:12:02 +0200
Message-ID: <20171020121202.GB4068@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43004 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752727AbdJTMMH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 08:12:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F3296926B
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:12:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0E61DA874
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:12:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019081847.16171-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 10:18:42AM +0200, Phil Sutter wrote:
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/Makefile.am          |   3 +-
>  include/nftables.h           |  65 +----------
>  include/nftables/Makefile.am |   1 +
>  include/nftables/nftables.h  |  88 +++++++++++++++
>  src/Makefile.am              |   3 +-
>  src/libnftables.c            | 261 +++++++++++++++++++++++++++++++++++++++++++
>  src/main.c                   | 253 +----------------------------------------
>  7 files changed, 356 insertions(+), 318 deletions(-)
>  create mode 100644 include/nftables/Makefile.am
>  create mode 100644 include/nftables/nftables.h
>  create mode 100644 src/libnftables.c
> 
> diff --git a/include/Makefile.am b/include/Makefile.am
> index 5dd73d81f427e..a74ffbfa8de0a 100644
> --- a/include/Makefile.am
> +++ b/include/Makefile.am
> @@ -1,4 +1,5 @@
> -SUBDIRS = linux
> +SUBDIRS =		linux		\
> +			nftables
>  
>  noinst_HEADERS = 	cli.h		\
>  			datatype.h	\
> diff --git a/include/nftables.h b/include/nftables.h
> index 01d72a87212ea..a633e1a2cc2e2 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -4,63 +4,7 @@
>  #include <stdbool.h>
>  #include <stdarg.h>
>  #include <utils.h>
> -
> -enum numeric_level {
> -	NUMERIC_NONE,
> -	NUMERIC_ADDR,
> -	NUMERIC_PORT,
> -	NUMERIC_ALL,
> -};
> -
> -enum debug_level {
> -	DEBUG_SCANNER		= 0x1,
> -	DEBUG_PARSER		= 0x2,
> -	DEBUG_EVALUATION	= 0x4,
> -	DEBUG_NETLINK		= 0x8,
> -	DEBUG_MNL		= 0x10,
> -	DEBUG_PROTO_CTX		= 0x20,
> -	DEBUG_SEGTREE		= 0x40,
> -};
> -
> -#define INCLUDE_PATHS_MAX	16
> -
> -struct output_ctx {
> -	unsigned int numeric;
> -	unsigned int stateless;
> -	unsigned int ip2name;
> -	unsigned int handle;
> -	unsigned int echo;
> -	FILE *output_fp;
> -};
> -
> -struct nft_cache {
> -	bool			initialized;
> -	struct list_head	list;
> -	uint32_t		seqnum;
> -};
> -
> -struct mnl_socket;
> -
> -struct nft_ctx {
> -	struct mnl_socket	*nf_sock;
> -	const char		*include_paths[INCLUDE_PATHS_MAX];
> -	unsigned int		num_include_paths;
> -	unsigned int		parser_max_errors;
> -	unsigned int		debug_mask;
> -	struct output_ctx	output;
> -	bool			check;
> -	struct nft_cache	cache;
> -	uint32_t		flags;
> -};
> -
> -#define NFT_CTX_DEFAULT		0
> -
> -enum nftables_exit_codes {
> -	NFT_EXIT_SUCCESS	= 0,
> -	NFT_EXIT_FAILURE	= 1,
> -	NFT_EXIT_NOMEM		= 2,
> -	NFT_EXIT_NONL		= 3,
> -};
> +#include <nftables/nftables.h>
>  
>  struct input_descriptor;
>  struct location {
> @@ -128,13 +72,6 @@ struct input_descriptor {
>  	off_t				line_offset;
>  };
>  
> -struct parser_state;
> -struct mnl_socket;
> -
> -int nft_run(struct nft_ctx *nft, struct mnl_socket *nf_sock,
> -	    void *scanner, struct parser_state *state,
> -	    struct list_head *msgs);
> -
>  void ct_label_table_init(void);
>  void mark_table_init(void);
>  void gmp_init(void);
> diff --git a/include/nftables/Makefile.am b/include/nftables/Makefile.am
> new file mode 100644
> index 0000000000000..9e31d519599c1
> --- /dev/null
> +++ b/include/nftables/Makefile.am
> @@ -0,0 +1 @@
> +noinst_HEADERS = nftables.h
> diff --git a/include/nftables/nftables.h b/include/nftables/nftables.h
> new file mode 100644
> index 0000000000000..052a77bfb5371
> --- /dev/null
> +++ b/include/nftables/nftables.h

Is this nftables/nftables.h file what we will expose later on as
header for this library?

If so... see below.

> @@ -0,0 +1,88 @@
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
> +struct parser_state;
> +struct mnl_socket;
> +
> +struct nft_cache {
> +	bool			initialized;
> +	struct list_head	list;
> +	uint32_t		seqnum;
> +};
> +
> +#define INCLUDE_PATHS_MAX	16
> +
> +struct output_ctx {
> +	unsigned int numeric;
> +	unsigned int stateless;
> +	unsigned int ip2name;
> +	unsigned int handle;
> +	unsigned int echo;
> +	FILE *output_fp;
> +};

I think these structure should be just like:

struct output_ctx;

as a forward declaration. So we enforce users to use getters and
setters.

So we can just move easily in a follow up patch to expose the library
API to everyone, right?

Thanks.
