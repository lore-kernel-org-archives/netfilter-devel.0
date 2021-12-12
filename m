Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC33C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Dec 2021 17:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhLLRMs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Dec 2021 12:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhLLRMr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Dec 2021 12:12:47 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E0AC061714
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Dec 2021 09:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J8GgoOA+rNi03c6IPTvmWQJCEcV6Lo7q6827eA5naeg=; b=VjsJFmzVDeylZe5X0Or4xoEtPM
        9dLlQRNHXVuf0kx4spMcxzO+z1odLpY5xB2pq871Rx8R5l0OP19/3qnkumUj0rDT9ZhfShRofMhUL
        p/2aUhjgGzvY1mQdm5qo/vDlpppNk0qh7fuTsyKwHzpziwebrAIzX39+8gNNYlGeFIVSxOXgrCmze
        cgfep55ihaZx278tNzdKUCk4/Pef/SLgj/6nbUknJkZawUWgjLEFNEYuzibQGqPtgvatkb7ZGnsOe
        X2TGhGrMJxaCA44emTquFArDTUhSvqinGybiAfF25DhTdGji6vIl7KeliJkhyVeHX7bUL5rhNh2Xp
        4KHuP4DA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mwSOw-005aYr-RZ; Sun, 12 Dec 2021 17:12:42 +0000
Date:   Sun, 12 Dec 2021 17:12:38 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2 1/7] src: add infrastructure to infer
 byteorder from keys
Message-ID: <YbYthi4tRg1pqUUP@azazel.net>
References: <20211124172242.11402-1-phil@nwl.cc>
 <20211124172242.11402-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wN1gbHCuKdplHgra"
