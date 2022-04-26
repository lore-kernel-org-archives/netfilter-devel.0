Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833E7C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 16:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352810AbiDZQJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 12:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352826AbiDZQJz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 12:09:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF0D49244
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 09:06:45 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1njNi5-0003s1-VJ; Tue, 26 Apr 2022 18:06:42 +0200
Date:   Tue, 26 Apr 2022 18:06:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables 7/7] nft: support for dynamic register allocation
Message-ID: <YmgYkZE7hZFVL0D4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220424215613.106165-1-pablo@netfilter.org>
 <20220424215613.106165-8-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424215613.106165-8-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sun, Apr 24, 2022 at 11:56:13PM +0200, Pablo Neira Ayuso wrote:
> Starting Linux kernel 5.18-rc, operations on registers that already
> contain the expected data are turned into noop.
> 
> Track operation on registers to use the same register through
> payload_get_register() and meta_get_register(). This patch introduces an
> LRU eviction strategy when all the registers are in used.
> 
> get_register() is used to allocate a register as scratchpad area: no
> tracking is performed in this case. This is used for concatenations,
> eg. ebt_among.
> 
> Using samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
> 
> Benchmark #1: match on IPv6 address list
> 
>  *raw
>  :PREROUTING DROP [9:2781]
>  :OUTPUT ACCEPT [0:0]
>  -A PREROUTING -d aaaa::bbbb -j DROP
>  [... 98 times same rule above to trigger mismatch ...]
>  -A PREROUTING -d fd00::1 -j DROP			# matching rule
> 
>  iptables-legacy	798Mb
>  iptables-nft		801Mb (+0.37)
> 
> Benchmark #2: match on layer 4 protocol + port list
> 
>  *raw
>  :PREROUTING DROP [9:2781]
>  :OUTPUT ACCEPT [0:0]
>  -A PREROUTING -p tcp --dport 23 -j DROP
>  [... 98 times same rule above to trigger mismatch ...]
>  -A PREROUTING -p udp --dport 9 -j DROP 		# matching rule
> 
>  iptables-legacy	648Mb
>  iptables-nft		892Mb (+37.65%)
> 
> Benchmark #3: match on mark
> 
>  *raw
>  :PREROUTING DROP [9:2781]
>  :OUTPUT ACCEPT [0:0]
>  -A PREROUTING -m mark --mark 100 -j DROP
>  [... 98 times same rule above to trigger mismatch ...]
>  -A PREROUTING -d 198.18.0.42/32 -j DROP		# matching rule
> 
>  iptables-legacy	255Mb
>  iptables-nft		865Mb (+239.21%)

Great results, but obviously biased test cases. Did you measure a more
"realistic" ruleset?

> In these cases, iptables-nft generates netlink bytecode which uses the
> native expressions, ie. payload + cmp and meta + cmp.

Sounds like a real point for further conversion into native nftables
expressions where possible.

[...]
> diff --git a/iptables/nft-regs.c b/iptables/nft-regs.c
> new file mode 100644
> index 000000000000..bfc762e4186f
> --- /dev/null
> +++ b/iptables/nft-regs.c
> @@ -0,0 +1,191 @@
> +/*
> + * (C) 2012-2022 by Pablo Neira Ayuso <pablo@netfilter.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +/* Funded through the NGI0 PET Fund established by NLnet (https://nlnet.nl)
> + * with support from the European Commission's Next Generation Internet
> + * programme.
> + */
> +
> +#include <string.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdbool.h>
> +#include <errno.h>
> +#include <assert.h>
> +
> +#include "nft.h"
> +#include "nft-regs.h"
> +
> +static uint64_t reg_genid(struct nft_handle *h)
> +{
> +	return ++h->reg_genid;
> +}
> +
> +struct nft_reg_ctx {
> +	uint64_t	genid;
> +	int		reg;
> +	int		evict;
> +};

Move this struct declaration above the first function?

