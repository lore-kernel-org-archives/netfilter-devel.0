Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68226C31E57
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 10:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2898820833
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 10:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="IvafX+3D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfFQKl0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 06:41:26 -0400
Received: from mx1.riseup.net ([198.252.153.129]:43012 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFQKl0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 06:41:26 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 8C6421A26DC;
        Mon, 17 Jun 2019 03:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1560768085; bh=qh9GiTY87yvZ35QBtop5bH3enlTKjCBGYIo2zp9qtV0=;
        h=Subject:To:References:From:Cc:Date:In-Reply-To:From;
        b=IvafX+3Dl0w4zDv0o/6L4op9QATD33gGsokpzQ1fMHW4G4QJngH3dYEdWOGlsk+n3
         O6zfXQ4e6RYEgR5FFxKlwtY9OmLqrQGfez0HqJMnfI+9gcbwkmsPscbYCck5ymeg9+
         mRk+ZHY+r85R6nN8av3x8lHNDojwkOj6wVv8ETL8=
X-Riseup-User-ID: 0F5CBE9B4722772FED7D30F7BE1249A6E9CE3489CF876260B4BDA7F6F27BB76F
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 34D81223EEB;
        Mon, 17 Jun 2019 03:41:23 -0700 (PDT)
Subject: Re: [PATCH nft WIP] src: introduce SYNPROXY matching
To:     netfilter-devel@vger.kernel.org
References: <20190617103234.1357-1-ffmancera@riseup.net>
 <20190617103234.1357-3-ffmancera@riseup.net>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Message-ID: <c2508385-05d7-006e-669a-29745636d4fd@riseup.net>
Date:   Mon, 17 Jun 2019 12:41:36 +0200
MIME-Version: 1.0
In-Reply-To: <20190617103234.1357-3-ffmancera@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I have been working on the synproxy expression. In my opinion, there is
no way to use sets or maps with synproxy so I think it should be a
statement.

This patch is almost finished, but I have been dealing with the
following error.

# nft add table ip foo
# nft add chain ip foo bar
# nft add rule ip foo bar synproxy mss 1460 wscale 7

> Error: Could not process rule: Numerical result out of range
> add rule ip foo bar synproxy mss 10 wscale 2
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I have tried to debug it using libnftables directly. And I still getting
the same error. The problem should be in the libnftnl or nf-next patch.
I am probably missing something. Any suggestion? Thanks :-)