Content-Disposition: inline
In-Reply-To: <20211124172242.11402-2-phil@nwl.cc>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--wN1gbHCuKdplHgra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-11-24, at 18:22:36 +0100, Phil Sutter wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> This patch adds a new .byteorder callback to expressions to allow infer
> the data byteorder that is placed in registers. Given that keys have a
> fixed datatype, this patch tracks register operations to obtain the data
> byteorder. This new infrastructure is internal and it is only used by
> the nftnl_rule_snprintf() function to make it portable regardless the
> endianess.
>
> A few examples after this patch running on x86_64:
>
> netdev
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ immediate reg 1 0x01020304 ]
>   [ payload write reg 1 => 4b @ network header + 12 csum_type 1 csum_off 10 csum_flags 0x1 ]
>
> root@salvia:/home/pablo/devel/scm/git-netfilter/libnftnl# nft --debug=netlink add rule netdev x z ip saddr 1.2.3.4
> netdev
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ payload load 4b @ network header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x01020304 ]
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Fix calls to changed nftnl_data_reg_snprintf().
> - Add more byteorder callbacks
> - expr/xfrm: Fix SPI endianness, was recently corrected in nftables
> - ct helper: Strings are always "big endian"
> - expr/cmp: Boundary comparisons are always Big Endian
> - expr/range: Ranges are always in network byte order
> ---
>  include/common.h     | 29 +++++++++++++++++++++++++
>  include/data_reg.h   |  4 +++-
>  include/expr.h       |  2 +-
>  include/expr_ops.h   |  2 ++
>  src/expr.c           | 51 ++++++++++++++++++++++++++++++++++++++++++++
>  src/expr/bitwise.c   | 30 +++++++++++++++++++-------
>  src/expr/byteorder.c | 21 ++++++++++++++++++
>  src/expr/cmp.c       | 21 +++++++++++++++++-
>  src/expr/ct.c        | 30 ++++++++++++++++++++++++++
>  src/expr/data_reg.c  | 18 +++++++++++-----
>  src/expr/dup.c       | 14 ++++++++++++
>  src/expr/exthdr.c    | 14 ++++++++++++
>  src/expr/fib.c       | 18 ++++++++++++++++
>  src/expr/fwd.c       | 14 ++++++++++++
>  src/expr/immediate.c | 17 ++++++++++++---
>  src/expr/masq.c      | 16 ++++++++++++++
>  src/expr/meta.c      | 28 ++++++++++++++++++++++++
>  src/expr/nat.c       | 22 +++++++++++++++++++
>  src/expr/numgen.c    | 12 +++++++++++
>  src/expr/osf.c       | 12 +++++++++++
>  src/expr/payload.c   | 14 ++++++++++++
>  src/expr/queue.c     | 12 +++++++++++
>  src/expr/range.c     | 11 ++++++++--
>  src/expr/redir.c     | 16 ++++++++++++++
>  src/expr/rt.c        | 19 +++++++++++++++++
>  src/expr/socket.c    | 12 +++++++++++
>  src/expr/tproxy.c    | 14 ++++++++++++
>  src/expr/tunnel.c    | 12 +++++++++++
>  src/expr/xfrm.c      | 18 ++++++++++++++++
>  src/rule.c           |  7 ++++++
>  src/set_elem.c       |  9 +++++---
>  31 files changed, 495 insertions(+), 24 deletions(-)
>
> diff --git a/include/common.h b/include/common.h
> index d05a81ad542c1..13d709b247f92 100644
> --- a/include/common.h
> +++ b/include/common.h
> @@ -18,4 +18,33 @@ enum nftnl_parse_input {
>  	NFTNL_PARSE_FILE,
>  };
>
> +enum nftnl_byteorder {
> +	NFTNL_BYTEORDER_UNKNOWN	= 0,
> +	NFTNL_BYTEORDER_HOST,
> +	NFTNL_BYTEORDER_NETWORK,
> +};
> +
> +#define NFTNL_CTX_BYTEORDER_MAX_EXPRS	16
> +
> +struct nftnl_byteorder_ctx {
> +	struct {
> +		const struct nftnl_expr	*expr;
> +		enum nftnl_byteorder	byteorder;
> +	} expr[NFT_REG32_15 + 1];
> +	struct {
> +		uint32_t		reg;
> +		struct nftnl_expr	*expr;
> +	} pending[NFTNL_CTX_BYTEORDER_MAX_EXPRS];
> +	uint32_t			num_pending;
> +};
> +
> +void nftnl_reg_byteorder_set(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
> +			     enum nftnl_byteorder byteorder);
> +enum nftnl_byteorder nftnl_reg_byteorder_get(struct nftnl_byteorder_ctx *ctx,
> +					     uint32_t reg);
> +void nftnl_reg_byteorder_unknown(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
> +				 struct nftnl_expr *expr);
> +void nftnl_reg_byteorder_resolve(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
> +				 enum nftnl_byteorder byteorder);
> +
>  #endif
> diff --git a/include/data_reg.h b/include/data_reg.h
> index 6d2dc66858bf8..3f24b6725e148 100644
> --- a/include/data_reg.h
> +++ b/include/data_reg.h
> @@ -5,6 +5,7 @@
>  #include <stdint.h>
>  #include <stdbool.h>
>  #include <unistd.h>
> +#include "common.h"
>
>  enum {
>  	DATA_NONE,
> @@ -31,7 +32,8 @@ union nftnl_data_reg {
>
>  int nftnl_data_reg_snprintf(char *buf, size_t size,
>  			    const union nftnl_data_reg *reg,
> -			    uint32_t flags, int reg_type);
> +			    uint32_t flags, int reg_type,
> +			    enum nftnl_byteorder byteorder);
>  struct nlattr;
>
>  int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
> diff --git a/include/expr.h b/include/expr.h
> index be45e954df5b6..50959724492e7 100644
> --- a/include/expr.h
> +++ b/include/expr.h
> @@ -6,6 +6,7 @@ struct expr_ops;
>  struct nftnl_expr {
>  	struct list_head	head;
>  	uint32_t		flags;
> +	uint32_t		byteorder;
>  	struct expr_ops		*ops;
>  	uint8_t			data[];
>  };
> @@ -15,5 +16,4 @@ struct nlmsghdr;
>  void nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr);
>  struct nftnl_expr *nftnl_expr_parse(struct nlattr *attr);
>
> -
>  #endif
> diff --git a/include/expr_ops.h b/include/expr_ops.h
> index 7a6aa23f9bd1d..161babdade596 100644
> --- a/include/expr_ops.h
> +++ b/include/expr_ops.h
> @@ -7,6 +7,7 @@
>  struct nlattr;
>  struct nlmsghdr;
>  struct nftnl_expr;
> +struct nftnl_print_ctx;
>
>  struct expr_ops {
>  	const char *name;
> @@ -18,6 +19,7 @@ struct expr_ops {
>  	const void *(*get)(const struct nftnl_expr *e, uint16_t type, uint32_t *data_len);
>  	int 	(*parse)(struct nftnl_expr *e, struct nlattr *attr);
>  	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_expr *e);
> +	void	(*byteorder)(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e);
>  	int	(*snprintf)(char *buf, size_t len, uint32_t flags, const struct nftnl_expr *e);
>  };
>
> diff --git a/src/expr.c b/src/expr.c
> index 277bbdeeb5d02..d958bab98e925 100644
> --- a/src/expr.c
> +++ b/src/expr.c
> @@ -301,3 +301,54 @@ int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type,
>  	return nftnl_fprintf(fp, expr, NFTNL_CMD_UNSPEC, type, flags,
>  			     nftnl_expr_do_snprintf);
>  }
> +
> +void nftnl_reg_byteorder_set(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
> +			     enum nftnl_byteorder byteorder)
> +{
> +       if (reg > NFT_REG32_15)
> +	       return;
> +
> +       ctx->expr[reg].byteorder = byteorder;
> +}
> +
> +enum nftnl_byteorder nftnl_reg_byteorder_get(struct nftnl_byteorder_ctx *ctx,
> +					     uint32_t reg)
> +{
> +       if (reg > NFT_REG32_15)
> +	       return NFTNL_BYTEORDER_UNKNOWN;
> +
> +       return ctx->expr[reg].byteorder;
> +}
> +
> +void nftnl_reg_byteorder_unknown(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
> +				 struct nftnl_expr *expr)
> +{
> +       int k;
> +
> +       if (reg > NFT_REG32_15)
> +	       return;
> +

This doesn't look right:

> +       k = ctx->num_pending++;
> +       if (k >= NFTNL_CTX_BYTEORDER_MAX_EXPRS)
> +	       return;

Shouldn't it be?

        if (ctx->num_pending >= NFTNL_CTX_BYTEORDER_MAX_EXPRS)
                return;
        k = ctx->num_pending++;

Otherwise ...

> +       ctx->pending[k].reg = reg;
> +       ctx->pending[k].expr = expr;
> +}
> +
> +void nftnl_reg_byteorder_resolve(struct nftnl_byteorder_ctx *ctx, uint32_t reg,
> +				 enum nftnl_byteorder byteorder)
> +{
> +       struct nftnl_expr *expr;
> +       int i;

... we can run off the end of `ctx->pending` here:

> +       for (i = 0; i < ctx->num_pending; i++) {
> +	       if (!ctx->pending[i].expr)
> +		       continue;
> +	       if (ctx->pending[i].reg == reg) {
> +		       expr = ctx->pending[i].expr;
> +		       expr->byteorder = byteorder;
> +		       ctx->pending[i].expr = NULL;
> +	       }
> +       }
> +}
> diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
> index d0c7827eacec9..a21dec01d286f 100644
> --- a/src/expr/bitwise.c
> +++ b/src/expr/bitwise.c
> @@ -209,9 +209,18 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return ret;
>  }
>
> +static void
> +nftnl_expr_bitwise_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
> +
> +	e->byteorder = nftnl_reg_byteorder_get(ctx, bitwise->sreg);
> +}
> +
>  static int
>  nftnl_expr_bitwise_snprintf_bool(char *buf, size_t remain,
> -				 const struct nftnl_expr_bitwise *bitwise)
> +				 const struct nftnl_expr_bitwise *bitwise,
> +				 enum nftnl_byteorder byteorder)
>  {
>  	int offset = 0, ret;
>
> @@ -220,14 +229,14 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t remain,
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->mask,
> -				      0, DATA_VALUE);
> +				      0, DATA_VALUE, byteorder);
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = snprintf(buf + offset, remain, ") ^ ");
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
> -				      0, DATA_VALUE);
> +				      0, DATA_VALUE, byteorder);
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	return offset;
> @@ -235,7 +244,8 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t remain,
>
>  static int
>  nftnl_expr_bitwise_snprintf_shift(char *buf, size_t remain, const char *op,
> -				  const struct nftnl_expr_bitwise *bitwise)
> +				  const struct nftnl_expr_bitwise *bitwise,
> +				  enum nftnl_byteorder byteorder)
>  {	int offset = 0, ret;
>
>  	ret = snprintf(buf, remain, "reg %u = ( reg %u %s ",
> @@ -243,7 +253,7 @@ nftnl_expr_bitwise_snprintf_shift(char *buf, size_t remain, const char *op,
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->data,
> -				      0, DATA_VALUE);
> +				      0, DATA_VALUE, byteorder);
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = snprintf(buf + offset, remain, ") ");
> @@ -261,13 +271,16 @@ nftnl_expr_bitwise_snprintf(char *buf, size_t size,
>
>  	switch (bitwise->op) {
>  	case NFT_BITWISE_BOOL:
> -		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
> +		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise,
> +						       e->byteorder);
>  		break;
>  	case NFT_BITWISE_LSHIFT:
> -		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
> +		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<",
> +							bitwise, e->byteorder);
>  		break;
>  	case NFT_BITWISE_RSHIFT:
> -		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>", bitwise);
> +		err = nftnl_expr_bitwise_snprintf_shift(buf, size, ">>",
> +							bitwise, e->byteorder);
>  		break;
>  	}
>
> @@ -282,5 +295,6 @@ struct expr_ops expr_ops_bitwise = {
>  	.get		= nftnl_expr_bitwise_get,
>  	.parse		= nftnl_expr_bitwise_parse,
>  	.build		= nftnl_expr_bitwise_build,
> +	.byteorder	= nftnl_expr_bitwise_byteorder,
>  	.snprintf	= nftnl_expr_bitwise_snprintf,
>  };
> diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
> index d299745fc57b4..ae67ee6ef2b35 100644
> --- a/src/expr/byteorder.c
> +++ b/src/expr/byteorder.c
> @@ -197,6 +197,26 @@ static inline int nftnl_str2ntoh(const char *op)
>  	}
>  }
>
> +static void nftnl_expr_byteorder_byteorder(struct nftnl_byteorder_ctx *ctx,
> +					   struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_byteorder *byteorder = nftnl_expr_data(e);
> +	enum nftnl_byteorder bo;
> +
> +	switch (byteorder->op) {
> +	case NFT_BYTEORDER_NTOH:
> +		bo = NFTNL_BYTEORDER_HOST;
> +		break;
> +	case NFT_BYTEORDER_HTON:
> +		bo = NFTNL_BYTEORDER_NETWORK;
> +		break;
> +	default:
> +		bo = NFTNL_BYTEORDER_UNKNOWN;
> +		break;
> +	}
> +	nftnl_reg_byteorder_set(ctx, byteorder->dreg, bo);
> +}
> +
>  static int
>  nftnl_expr_byteorder_snprintf(char *buf, size_t remain,
>  			      uint32_t flags, const struct nftnl_expr *e)
> @@ -220,5 +240,6 @@ struct expr_ops expr_ops_byteorder = {
>  	.get		= nftnl_expr_byteorder_get,
>  	.parse		= nftnl_expr_byteorder_parse,
>  	.build		= nftnl_expr_byteorder_build,
> +	.byteorder	= nftnl_expr_byteorder_byteorder,
>  	.snprintf	= nftnl_expr_byteorder_snprintf,
>  };
> diff --git a/src/expr/cmp.c b/src/expr/cmp.c
> index 6030693f15d86..846a112a03231 100644
> --- a/src/expr/cmp.c
> +++ b/src/expr/cmp.c
> @@ -176,6 +176,24 @@ static inline int nftnl_str2cmp(const char *op)
>  	}
>  }
>
> +static void
> +nftnl_expr_cmp_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_cmp *cmp = nftnl_expr_data(e);
> +
> +	switch (cmp->op) {
> +	case NFT_CMP_LT:
> +	case NFT_CMP_LTE:
> +	case NFT_CMP_GT:
> +	case NFT_CMP_GTE:
> +		e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +		break;
> +	default:
> +		e->byteorder = nftnl_reg_byteorder_get(ctx, cmp->sreg);
> +		break;
> +	}
> +}
> +
>  static int
>  nftnl_expr_cmp_snprintf(char *buf, size_t remain,
>  			uint32_t flags, const struct nftnl_expr *e)
> @@ -188,7 +206,7 @@ nftnl_expr_cmp_snprintf(char *buf, size_t remain,
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = nftnl_data_reg_snprintf(buf + offset, remain, &cmp->data,
> -				      0, DATA_VALUE);
> +				      0, DATA_VALUE, e->byteorder);
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	return offset;
> @@ -202,5 +220,6 @@ struct expr_ops expr_ops_cmp = {
>  	.get		= nftnl_expr_cmp_get,
>  	.parse		= nftnl_expr_cmp_parse,
>  	.build		= nftnl_expr_cmp_build,
> +	.byteorder	= nftnl_expr_cmp_byteorder,
>  	.snprintf	= nftnl_expr_cmp_snprintf,
>  };
> diff --git a/src/expr/ct.c b/src/expr/ct.c
> index d5dfc81cfe0d1..fe4fc43688eb5 100644
> --- a/src/expr/ct.c
> +++ b/src/expr/ct.c
> @@ -222,6 +222,35 @@ static inline int str2ctdir(const char *str, uint8_t *ctdir)
>  	return -1;
>  }
>
> +static void
> +nftnl_expr_ct_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_ct *ct = nftnl_expr_data(e);
> +
> +	switch (ct->key) {
> +	case NFT_CT_HELPER:
> +	case NFT_CT_SRC:
> +	case NFT_CT_DST:
> +	case NFT_CT_PROTOCOL:
> +	case NFT_CT_PROTO_SRC:
> +	case NFT_CT_PROTO_DST:
> +	case NFT_CT_SRC_IP:
> +	case NFT_CT_DST_IP:
> +	case NFT_CT_SRC_IP6:
> +	case NFT_CT_DST_IP6:
> +	case NFT_CT_ID:
> +		e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +		break;
> +	default:
> +		e->byteorder = NFTNL_BYTEORDER_HOST;
> +	}
> +
> +	if (e->flags & (1 << NFTNL_EXPR_CT_SREG))
> +		nftnl_reg_byteorder_resolve(ctx, ct->sreg, e->byteorder);
> +	if (e->flags & (1 << NFTNL_EXPR_CT_DREG))
> +		nftnl_reg_byteorder_set(ctx, ct->dreg, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_ct_snprintf(char *buf, size_t remain,
>  		       uint32_t flags, const struct nftnl_expr *e)
> @@ -258,5 +287,6 @@ struct expr_ops expr_ops_ct = {
>  	.get		= nftnl_expr_ct_get,
>  	.parse		= nftnl_expr_ct_parse,
>  	.build		= nftnl_expr_ct_build,
> +	.byteorder	= nftnl_expr_ct_byteorder,
>  	.snprintf	= nftnl_expr_ct_snprintf,
>  };
> diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
> index 2633a775c90cc..789958ea66c0d 100644
> --- a/src/expr/data_reg.c
> +++ b/src/expr/data_reg.c
> @@ -27,16 +27,22 @@
>  static int
>  nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
>  				      const union nftnl_data_reg *reg,
> -				      uint32_t flags)
> +				      uint32_t flags,
> +				      enum nftnl_byteorder byteorder)
>  {
>  	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x";
>  	int offset = 0, ret, i;
> +	uint32_t value;
>
>
>
>  	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
> -		ret = snprintf(buf + offset, remain,
> -			       "%s%.8x ", pfx, reg->val[i]);
> +		if (byteorder == NFTNL_BYTEORDER_NETWORK)
> +			value = ntohl(reg->val[i]);
> +		else
> +			value = reg->val[i];
> +
> +		ret = snprintf(buf + offset, remain, "%s%.8x ", pfx, value);
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  	}
>
> @@ -63,12 +69,14 @@ nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
>
>  int nftnl_data_reg_snprintf(char *buf, size_t size,
>  			    const union nftnl_data_reg *reg,
> -			    uint32_t flags, int reg_type)
> +			    uint32_t flags, int reg_type,
> +			    enum nftnl_byteorder byteorder)
>  {
>  	switch(reg_type) {
>  	case DATA_VALUE:
>  		return nftnl_data_reg_value_snprintf_default(buf, size,
> -							     reg, flags);
> +							     reg, flags,
> +							     byteorder);
>  	case DATA_VERDICT:
>  	case DATA_CHAIN:
>  		return nftnl_data_reg_verdict_snprintf_def(buf, size,
> diff --git a/src/expr/dup.c b/src/expr/dup.c
> index f041b551a7e78..58c3fe6989e91 100644
> --- a/src/expr/dup.c
> +++ b/src/expr/dup.c
> @@ -111,6 +111,19 @@ static int nftnl_expr_dup_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return ret;
>  }
>
> +static void
> +nftnl_expr_dup_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_dup *dup = nftnl_expr_data(e);
> +
> +	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_ADDR))
> +		nftnl_reg_byteorder_resolve(ctx, dup->sreg_addr,
> +					    NFTNL_BYTEORDER_NETWORK);
> +	if (e->flags & (1 << NFTNL_EXPR_DUP_SREG_DEV))
> +		nftnl_reg_byteorder_resolve(ctx, dup->sreg_dev,
> +					    NFTNL_BYTEORDER_HOST);
> +}
> +
>  static int nftnl_expr_dup_snprintf(char *buf, size_t remain,
>  				   uint32_t flags, const struct nftnl_expr *e)
>  {
> @@ -138,5 +151,6 @@ struct expr_ops expr_ops_dup = {
>  	.get		= nftnl_expr_dup_get,
>  	.parse		= nftnl_expr_dup_parse,
>  	.build		= nftnl_expr_dup_build,
> +	.byteorder	= nftnl_expr_dup_byteorder,
>  	.snprintf	= nftnl_expr_dup_snprintf,
>  };
> diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
> index 1b813b1e47c4d..280fe73f48041 100644
> --- a/src/expr/exthdr.c
> +++ b/src/expr/exthdr.c
> @@ -235,6 +235,19 @@ static inline int str2exthdr_type(const char *str)
>  	return -1;
>  }
>
> +static void
> +nftnl_expr_exthdr_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_exthdr *exthdr = nftnl_expr_data(e);
> +
> +	e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +
> +	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_DREG))