> +
> +static int reg_space(int i)
> +{
> +	return sizeof(uint32_t) * 16 - sizeof(uint32_t) * i;
> +}
> +
> +static void register_track(const struct nft_handle *h,
> +			   struct nft_reg_ctx *ctx, int i, int len)
> +{
> +	if (ctx->reg >= 0 || h->regs[i].word || reg_space(i) < len)
> +		return;

Since ctx->reg is not reset in callers' loops and reg_space(i) is
monotonic, maybe make those loop exit conditions by returning false from
register_track() in those cases?

> +	if (h->regs[i].type == NFT_REG_UNSPEC) {
> +		ctx->genid = h->reg_genid;

Is ctx->genid used in this case?

> +		ctx->reg = i;
> +	} else if (h->regs[i].genid < ctx->genid) {
> +		ctx->genid = h->regs[i].genid;
> +		ctx->evict = i;

What if the oldest reg is too small?

> +	} else if (h->regs[i].len == len) {
> +		ctx->evict = i;
> +		ctx->genid = 0;

Why prefer regs of same size over older ones?

> +	}
> +}
> +
> +static void register_evict(struct nft_reg_ctx *ctx, int i)

Unused parameter i.

> +{
> +	if (ctx->reg < 0) {
> +		assert(ctx->evict >= 0);
> +		ctx->reg = ctx->evict;
> +	}
> +}
> +
> +static void __register_update(struct nft_handle *h, uint8_t reg,
> +			      int type, uint32_t len, uint8_t word,
> +			      uint64_t genid)
> +{
> +	h->regs[reg].type = type;
> +	h->regs[reg].genid = genid;
> +	h->regs[reg].len = len;
> +	h->regs[reg].word = word;
> +}
> +
> +static void register_cancel(struct nft_handle *h, struct nft_reg_ctx *ctx)
> +{
> +	int plen = h->regs[ctx->reg].len, i;
> +
> +	for (i = ctx->reg; plen > 0; i++, plen -= sizeof(uint32_t)) {
> +		h->regs[i].type = NFT_REG_UNSPEC;
> +		h->regs[i].word = 0;
> +	}
> +
> +	while (h->regs[i].word != 0) {
> +		h->regs[i].type = NFT_REG_UNSPEC;
> +		h->regs[i].word = 0;
> +		i++;
> +	}
> +}
> +
> +static void register_update(struct nft_handle *h, struct nft_reg_ctx *ctx,
> +			    int type, uint32_t len, uint64_t genid)
> +{
> +	register_cancel(h, ctx);
> +	__register_update(h, ctx->reg, type, len, 0, genid);
> +}
> +
> +uint8_t meta_get_register(struct nft_handle *h, enum nft_meta_keys key)

Accept a uint32_t len parameter and replace all the sizeof(uint32_t)
below with it? Not needed but consistent with payload_get_register() and
less hard-coded values.