On 6/17/19 12:32 PM, Fernando Fernandez Mancera wrote:
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  include/linux/netfilter/nf_SYNPROXY.h | 23 ++++++++++++
>  include/linux/netfilter/nf_tables.h   | 16 +++++++++
>  include/statement.h                   | 11 ++++++
>  src/evaluate.c                        | 16 +++++++++
>  src/netlink_delinearize.c             | 17 +++++++++
>  src/netlink_linearize.c               | 17 +++++++++
>  src/parser_bison.y                    | 48 +++++++++++++++++++++++++
>  src/scanner.l                         |  6 ++++
>  src/statement.c                       | 50 +++++++++++++++++++++++++++
>  9 files changed, 204 insertions(+)
>  create mode 100644 include/linux/netfilter/nf_SYNPROXY.h
> 
> diff --git a/include/linux/netfilter/nf_SYNPROXY.h b/include/linux/netfilter/nf_SYNPROXY.h
> new file mode 100644
> index 0000000..0e7c391
> --- /dev/null
> +++ b/include/linux/netfilter/nf_SYNPROXY.h
> @@ -0,0 +1,23 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _NF_SYNPROXY_H
> +#define _NF_SYNPROXY_H
> +
> +#include <linux/types.h>
> +
> +#define NF_SYNPROXY_OPT_MSS		0x01
> +#define NF_SYNPROXY_OPT_WSCALE		0x02
> +#define NF_SYNPROXY_OPT_SACK_PERM	0x04
> +#define NF_SYNPROXY_OPT_TIMESTAMP	0x08
> +#define NF_SYNPROXY_OPT_ECN		0x10
> +#define NF_SYNPROXY_FLAGMASK		(NF_SYNPROXY_OPT_MSS | \
> +					 NF_SYNPROXY_OPT_WSCALE | \
> +					 NF_SYNPROXY_OPT_SACK_PERM | \
> +					 NF_SYNPROXY_OPT_TIMESTAMP)
> +
> +struct nf_synproxy_info {
> +	__u8	options;
> +	__u8	wscale;
> +	__u16	mss;
> +};
> +
> +#endif /* _NF_SYNPROXY_H */
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 7bdb234..d9ccf3f 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -1529,6 +1529,22 @@ enum nft_osf_attributes {
>  };
>  #define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
>  
> +/**
> + * enum nft_synproxy_attributes - nftables synproxy expression
> + * netlink attributes
> + *
> + * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
> + * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
> + * @NFTA_SYNPROXY_FLAGS: flags (NLA_U32)
> + */
> +enum nft_synproxy_attributes {
> +	NFTA_SYNPROXY_MSS,
> +	NFTA_SYNPROXY_WSCALE,
> +	NFTA_SYNPROXY_FLAGS,
> +	__NFTA_SYNPROXY_MAX,
> +};
> +#define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
> +
>  /**
>   * enum nft_device_attributes - nf_tables device netlink attributes
>   *
> diff --git a/include/statement.h b/include/statement.h
> index 91d6e0e..f789ced 100644
> --- a/include/statement.h
> +++ b/include/statement.h
> @@ -203,6 +203,14 @@ struct map_stmt {
>  
>  extern struct stmt *map_stmt_alloc(const struct location *loc);
>  
> +struct synproxy_stmt {
> +	uint16_t	mss;
> +	uint8_t		wscale;
> +	uint32_t	flags;
> +};
> +
> +extern struct stmt *synproxy_stmt_alloc(const struct location *loc);
> +
>  struct meter_stmt {
>  	struct expr		*set;
>  	struct expr		*key;
> @@ -270,6 +278,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
>   * @STMT_FLOW_OFFLOAD:	flow offload statement
>   * @STMT_CONNLIMIT:	connection limit statement
>   * @STMT_MAP:		map statement
> + * @STMT_SYNPROXY:	synproxy statement
>   */
>  enum stmt_types {
>  	STMT_INVALID,
> @@ -297,6 +306,7 @@ enum stmt_types {
>  	STMT_FLOW_OFFLOAD,
>  	STMT_CONNLIMIT,
>  	STMT_MAP,
> +	STMT_SYNPROXY,
>  };
>  
>  /**
> @@ -361,6 +371,7 @@ struct stmt {
>  		struct objref_stmt	objref;
>  		struct flow_stmt	flow;
>  		struct map_stmt		map;
> +		struct synproxy_stmt	synproxy;
>  	};
>  };
>  
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 39101b4..04692b8 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -17,6 +17,7 @@
>  #include <linux/netfilter.h>
>  #include <linux/netfilter_arp.h>
>  #include <linux/netfilter/nf_tables.h>
> +#include <linux/netfilter/nf_SYNPROXY.h>
>  #include <linux/netfilter_ipv4.h>
>  #include <netinet/ip_icmp.h>
>  #include <netinet/icmp6.h>
> @@ -2704,6 +2705,19 @@ static int stmt_evaluate_tproxy(struct eval_ctx *ctx, struct stmt *stmt)
>  	return 0;
>  }
>  
> +static int stmt_evaluate_synproxy(struct eval_ctx *ctx, struct stmt *stmt)
> +{
> +	printf("Values of the synproxy expr: %u %u\n", stmt->synproxy.mss, stmt->synproxy.wscale);
> +	if (stmt->synproxy.flags != 0 &&
> +	    !(stmt->synproxy.flags & (NF_SYNPROXY_OPT_MSS |
> +				      NF_SYNPROXY_OPT_WSCALE |
> +				      NF_SYNPROXY_OPT_TIMESTAMP |
> +				      NF_SYNPROXY_OPT_SACK_PERM)))
> +		return stmt_error(ctx, stmt, "This flags are not supported for SYNPROXY");
> +
> +	return 0;
> +}
> +
>  static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
>  {
>  	int err;
> @@ -3048,6 +3062,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
>  		return stmt_evaluate_objref(ctx, stmt);
>  	case STMT_MAP:
>  		return stmt_evaluate_map(ctx, stmt);
> +	case STMT_SYNPROXY:
> +		return stmt_evaluate_synproxy(ctx, stmt);
>  	default:
>  		BUG("unknown statement type %s\n", stmt->ops->name);
>  	}
> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> index 0270e1f..2785325 100644
> --- a/src/netlink_delinearize.c
> +++ b/src/netlink_delinearize.c
> @@ -1010,6 +1010,22 @@ out_err:
>  	xfree(stmt);
>  }
>  
> +static void netlink_parse_synproxy(struct netlink_parse_ctx *ctx,
> +				   const struct location *loc,
> +				   const struct nftnl_expr *nle)
> +{
> +	struct stmt *stmt;
> +
> +	stmt = synproxy_stmt_alloc(loc);
> +	stmt->synproxy.mss = nftnl_expr_get_u16(nle, NFTNL_EXPR_SYNPROXY_MSS);
> +	stmt->synproxy.wscale = nftnl_expr_get_u8(nle,
> +						  NFTNL_EXPR_SYNPROXY_WSCALE);
> +	stmt->synproxy.flags = nftnl_expr_get_u32(nle,
> +						  NFTNL_EXPR_SYNPROXY_FLAGS);
> +
> +	ctx->stmt = stmt;
> +}
> +
>  static void netlink_parse_tproxy(struct netlink_parse_ctx *ctx,
>  			      const struct location *loc,
>  			      const struct nftnl_expr *nle)
> @@ -1476,6 +1492,7 @@ static const struct {
>  	{ .name = "tcpopt",	.parse = netlink_parse_exthdr },
>  	{ .name = "flow_offload", .parse = netlink_parse_flow_offload },
>  	{ .name = "xfrm",	.parse = netlink_parse_xfrm },
> +	{ .name = "synproxy",	.parse = netlink_parse_synproxy },
>  };
>  
>  static int netlink_parse_expr(const struct nftnl_expr *nle,
> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> index 2c6aa64..498326d 100644
> --- a/src/netlink_linearize.c
> +++ b/src/netlink_linearize.c
> @@ -1141,6 +1141,21 @@ static void netlink_gen_tproxy_stmt(struct netlink_linearize_ctx *ctx,
>  	nftnl_rule_add_expr(ctx->nlr, nle);
>  }
>  
> +static void netlink_gen_synproxy_stmt(struct netlink_linearize_ctx *ctx,
> +				      const struct stmt *stmt)
> +{
> +	struct nftnl_expr *nle;
> +
> +	nle = alloc_nft_expr("synproxy");
> +	nftnl_expr_set_u16(nle, NFTNL_EXPR_SYNPROXY_MSS, stmt->synproxy.mss);
> +	nftnl_expr_set_u8(nle, NFTNL_EXPR_SYNPROXY_WSCALE,
> +			  stmt->synproxy.wscale);
> +	nftnl_expr_set_u32(nle, NFTNL_EXPR_SYNPROXY_FLAGS,
> +			   stmt->synproxy.flags);
> +
> +	nftnl_rule_add_expr(ctx->nlr, nle);
> +}
> +
>  static void netlink_gen_dup_stmt(struct netlink_linearize_ctx *ctx,
>  				 const struct stmt *stmt)
>  {
> @@ -1382,6 +1397,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
>  		return netlink_gen_nat_stmt(ctx, stmt);
>  	case STMT_TPROXY:
>  		return netlink_gen_tproxy_stmt(ctx, stmt);
> +	case STMT_SYNPROXY:
> +		return netlink_gen_synproxy_stmt(ctx, stmt);
>  	case STMT_DUP:
>  		return netlink_gen_dup_stmt(ctx, stmt);
>  	case STMT_QUEUE:
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 97a48f3..61e0888 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -23,6 +23,7 @@
>  #include <linux/netfilter/nf_nat.h>
>  #include <linux/netfilter/nf_log.h>
>  #include <linux/netfilter/nfnetlink_osf.h>
> +#include <linux/netfilter/nf_SYNPROXY.h>
>  #include <linux/xfrm.h>
>  #include <netinet/ip_icmp.h>
>  #include <netinet/icmp6.h>
> @@ -200,6 +201,12 @@ int nft_lex(void *, void *, void *);
>  
>  %token OSF			"osf"
>  
> +%token SYNPROXY			"synproxy"
> +%token MSS			"mss"
> +%token WSCALE			"wscale"
> +%token TIMESTAMP		"timestamp"
> +%token SACKPERM			"sack-perm"
> +
>  %token HOOK			"hook"
>  %token DEVICE			"device"
>  %token DEVICES			"devices"
> @@ -601,6 +608,9 @@ int nft_lex(void *, void *, void *);
>  %type <val>			nf_nat_flags nf_nat_flag offset_opt
>  %type <stmt>			tproxy_stmt
>  %destructor { stmt_free($$); }	tproxy_stmt
> +%type <stmt>			synproxy_stmt synproxy_stmt_alloc
> +%destructor { stmt_free($$); }	synproxy_stmt synproxy_stmt_alloc
> +
>  
>  %type <stmt>			queue_stmt queue_stmt_alloc
>  %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
> @@ -2245,6 +2255,7 @@ stmt			:	verdict_stmt
>  			|	fwd_stmt
>  			|	set_stmt
>  			|	map_stmt
> +			|	synproxy_stmt
>  			;
>  
>  verdict_stmt		:	verdict_expr
> @@ -2675,6 +2686,43 @@ tproxy_stmt		:	TPROXY TO stmt_expr
>  			}
>  			;
>  
> +synproxy_stmt		:	synproxy_stmt_alloc
> +			|	synproxy_stmt_alloc	synproxy_args
> +			;
> +
> +synproxy_stmt_alloc	:	SYNPROXY
> +			{
> +				$$ = synproxy_stmt_alloc(&@$);
> +			}
> +			;
> +
> +synproxy_args		:	synproxy_arg
> +			{
> +				$<stmt>$	= $<stmt>0;
> +			}
> +			|	synproxy_args	synproxy_arg
> +			;
> +
> +synproxy_arg		:	MSS	NUM
> +			{
> +				$<stmt>0->synproxy.mss = $2;
> +				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
> +			}
> +			|	WSCALE	NUM
> +			{
> +				$<stmt>0->synproxy.wscale = $2;
> +				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
> +			}
> +			|	TIMESTAMP
> +			{
> +				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_TIMESTAMP;
> +			}
> +			|	SACKPERM
> +			{
> +				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_SACK_PERM;
> +			}
> +			;
> +
>  primary_stmt_expr	:	symbol_expr		{ $$ = $1; }
>  			|	integer_expr		{ $$ = $1; }
>  			|	boolean_expr		{ $$ = $1; }
> diff --git a/src/scanner.l b/src/scanner.l
> index d1f6e87..e990cc6 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -543,6 +543,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  
>  "osf"			{ return OSF; }
>  
> +"synproxy"		{ return SYNPROXY; }
> +"mss"			{ return MSS; }
> +"wscale"		{ return WSCALE; }
> +"timestamp"		{ return TIMESTAMP; }
> +"sack-perm"		{ return SACKPERM; }
> +
>  "notrack"		{ return NOTRACK; }
>  
>  "options"		{ return OPTIONS; }
> diff --git a/src/statement.c b/src/statement.c
> index a9e8b3a..3489e3e 100644
> --- a/src/statement.c
> +++ b/src/statement.c
> @@ -29,6 +29,7 @@
>  #include <netinet/in.h>
>  #include <linux/netfilter/nf_nat.h>
>  #include <linux/netfilter/nf_log.h>
> +#include <linux/netfilter/nf_SYNPROXY.h>
>  
>  struct stmt *stmt_alloc(const struct location *loc,
>  			const struct stmt_ops *ops)
> @@ -877,3 +878,52 @@ struct stmt *xt_stmt_alloc(const struct location *loc)
>  {
>  	return stmt_alloc(loc, &xt_stmt_ops);
>  }
> +
> +static const char *synproxy_sack_to_str(const uint32_t flags)
> +{
> +	if (flags & NF_SYNPROXY_OPT_SACK_PERM)
> +		return " sack-perm";
> +
> +	return "";
> +}
> +
> +static const char *synproxy_timestamp_to_str(const uint32_t flags)
> +{
> +	if (flags & NF_SYNPROXY_OPT_TIMESTAMP)
> +		return " timestamp";
> +
> +	return "";
> +}
> +
> +static void synproxy_stmt_print(const struct stmt *stmt,
> +				struct output_ctx *octx)
> +{
> +	uint32_t flags = stmt->synproxy.flags;
> +	const char *ts_str = synproxy_timestamp_to_str(flags);
> +	const char *sack_str = synproxy_sack_to_str(flags);
> +
> +	if (flags & (NF_SYNPROXY_OPT_MSS | NF_SYNPROXY_OPT_WSCALE))
> +		nft_print(octx, "synproxy mss %u wscale %u%s%s",
> +			  stmt->synproxy.mss, stmt->synproxy.wscale,
> +			  ts_str, sack_str);
> +	else if (flags & NF_SYNPROXY_OPT_MSS)
> +		nft_print(octx, "synproxy mss %u%s%s", stmt->synproxy.mss,
> +			  ts_str, sack_str);
> +	else if (flags & NF_SYNPROXY_OPT_WSCALE)
> +		nft_print(octx, "synproxy wscale %u%s%s", stmt->synproxy.wscale,
> +			  ts_str, sack_str);
> +	else
> +		nft_print(octx, "synproxy%s%s", ts_str, sack_str);
> +
> +}
> +
> +static const struct stmt_ops synproxy_stmt_ops = {
> +	.type		= STMT_SYNPROXY,
> +	.name		= "synproxy",
> +	.print		= synproxy_stmt_print,
> +};
> +
> +struct stmt *synproxy_stmt_alloc(const struct location *loc)
> +{
> +	return stmt_alloc(loc, &synproxy_stmt_ops);
> +}
> 