Spaces instead of tabs here:

> +                nftnl_reg_byteorder_set(ctx, exthdr->dreg, e->byteorder);
> +	if (e->flags & (1 << NFTNL_EXPR_EXTHDR_SREG))
> +		nftnl_reg_byteorder_resolve(ctx, exthdr->sreg, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_exthdr_snprintf(char *buf, size_t len,
>  			   uint32_t flags, const struct nftnl_expr *e)
> @@ -262,5 +275,6 @@ struct expr_ops expr_ops_exthdr = {
>  	.get		= nftnl_expr_exthdr_get,
>  	.parse		= nftnl_expr_exthdr_parse,
>  	.build		= nftnl_expr_exthdr_build,
> +	.byteorder	= nftnl_expr_exthdr_byteorder,
>  	.snprintf	= nftnl_expr_exthdr_snprintf,
>  };
> diff --git a/src/expr/fib.c b/src/expr/fib.c
> index aaff52acabdbd..75194bff95f41 100644
> --- a/src/expr/fib.c
> +++ b/src/expr/fib.c
> @@ -128,6 +128,23 @@ nftnl_expr_fib_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return ret;
>  }
>
> +static void
> +nftnl_expr_fib_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_fib *fib = nftnl_expr_data(e);
> +
> +	switch (fib->result) {
> +	case NFT_FIB_RESULT_OIFNAME:
> +		e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +		break;
> +	default:
> +		e->byteorder = NFTNL_BYTEORDER_HOST;
> +	}
> +
> +	if (e->flags & (1 << NFTNL_EXPR_FIB_DREG))
> +                nftnl_reg_byteorder_set(ctx, fib->dreg, e->byteorder);
> +}
> +
>  static const char *fib_type[NFT_FIB_RESULT_MAX + 1] = {
>  	[NFT_FIB_RESULT_OIF] = "oif",
>  	[NFT_FIB_RESULT_OIFNAME] = "oifname",
> @@ -198,5 +215,6 @@ struct expr_ops expr_ops_fib = {
>  	.get		= nftnl_expr_fib_get,
>  	.parse		= nftnl_expr_fib_parse,
>  	.build		= nftnl_expr_fib_build,
> +	.byteorder	= nftnl_expr_fib_byteorder,
>  	.snprintf	= nftnl_expr_fib_snprintf,
>  };
> diff --git a/src/expr/fwd.c b/src/expr/fwd.c
> index 82e5a418bfae5..6875abfa80d19 100644
> --- a/src/expr/fwd.c
> +++ b/src/expr/fwd.c
> @@ -125,6 +125,19 @@ static int nftnl_expr_fwd_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return ret;
>  }
>
> +static void
> +nftnl_expr_fwd_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_fwd *fwd = nftnl_expr_data(e);
> +
> +	if (e->flags & (1 << NFTNL_EXPR_FWD_SREG_DEV))
> +		nftnl_reg_byteorder_resolve(ctx, fwd->sreg_dev,
> +					    NFTNL_BYTEORDER_HOST);
> +	if (e->flags & (1 << NFTNL_EXPR_FWD_SREG_ADDR))
> +		nftnl_reg_byteorder_resolve(ctx, fwd->sreg_addr,
> +					    NFTNL_BYTEORDER_NETWORK);
> +}
> +
>  static int nftnl_expr_fwd_snprintf(char *buf, size_t remain,
>  				   uint32_t flags, const struct nftnl_expr *e)
>  {
> @@ -158,5 +171,6 @@ struct expr_ops expr_ops_fwd = {
>  	.get		= nftnl_expr_fwd_get,
>  	.parse		= nftnl_expr_fwd_parse,
>  	.build		= nftnl_expr_fwd_build,
> +	.byteorder	= nftnl_expr_fwd_byteorder,
>  	.snprintf	= nftnl_expr_fwd_snprintf,
>  };
> diff --git a/src/expr/immediate.c b/src/expr/immediate.c
> index 94b043c0fc8ab..fb291c7606bab 100644
> --- a/src/expr/immediate.c
> +++ b/src/expr/immediate.c
> @@ -183,6 +183,14 @@ nftnl_expr_immediate_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return ret;
>  }
>
> +static void
> +nftnl_expr_immediate_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_immediate *imm = nftnl_expr_data(e);
> +
> +	nftnl_reg_byteorder_unknown(ctx, imm->dreg, e);
> +}
> +
>  static int
>  nftnl_expr_immediate_snprintf(char *buf, size_t remain,
>  			      uint32_t flags, const struct nftnl_expr *e)
> @@ -195,17 +203,19 @@ nftnl_expr_immediate_snprintf(char *buf, size_t remain,
>
>  	if (e->flags & (1 << NFTNL_EXPR_IMM_DATA)) {
>  		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
> -					      flags, DATA_VALUE);
> +					      flags, DATA_VALUE, e->byteorder);
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	} else if (e->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
>  		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
> -					      flags, DATA_VERDICT);
> +					      flags, DATA_VERDICT,
> +					      NFTNL_BYTEORDER_UNKNOWN);
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	} else if (e->flags & (1 << NFTNL_EXPR_IMM_CHAIN)) {
>  		ret = nftnl_data_reg_snprintf(buf + offset, remain, &imm->data,
> -					      flags, DATA_CHAIN);
> +					      flags, DATA_CHAIN,
> +					      NFTNL_BYTEORDER_UNKNOWN);
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  	}
>
> @@ -229,5 +239,6 @@ struct expr_ops expr_ops_immediate = {
>  	.get		= nftnl_expr_immediate_get,
>  	.parse		= nftnl_expr_immediate_parse,
>  	.build		= nftnl_expr_immediate_build,
> +	.byteorder	= nftnl_expr_immediate_byteorder,
>  	.snprintf	= nftnl_expr_immediate_snprintf,
>  };
> diff --git a/src/expr/masq.c b/src/expr/masq.c
> index 684708c758390..a964e3ae1a938 100644
> --- a/src/expr/masq.c
> +++ b/src/expr/masq.c
> @@ -131,6 +131,21 @@ nftnl_expr_masq_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return 0;
>  }
>
> +static void
> +nftnl_expr_masq_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_masq *masq = nftnl_expr_data(e);
> +
> +	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MIN))
> +		nftnl_reg_byteorder_resolve(ctx, masq->sreg_proto_min,
> +					    NFTNL_BYTEORDER_NETWORK);
> +	if (e->flags & (1 << NFTNL_EXPR_MASQ_REG_PROTO_MAX))
> +		nftnl_reg_byteorder_resolve(ctx, masq->sreg_proto_max,
> +					    NFTNL_BYTEORDER_NETWORK);
> +
> +	e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +}
> +
>  static int nftnl_expr_masq_snprintf(char *buf, size_t remain,
>  				    uint32_t flags, const struct nftnl_expr *e)
>  {
> @@ -163,5 +178,6 @@ struct expr_ops expr_ops_masq = {
>  	.get		= nftnl_expr_masq_get,
>  	.parse		= nftnl_expr_masq_parse,
>  	.build		= nftnl_expr_masq_build,
> +	.byteorder	= nftnl_expr_masq_byteorder,
>  	.snprintf	= nftnl_expr_masq_snprintf,
>  };
> diff --git a/src/expr/meta.c b/src/expr/meta.c
> index 34fbb9bb63c03..deb14e5cb054d 100644
> --- a/src/expr/meta.c
> +++ b/src/expr/meta.c
> @@ -191,6 +191,33 @@ static inline int str2meta_key(const char *str)
>  	return -1;
>  }
>
> +static void nftnl_expr_meta_byteorder(struct nftnl_byteorder_ctx *ctx,
> +				      struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_meta *meta = nftnl_expr_data(e);
> +
> +
> +	switch (meta->key) {
> +	case NFT_META_PROTOCOL:
> +	case NFT_META_IIFNAME:
> +	case NFT_META_OIFNAME:
> +	case NFT_META_BRI_IIFNAME:
> +	case NFT_META_BRI_OIFNAME:
> +	case NFT_META_PRANDOM:
> +	case NFT_META_BRI_IIFVPROTO:
> +	case NFT_META_SDIFNAME:
> +		e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +		break;
> +	default:
> +		e->byteorder = NFTNL_BYTEORDER_HOST;
> +	}
> +
> +	if (e->flags & (1 << NFTNL_EXPR_META_SREG))
> +		nftnl_reg_byteorder_resolve(ctx, meta->sreg, e->byteorder);
> +	if (e->flags & (1 << NFTNL_EXPR_META_DREG))
> +		nftnl_reg_byteorder_set(ctx, meta->dreg, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_meta_snprintf(char *buf, size_t len,
>  			 uint32_t flags, const struct nftnl_expr *e)
> @@ -216,5 +243,6 @@ struct expr_ops expr_ops_meta = {
>  	.get		= nftnl_expr_meta_get,
>  	.parse		= nftnl_expr_meta_parse,
>  	.build		= nftnl_expr_meta_build,
> +	.byteorder	= nftnl_expr_meta_byteorder,
>  	.snprintf	= nftnl_expr_meta_snprintf,
>  };
> diff --git a/src/expr/nat.c b/src/expr/nat.c
> index 0a9cdd7f65f8f..785ceb20a92bf 100644
> --- a/src/expr/nat.c
> +++ b/src/expr/nat.c
> @@ -220,6 +220,27 @@ static inline int nftnl_str2nat(const char *nat)
>  	}
>  }
>
> +static void
> +nftnl_expr_nat_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_nat *nat = nftnl_expr_data(e);
> +
> +	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_ADDR_MIN))
> +		nftnl_reg_byteorder_resolve(ctx, nat->sreg_addr_min,
> +					    NFTNL_BYTEORDER_NETWORK);
> +	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_ADDR_MAX))
> +		nftnl_reg_byteorder_resolve(ctx, nat->sreg_addr_max,
> +					    NFTNL_BYTEORDER_NETWORK);
> +	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_PROTO_MIN))
> +		nftnl_reg_byteorder_resolve(ctx, nat->sreg_proto_min,
> +					    NFTNL_BYTEORDER_NETWORK);
> +	if (e->flags & (1 << NFTNL_EXPR_NAT_REG_PROTO_MAX))
> +		nftnl_reg_byteorder_resolve(ctx, nat->sreg_proto_max,
> +					    NFTNL_BYTEORDER_NETWORK);
> +
> +	e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +}
> +
>  static int
>  nftnl_expr_nat_snprintf(char *buf, size_t remain,
>  			uint32_t flags, const struct nftnl_expr *e)
> @@ -274,5 +295,6 @@ struct expr_ops expr_ops_nat = {
>  	.get		= nftnl_expr_nat_get,
>  	.parse		= nftnl_expr_nat_parse,
>  	.build		= nftnl_expr_nat_build,
> +	.byteorder	= nftnl_expr_nat_byteorder,
>  	.snprintf	= nftnl_expr_nat_snprintf,
>  };
> diff --git a/src/expr/numgen.c b/src/expr/numgen.c
> index 159dfeca3618b..dfbeeaf1b172a 100644
> --- a/src/expr/numgen.c
> +++ b/src/expr/numgen.c
> @@ -142,6 +142,17 @@ nftnl_expr_ng_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return ret;
>  }
>
> +static void
> +nftnl_expr_ng_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_ng *ng = nftnl_expr_data(e);
> +
> +	e->byteorder = NFTNL_BYTEORDER_HOST;
> +
> +	if (e->flags & (1 << NFTNL_EXPR_NG_DREG))
> +		nftnl_reg_byteorder_set(ctx, ng->dreg, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_ng_snprintf(char *buf, size_t remain,
>  		       uint32_t flags, const struct nftnl_expr *e)
> @@ -180,5 +191,6 @@ struct expr_ops expr_ops_ng = {
>  	.get		= nftnl_expr_ng_get,
>  	.parse		= nftnl_expr_ng_parse,
>  	.build		= nftnl_expr_ng_build,
> +	.byteorder	= nftnl_expr_ng_byteorder,
>  	.snprintf	= nftnl_expr_ng_snprintf,
>  };
> diff --git a/src/expr/osf.c b/src/expr/osf.c
> index 215a681a97aae..b2e4294877c05 100644
> --- a/src/expr/osf.c
> +++ b/src/expr/osf.c
> @@ -124,6 +124,17 @@ nftnl_expr_osf_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return 0;
>  }
>
> +static void
> +nftnl_expr_osf_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_osf *osf = nftnl_expr_data(e);
> +
> +	e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +
> +	if (e->flags & (1 << NFTNL_EXPR_OSF_DREG))
> +                nftnl_reg_byteorder_set(ctx, osf->dreg, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_osf_snprintf(char *buf, size_t len,
>  			uint32_t flags, const struct nftnl_expr *e)
> @@ -147,5 +158,6 @@ struct expr_ops expr_ops_osf = {
>  	.get		= nftnl_expr_osf_get,
>  	.parse		= nftnl_expr_osf_parse,
>  	.build		= nftnl_expr_osf_build,
> +	.byteorder	= nftnl_expr_osf_byteorder,
>  	.snprintf	= nftnl_expr_osf_snprintf,
>  };
> diff --git a/src/expr/payload.c b/src/expr/payload.c
> index 82747ec8994f7..84764e837a965 100644
> --- a/src/expr/payload.c
> +++ b/src/expr/payload.c
> @@ -232,6 +232,19 @@ static inline int nftnl_str2base(const char *base)
>  	}
>  }
>
> +static void
> +nftnl_expr_payload_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
> +
> +	e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +
> +	if (payload->sreg)
> +		nftnl_reg_byteorder_resolve(ctx, payload->sreg, e->byteorder);
> +	else