> +{
> +	struct nft_reg_ctx ctx = {
> +		.reg	= -1,
> +		.evict	= -1,
> +		.genid	= UINT64_MAX,
> +	};
> +	uint64_t genid;
> +	int i;
> +
> +	for (i = 0; i < 16; i++) {
> +		register_track(h, &ctx, i, sizeof(uint32_t));
> +
> +		if (h->regs[i].type != NFT_REG_META)
> +			continue;
> +
> +		if (h->regs[i].meta.key == key &&
> +		    h->regs[i].len == sizeof(uint32_t)) {
> +			h->regs[i].genid = reg_genid(h);
> +			return i + NFT_REG32_00;
> +		}
> +	}
> +
> +	register_evict(&ctx, i);
> +
> +	genid = reg_genid(h);
> +	register_update(h, &ctx, NFT_REG_META, sizeof(uint32_t), genid);
> +	h->regs[ctx.reg].meta.key = key;
> +
> +	return ctx.reg + NFT_REG32_00;
> +}
> +
> +uint8_t payload_get_register(struct nft_handle *h, enum nft_payload_bases base,
> +			    uint32_t offset, uint32_t len)
> +{
> +	struct nft_reg_ctx ctx = {
> +		.reg	= -1,
> +		.evict	= -1,
> +		.genid	= UINT64_MAX,
> +	};
> +	int i, j, plen = len;
> +	uint64_t genid;
> +
> +	for (i = 0; i < 16; i++) {
> +		register_track(h, &ctx, i, len);
> +
> +		if (h->regs[i].type != NFT_REG_PAYLOAD)
> +			continue;
> +
> +		if (h->regs[i].payload.base == base &&
> +		    h->regs[i].payload.offset == offset &&
> +		    h->regs[i].len >= plen) {
> +			h->regs[i].genid = reg_genid(h);
> +			return i + NFT_REG32_00;
> +		}
> +	}
> +
> +	register_evict(&ctx, i);
> +
> +	genid = reg_genid(h);
> +	register_update(h, &ctx, NFT_REG_PAYLOAD, len, genid);
> +	h->regs[ctx.reg].payload.base = base;
> +	h->regs[ctx.reg].payload.offset = offset;
> +
> +	plen -= sizeof(uint32_t);
> +	j = 1;
> +	for (i = ctx.reg + 1; plen > 0; i++, plen -= sizeof(uint32_t)) {
> +		__register_update(h, i, NFT_REG_PAYLOAD, len, j++, genid);
> +		h->regs[i].payload.base = base;
> +		h->regs[i].payload.offset = offset;
> +	}
> +
> +	return ctx.reg + NFT_REG32_00;
> +}
> +
> +uint8_t get_register(struct nft_handle *h, uint8_t len)
> +{
> +	struct nft_reg_ctx ctx = {
> +		.reg	= -1,
> +		.evict	= -1,
> +		.genid	= UINT64_MAX,
> +	};
> +	int i;
> +
> +	for (i = 0; i < 16; i++)
> +		register_track(h, &ctx, i, len);
> +
> +	register_evict(&ctx, i);
> +	register_cancel(h, &ctx);
> +
> +	return ctx.reg + NFT_REG32_00;
> +}
> diff --git a/iptables/nft-regs.h b/iptables/nft-regs.h
> new file mode 100644
> index 000000000000..3953eae9f217
> --- /dev/null
> +++ b/iptables/nft-regs.h
> @@ -0,0 +1,9 @@
> +#ifndef _NFT_REGS_H_
> +#define _NFT_REGS_H_
> +
> +uint8_t payload_get_register(struct nft_handle *h, enum nft_payload_bases base,
> +			     uint32_t offset, uint32_t len);
> +uint8_t meta_get_register(struct nft_handle *h, enum nft_meta_keys key);
> +uint8_t get_register(struct nft_handle *h, uint8_t len);
> +
> +#endif /* _NFT_REGS_H_ */
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index 27e95c1ae4f3..ad5361942093 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -32,6 +32,7 @@
>  
>  #include "nft-shared.h"
>  #include "nft-bridge.h"
> +#include "nft-regs.h"
>  #include "xshared.h"
>  #include "nft.h"
>  
> @@ -50,7 +51,7 @@ void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key,
>  	if (expr == NULL)
>  		return;
>  
> -	reg = NFT_REG_1;
> +	reg = meta_get_register(h, key);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_KEY, key);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_DREG, reg);
>  	nftnl_rule_add_expr(r, expr);
> @@ -68,7 +69,7 @@ void add_payload(struct nft_handle *h, struct nftnl_rule *r,
>  	if (expr == NULL)
>  		return;
>  
> -	reg = NFT_REG_1;
> +	reg = payload_get_register(h, base, offset, len);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_BASE, base);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_DREG, reg);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
> @@ -89,7 +90,7 @@ void add_bitwise_u16(struct nft_handle *h, struct nftnl_rule *r,
>  	if (expr == NULL)
>  		return;
>  
> -	reg = NFT_REG_1;
> +	reg = get_register(h, sizeof(uint32_t));
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_LEN, sizeof(uint16_t));
> @@ -105,12 +106,13 @@ void add_bitwise(struct nft_handle *h, struct nftnl_rule *r,
>  {
>  	struct nftnl_expr *expr;
>  	uint32_t xor[4] = { 0 };
> -	uint8_t reg = *dreg;
> +	uint8_t reg;
>  
>  	expr = nftnl_expr_alloc("bitwise");
>  	if (expr == NULL)
>  		return;
>  
> +	reg = get_register(h, len);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
>  	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_LEN, len);
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 07653ee1a3d6..48330f285703 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -56,6 +56,7 @@
>  #include <arpa/inet.h>
>  
>  #include "nft.h"
> +#include "nft-regs.h"
>  #include "xshared.h" /* proto_to_name */
>  #include "nft-cache.h"
>  #include "nft-shared.h"
> @@ -1112,7 +1113,7 @@ gen_payload(struct nft_handle *h, uint32_t base, uint32_t offset, uint32_t len,
>  	struct nftnl_expr *e;
>  	uint8_t reg;
>  
> -	reg = NFT_REG_1;
> +	reg = payload_get_register(h, base, offset, len);
>  	e = __gen_payload(base, offset, len, reg);
>  	*dreg = reg;
>  
> @@ -1157,10 +1158,10 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
>  		offsetof(struct iphdr, saddr),
>  		offsetof(struct iphdr, daddr)
>  	};
> +	uint8_t reg, concat_len;
>  	struct nftnl_expr *e;
>  	struct nftnl_set *s;
>  	uint32_t flags = 0;
> -	uint8_t reg;
>  	int idx = 0;
>  
>  	if (ip) {
> @@ -1201,21 +1202,26 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
>  		nftnl_set_elem_add(s, elem);
>  	}
>  
> -	e = gen_payload(h, NFT_PAYLOAD_LL_HEADER,
> -			eth_addr_off[dst], ETH_ALEN, &reg);
> +	concat_len = ETH_ALEN;
> +	if (ip)
> +		concat_len += sizeof(struct in_addr);
> +
> +	reg = get_register(h, concat_len);
> +	e = __gen_payload(NFT_PAYLOAD_LL_HEADER,
> +			  eth_addr_off[dst], ETH_ALEN, reg);
>  	if (!e)
>  		return -ENOMEM;
>  	nftnl_rule_add_expr(r, e);
>  
>  	if (ip) {
> -		e = gen_payload(h, NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
> -				sizeof(struct in_addr), &reg);
> +		e = __gen_payload(NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
> +				  sizeof(struct in_addr), reg + 2);

With a respective macro, this could be 'reg + REG_ALIGN(ETH_ALEN)'.

>  		if (!e)
>  			return -ENOMEM;
>  		nftnl_rule_add_expr(r, e);
>  	}
>  
> -	reg = NFT_REG_1;
> +	reg = get_register(h, sizeof(uint32_t));
>  	e = gen_lookup(reg, "__set%d", set_id, inv);
>  	if (!e)
>  		return -ENOMEM;
> diff --git a/iptables/nft.h b/iptables/nft.h
> index 68b0910c8e18..3dc907b188ce 100644
> --- a/iptables/nft.h
> +++ b/iptables/nft.h
> @@ -85,6 +85,28 @@ struct nft_cache_req {
>  	struct list_head	chain_list;
>  };
>  
> +enum nft_reg_type {
> +	NFT_REG_UNSPEC	= 0,
> +	NFT_REG_PAYLOAD,
> +	NFT_REG_META,
> +};
> +
> +struct nft_regs {
> +	enum nft_reg_type			type;
> +	uint32_t				len;
> +	uint64_t				genid;
> +	uint8_t					word;
> +	union {
> +		struct {
> +			enum nft_meta_keys	key;
> +		} meta;
> +		struct {
> +			enum nft_payload_bases	base;
> +			uint32_t		offset;
> +		} payload;
> +	};
> +};
> +
>  struct nft_handle {
>  	int			family;
>  	struct mnl_socket	*nl;
> @@ -111,6 +133,9 @@ struct nft_handle {
>  	bool			cache_init;
>  	int			verbose;
>  
> +	struct nft_regs		regs[20];

Why 20? Ain't 16 enough?

> +	uint64_t		reg_genid;
> +
>  	/* meta data, for error reporting */
>  	struct {
>  		unsigned int	lineno;

Thanks, Phil