Spaces instead of tabs here:

> +                nftnl_reg_byteorder_set(ctx, payload->dreg, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_payload_snprintf(char *buf, size_t len,
>  			    uint32_t flags, const struct nftnl_expr *e)
> @@ -259,5 +272,6 @@ struct expr_ops expr_ops_payload = {
>  	.get		= nftnl_expr_payload_get,
>  	.parse		= nftnl_expr_payload_parse,
>  	.build		= nftnl_expr_payload_build,
> +	.byteorder	= nftnl_expr_payload_byteorder,
>  	.snprintf	= nftnl_expr_payload_snprintf,
>  };
> diff --git a/src/expr/queue.c b/src/expr/queue.c
> index 8f70977f7de85..1a65c8ad6484a 100644
> --- a/src/expr/queue.c
> +++ b/src/expr/queue.c
> @@ -143,6 +143,17 @@ nftnl_expr_queue_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return 0;
>  }
>
> +static void
> +nftnl_expr_queue_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_queue *queue = nftnl_expr_data(e);
> +
> +	e->byteorder = NFTNL_BYTEORDER_HOST;
> +
> +	if (e->flags & (1 << NFTNL_EXPR_QUEUE_SREG_QNUM))
> +                nftnl_reg_byteorder_resolve(ctx, queue->sreg_qnum, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_queue_snprintf(char *buf, size_t remain,
>  			  uint32_t flags, const struct nftnl_expr *e)
> @@ -193,5 +204,6 @@ struct expr_ops expr_ops_queue = {
>  	.get		= nftnl_expr_queue_get,
>  	.parse		= nftnl_expr_queue_parse,
>  	.build		= nftnl_expr_queue_build,
> +	.byteorder	= nftnl_expr_queue_byteorder,
>  	.snprintf	= nftnl_expr_queue_snprintf,
>  };
> diff --git a/src/expr/range.c b/src/expr/range.c
> index f76843a8afd0c..ab4e2e70d8d01 100644
> --- a/src/expr/range.c
> +++ b/src/expr/range.c
> @@ -184,6 +184,12 @@ static inline int nftnl_str2range(const char *op)
>  	}
>  }
>
> +static void nftnl_expr_range_byteorder(struct nftnl_byteorder_ctx *ctx,
> +				       struct nftnl_expr *e)
> +{
> +	e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +}
> +
>  static int nftnl_expr_range_snprintf(char *buf, size_t remain,
>  				     uint32_t flags, const struct nftnl_expr *e)
>  {
> @@ -195,11 +201,11 @@ static int nftnl_expr_range_snprintf(char *buf, size_t remain,
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_from,
> -				      0, DATA_VALUE);
> +				      0, DATA_VALUE, e->byteorder);
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_to,
> -				      0, DATA_VALUE);
> +				      0, DATA_VALUE, e->byteorder);
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	return offset;
> @@ -213,5 +219,6 @@ struct expr_ops expr_ops_range = {
>  	.get		= nftnl_expr_range_get,
>  	.parse		= nftnl_expr_range_parse,
>  	.build		= nftnl_expr_range_build,
> +	.byteorder	= nftnl_expr_range_byteorder,
>  	.snprintf	= nftnl_expr_range_snprintf,
>  };
> diff --git a/src/expr/redir.c b/src/expr/redir.c
> index 4f56cb4302b30..3c1ebc13909e5 100644
> --- a/src/expr/redir.c
> +++ b/src/expr/redir.c
> @@ -131,6 +131,21 @@ nftnl_expr_redir_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return 0;
>  }
>
> +static void
> +nftnl_expr_redir_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_redir *redir = nftnl_expr_data(e);
> +
> +	if (e->flags & (1 << NFTNL_EXPR_REDIR_REG_PROTO_MIN))
> +		nftnl_reg_byteorder_resolve(ctx, redir->sreg_proto_min,
> +					    NFTNL_BYTEORDER_NETWORK);
> +	if (e->flags & (1 << NFTNL_EXPR_REDIR_REG_PROTO_MAX))
> +		nftnl_reg_byteorder_resolve(ctx, redir->sreg_proto_max,
> +					    NFTNL_BYTEORDER_NETWORK);
> +
> +	e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +}
> +
>  static int
>  nftnl_expr_redir_snprintf(char *buf, size_t remain,
>  			  uint32_t flags, const struct nftnl_expr *e)
> @@ -167,5 +182,6 @@ struct expr_ops expr_ops_redir = {
>  	.get		= nftnl_expr_redir_get,
>  	.parse		= nftnl_expr_redir_parse,
>  	.build		= nftnl_expr_redir_build,
> +	.byteorder	= nftnl_expr_redir_byteorder,
>  	.snprintf	= nftnl_expr_redir_snprintf,
>  };
> diff --git a/src/expr/rt.c b/src/expr/rt.c
> index 1ad9b2ad4043f..bd8b2a91948ee 100644
> --- a/src/expr/rt.c
> +++ b/src/expr/rt.c
> @@ -112,6 +112,24 @@ nftnl_expr_rt_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return 0;
>  }
>
> +static void nftnl_expr_rt_byteorder(struct nftnl_byteorder_ctx *ctx,
> +				    struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_rt *rt = nftnl_expr_data(e);
> +
> +	switch (rt->key) {
> +	case NFT_RT_NEXTHOP4:
> +	case NFT_RT_NEXTHOP6:
> +		e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +		break;
> +	default:
> +		e->byteorder = NFTNL_BYTEORDER_HOST;
> +	}
> +
> +	if (e->flags & (1 << NFTNL_EXPR_RT_DREG))
> +		nftnl_reg_byteorder_set(ctx, rt->dreg, e->byteorder);
> +}
> +
>  static const char *rt_key2str_array[NFT_RT_MAX + 1] = {
>  	[NFT_RT_CLASSID]	= "classid",
>  	[NFT_RT_NEXTHOP4]	= "nexthop4",
> @@ -162,5 +180,6 @@ struct expr_ops expr_ops_rt = {
>  	.get		= nftnl_expr_rt_get,
>  	.parse		= nftnl_expr_rt_parse,
>  	.build		= nftnl_expr_rt_build,
> +	.byteorder	= nftnl_expr_rt_byteorder,
>  	.snprintf	= nftnl_expr_rt_snprintf,
>  };
> diff --git a/src/expr/socket.c b/src/expr/socket.c
> index 02d86f8ac57c0..dae9ea22bd24f 100644
> --- a/src/expr/socket.c
> +++ b/src/expr/socket.c
> @@ -126,6 +126,17 @@ nftnl_expr_socket_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return 0;
>  }
>
> +static void
> +nftnl_expr_socket_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_socket *socket = nftnl_expr_data(e);
> +
> +	e->byteorder = NFTNL_BYTEORDER_HOST;
> +
> +	if (e->flags & (1 << NFTNL_EXPR_SOCKET_DREG))
> +                nftnl_reg_byteorder_set(ctx, socket->dreg, e->byteorder);
> +}
> +
>  static const char *socket_key2str_array[NFT_SOCKET_MAX + 1] = {
>  	[NFT_SOCKET_TRANSPARENT] = "transparent",
>  	[NFT_SOCKET_MARK] = "mark",
> @@ -165,5 +176,6 @@ struct expr_ops expr_ops_socket = {
>  	.get		= nftnl_expr_socket_get,
>  	.parse		= nftnl_expr_socket_parse,
>  	.build		= nftnl_expr_socket_build,
> +	.byteorder	= nftnl_expr_socket_byteorder,
>  	.snprintf	= nftnl_expr_socket_snprintf,
>  };
> diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
> index d3ee8f89b6db3..ef3e20569c1cf 100644
> --- a/src/expr/tproxy.c
> +++ b/src/expr/tproxy.c
> @@ -134,6 +134,19 @@ nftnl_expr_tproxy_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
>  				 htonl(tproxy->sreg_port));
>  }
>
> +static void nftnl_expr_tproxy_byteorder(struct nftnl_byteorder_ctx *ctx,
> +				        struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_tproxy *t = nftnl_expr_data(e);
> +
> +	e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +
> +	if (e->flags & (1 << NFTNL_EXPR_TPROXY_REG_ADDR))
> +		nftnl_reg_byteorder_resolve(ctx, t->sreg_addr, e->byteorder);
> +	if (e->flags & (1 << NFTNL_EXPR_TPROXY_REG_PORT))
> +		nftnl_reg_byteorder_resolve(ctx, t->sreg_port, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_tproxy_snprintf(char *buf, size_t remain,
>  			uint32_t flags, const struct nftnl_expr *e)
> @@ -170,5 +183,6 @@ struct expr_ops expr_ops_tproxy = {
>  	.get		= nftnl_expr_tproxy_get,
>  	.parse		= nftnl_expr_tproxy_parse,
>  	.build		= nftnl_expr_tproxy_build,
> +	.byteorder	= nftnl_expr_tproxy_byteorder,
>  	.snprintf	= nftnl_expr_tproxy_snprintf,
>  };
> diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
> index 1460fd26b0fbc..94a6c9bb4add2 100644
> --- a/src/expr/tunnel.c
> +++ b/src/expr/tunnel.c
> @@ -111,6 +111,17 @@ nftnl_expr_tunnel_parse(struct nftnl_expr *e, struct nlattr *attr)
>  	return 0;
>  }
>
> +static void
> +nftnl_expr_tunnel_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_tunnel *tunnel = nftnl_expr_data(e);
> +
> +	e->byteorder = NFTNL_BYTEORDER_HOST;
> +
> +	if (e->flags & (1 << NFTNL_EXPR_TUNNEL_DREG))
> +                nftnl_reg_byteorder_set(ctx, tunnel->dreg, e->byteorder);
> +}
> +
>  static const char *tunnel_key2str_array[NFT_TUNNEL_MAX + 1] = {
>  	[NFT_TUNNEL_PATH]	= "path",
>  	[NFT_TUNNEL_ID]		= "id",
> @@ -145,5 +156,6 @@ struct expr_ops expr_ops_tunnel = {
>  	.get		= nftnl_expr_tunnel_get,
>  	.parse		= nftnl_expr_tunnel_parse,
>  	.build		= nftnl_expr_tunnel_build,
> +	.byteorder	= nftnl_expr_tunnel_byteorder,
>  	.snprintf	= nftnl_expr_tunnel_snprintf,
>  };
> diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
> index c81d14d638dcd..3134b076f042e 100644
> --- a/src/expr/xfrm.c
> +++ b/src/expr/xfrm.c
> @@ -171,6 +171,23 @@ static const char *xfrmdir2str(uint8_t dir)
>  	return xfrmdir2str_array[dir];
>  }
>
> +static void
> +nftnl_expr_xfrm_byteorder(struct nftnl_byteorder_ctx *ctx, struct nftnl_expr *e)
> +{
> +	struct nftnl_expr_xfrm *x = nftnl_expr_data(e);
> +
> +	switch (x->key) {
> +	case NFT_XFRM_KEY_REQID:
> +		e->byteorder = NFTNL_BYTEORDER_HOST;
> +		break;
> +	default:
> +		e->byteorder = NFTNL_BYTEORDER_NETWORK;
> +	}
> +
> +	if (e->flags & (1 << NFTNL_EXPR_XFRM_DREG))
> +                nftnl_reg_byteorder_set(ctx, x->dreg, e->byteorder);
> +}
> +
>  static int
>  nftnl_expr_xfrm_snprintf(char *buf, size_t remain,
>  			 uint32_t flags, const struct nftnl_expr *e)
> @@ -196,5 +213,6 @@ struct expr_ops expr_ops_xfrm = {
>  	.get		= nftnl_expr_xfrm_get,
>  	.parse		= nftnl_expr_xfrm_parse,
>  	.build		= nftnl_expr_xfrm_build,
> +	.byteorder	= nftnl_expr_xfrm_byteorder,
>  	.snprintf	= nftnl_expr_xfrm_snprintf,
>  };
> diff --git a/src/rule.c b/src/rule.c
> index 0bb1c2a0583c1..9f1caa6feb57e 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -549,6 +549,7 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
>  				       const struct nftnl_rule *r,
>  				       uint32_t type, uint32_t flags)
>  {
> +	struct nftnl_byteorder_ctx ctx = {};
>  	struct nftnl_expr *expr;
>  	int ret, offset = 0, i;
>  	const char *sep = "";
> @@ -603,6 +604,12 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
>  	ret = snprintf(buf + offset, remain, "\n");
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
> +	list_for_each_entry(expr, &r->expr_list, head) {
> +		if (!expr->ops->byteorder)
> +			continue;
> +		expr->ops->byteorder(&ctx, expr);
> +	}
> +
>  	list_for_each_entry(expr, &r->expr_list, head) {
>  		ret = snprintf(buf + offset, remain, "  [ %s ", expr->ops->name);
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);

How about this?

  @@ -604,6 +605,9 @@ static int nftnl_rule_snprintf_default(char *buf, size_t remain,
          SNPRINTF_BUFFER_SIZE(ret, remain, offset);

          list_for_each_entry(expr, &r->expr_list, head) {
  +               if (expr->ops->byteorder)
  +                       expr->ops->byteorder(&ctx, expr);
  +
                  ret = snprintf(buf + offset, remain, "  [ %s ", expr->ops->name);
                  SNPRINTF_BUFFER_SIZE(ret, remain, offset);

> diff --git a/src/set_elem.c b/src/set_elem.c
> index 12eadce1f8e0c..9b18f4def6c47 100644
> --- a/src/set_elem.c
> +++ b/src/set_elem.c
> @@ -708,7 +708,8 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->key,
> -				      DATA_F_NOPFX, DATA_VALUE);
> +				      DATA_F_NOPFX, DATA_VALUE,
> +				      NFTNL_BYTEORDER_UNKNOWN);
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	if (e->flags & (1 << NFTNL_SET_ELEM_KEY_END)) {
> @@ -716,7 +717,8 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  		ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->key_end,
> -					      DATA_F_NOPFX, DATA_VALUE);
> +					      DATA_F_NOPFX, DATA_VALUE,
> +					      NFTNL_BYTEORDER_UNKNOWN);
>  		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>  	}
>
> @@ -727,7 +729,8 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
>  		dregtype = DATA_VERDICT;
>
>  	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->data,
> -				      DATA_F_NOPFX, dregtype);
> +				      DATA_F_NOPFX, dregtype,
> +				      NFTNL_BYTEORDER_UNKNOWN);
>  	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
>
>  	ret = snprintf(buf + offset, remain, "%u [end]", e->set_elem_flags);
> --
> 2.33.0
>
>

--wN1gbHCuKdplHgra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmG2LYYACgkQKYasCr3x
BA07dBAAulZxREIhuQNS4RptCKIrmByMcHNnhkWbsfrFmyQOqmW8Fc803aVphe0E
GKWiSVkEVtxa9LMF1cDycmT5T33ik5sf3H7PBncmM6UUTPgc3XwuBbraQ0WaGZtb
RfYEx+U0mk3oluPMuLd4fWaw0P3MSGFD57U30hoVsXl2sPkFIAkvaT3eytP5AhOB
qMk017hsPnUWrUCJsroH1XQvhNMbIs7PWLQpOdv2Tk6UY5vRHidBeZ4Nid2pW4Xj
fygwqXWLO2RVkq1bJDnu9LHwdwDFv9WqS+xVYDPHuIQAt/s83tl3xcq9K80NWJ1u
a48d4bfSRlkMlM6J7Zxq1UhYTKQMc6kHP3VJEWe5mMCzUGRgp5ggTaPMjM99JvK/
TK8U4DWm9tpPLCQrTCbgo9XdXF44L8QA1ne81VQJ/Zeio+v7Z1SKUrkZY1RZTsS6
fYIie90wascxW33pp8QjgH/NmpKwWbGXgXgQAepQvd++XmjnsCIyUMQ9C8D+135+
KRScbJTrvCNf2Tlf5Nmv8odaLPtWpX3h0wpsDtP1aAxCpUxb841DsiqPYq70L5E3
s6kK9FJyaoO2fHr1CndNeF6pfgP0za9lSL1lxIq3oaWF0LTqz0TeOa1IyYZ0raBi
hZU9JX6hQA99M9Fr9Sd4Mt4BpeoZRmdGog03N/Pvk0fxTggJMN0=
=PzhF
-----END PGP SIGNATURE-----

--wN1gbHCuKdplHgra--
