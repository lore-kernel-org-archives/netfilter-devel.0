From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/3] src: add xt compat support
Date: Wed, 25 Mar 2015 20:44:41 +0100
Message-ID: <20150325194441.GA26737@salvia>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
 <20150325191602.13491.63370.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51406 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbbCYTku (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 15:40:50 -0400
Content-Disposition: inline
In-Reply-To: <20150325191602.13491.63370.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 25, 2015 at 08:16:02PM +0100, Arturo Borrero Gonzalez wrote:
> diff --git a/include/xt.h b/include/xt.h
> new file mode 100644
> index 0000000..414f3d1
> --- /dev/null
> +++ b/include/xt.h
> @@ -0,0 +1,100 @@
> +#ifndef _NFT_XT_H_
> +#define _NFT_XT_H_
> +
> +#include <arpa/inet.h>
> +#include <netinet/in.h>
> +#include <limits.h>
> +#include <net/if.h>
> +#include <net/ethernet.h>
> +
> +struct netlink_linearize_ctx;
> +struct netlink_parse_ctx;
> +struct nft_rule_expr;
> +struct rule_pp_ctx;
> +struct rule;
> +
> +#ifdef HAVE_LIBXTABLES
> +
> +#include <linux/netfilter_ipv4/ip_tables.h>
> +#include <linux/netfilter_ipv6/ip6_tables.h>
> +#include <linux/netfilter_arp/arp_tables.h>
> +
> +/* Fake ebt_entry */
> +struct ebt_entry {

I think you can avoid this if you:

#include <linux/netfilter_bridge/ebtables.h>

[...]
> +#else /* HAVE_LIBXTABLES */
> +union nft_entry {
> +	uint32_t	*nothing;
> +};

I'd suggest:

        #define nft_entry void

> +static inline void stmt_xt_postprocess(struct rule_pp_ctx rctx,
                                                             ^^^^

I think this needs to be *rctx.

Please, retest without libxtables support.

> +				       struct stmt *stmt, struct rule *rule) {}
> +
> +#endif /* HAVE_LIBXTABLES */
> +
> +#endif /* _NFT_XT_H_ */
> +xt_opts			:	/* empty */	{ $$ = NULL; }
> +			|	XTOPTS		{ $$ = $1; }
> +			;
> +
> +xt_name			:	STRING		{ $$ = $1; }
> +			|	STATE		{ $$ = xstrdup("state"); }
> +			|	COMMENT		{ $$ = xstrdup("comment"); }
> +			|	AH		{ $$ = xstrdup("ah"); }
> +			|	ESP		{ $$ = xstrdup("esp"); }
> +			|	TCP		{ $$ = xstrdup("tcp"); }
> +			|	UDP		{ $$ = xstrdup("udp"); }
> +			|	UDPLITE		{ $$ = xstrdup("udplite"); }
> +			|	SCTP		{ $$ = xstrdup("sctp"); }
> +			|	ICMP		{ $$ = xstrdup("icmp"); }
> +			|	IP		{ $$ = xstrdup("ip"); }
> +			|	VLAN		{ $$ = xstrdup("vlan"); }
> +			|	LOG		{ $$ = xstrdup("log"); }
> +			|	_802_3		{ $$ = xstrdup("802_3"); }

This _802_3 should not be clashing with anything else, the problem is
somewhere else.

> +			|	MARK		{ $$ = xstrdup("mark"); }
> +			;
> +
>  nf_nat_flags		:	nf_nat_flag
>  			|	nf_nat_flags	COMMA	nf_nat_flag
>  			{
> diff --git a/src/rule.c b/src/rule.c
> index 7114380..c7c5e20 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -820,6 +820,7 @@ static void table_cleanup(struct table *table)
>  	}
>  }
>  
> +#include <xt.h>
>  static int do_list_table(struct netlink_ctx *ctx, struct cmd *cmd,
>  			 struct table *table)
>  {
> diff --git a/src/scanner.l b/src/scanner.l
> index 73c4f8b..33f0699 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -113,6 +113,7 @@ hexstring	0[xX]{hexdigit}+
>  range		({decstring}?:{decstring}?)
>  letter		[a-zA-Z]
>  string		({letter})({letter}|{digit}|[/\-_\.])*
> +xtopts		\[({letter}|{digit}|[!/\-_\.\"\:\, ])*\]
>  quotedstring	\"[^"]*\"
>  comment		#.*$
>  slash		\/
> @@ -449,6 +450,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "proto-dst"		{ return PROTO_DST; }
>  "label"			{ return LABEL; }
>  
> +"xt"			{ return XT; }
> +"match"			{ return MATCH; }
> +"target"		{ return TARGET; }
> +"watcher"		{ return WATCHER; }
> +"802_3"			{ return _802_3; }
> +
>  "xml"			{ return XML; }
>  "json"			{ return JSON; }
>  
> @@ -488,6 +495,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  				return STRING;
>  			}
>  
> +{xtopts}		{
> +				yylval->string = xstrdup(yytext);
> +				return XTOPTS;
> +			}
> +
>  \\{newline}		{
>  				reset_pos(yyget_extra(yyscanner), yylloc);
>  			}
> diff --git a/src/statement.c b/src/statement.c
> index d72c6e9..5092ea8 100644
> --- a/src/statement.c
> +++ b/src/statement.c
> @@ -23,6 +23,7 @@
>  #include <statement.h>
>  #include <utils.h>
>  #include <list.h>
> +#include <xt.h>
>  
>  #include <netinet/in.h>
>  #include <linux/netfilter/nf_nat.h>
> @@ -377,3 +378,44 @@ struct stmt *redir_stmt_alloc(const struct location *loc)
>  {
>  	return stmt_alloc(loc, &redir_stmt_ops);
>  }
> +
> +static const char *xt_type_name[NFT_XT_MAX] = {
> +	[NFT_XT_MATCH]	= "match",
> +	[NFT_XT_TARGET]	= "target",
> +	[NFT_XT_WATCHER]= "watcher",
> +};
> +
> +static const char *xt_stmt_to_type(enum nft_xt_type type)
> +{
> +	if (type > NFT_XT_MAX)
> +		return "unknown";
> +
> +	return xt_type_name[type];
> +}
> +
> +static void xt_stmt_print(const struct stmt *stmt)
> +{
> +	printf("xt %s %s ", xt_stmt_to_type(stmt->xt.type),
> +			    xt_stmt_name(stmt));
> +	xt_stmt_save(stmt);
> +}
> +
> +static void xt_stmt_destroy(struct stmt *stmt)
> +{
> +	xfree(stmt->xt.name);
> +	xfree(stmt->xt.opts);
> +
> +	xt_stmt_destroy_internals(stmt);
> +}
> +
> +static const struct stmt_ops xt_stmt_ops = {
> +	.type		= STMT_XT,
> +	.name		= "xt",
> +	.print		= xt_stmt_print,
> +	.destroy	= xt_stmt_destroy,
> +};
> +
> +struct stmt *xt_stmt_alloc(const struct location *loc)
> +{
> +	return stmt_alloc(loc, &xt_stmt_ops);
> +}
> diff --git a/src/xt.c b/src/xt.c
> new file mode 100644
> index 0000000..dcb461b
> --- /dev/null
> +++ b/src/xt.c
> @@ -0,0 +1,701 @@
> +/*
> + * Copyright (c) 2013-2015 Pablo Neira Ayuso <pablo@netfilter.org>
> + *
> + * This program is free software; you can redistribute it and/or modifyi
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <stdlib.h>
> +#include <time.h>
> +#include <string.h>
> +#include <xtables.h>
> +#include <utils.h>
> +#include <getopt.h>
> +#include <ctype.h>	/* for isspace */
> +#include <statement.h>
> +#include <rule.h>
> +#include <netlink.h>
> +#include <xt.h>
> +
> +#include <libmnl/libmnl.h>
> +#include <linux/netfilter/nfnetlink.h>
> +#include <linux/netfilter/nf_tables_compat.h>
> +#include <linux/netfilter_ipv4/ip_tables.h>
> +
> +#include <libnftnl/rule.h>
> +#include <libnftnl/expr.h>
> +
> +void xt_stmt_destroy_internals(const struct stmt *stmt)

xt_stmt_release ?

> +{
> +	switch (stmt->xt.type) {
> +	case NFT_XT_MATCH:
> +		if (!stmt->xt.match)
> +			break;
> +		if (stmt->xt.match->m)
> +			xfree(stmt->xt.match->m);
> +		/* this has been cloned */

I think you can remove this comment.

> +		xfree(stmt->xt.match);
> +		break;
> +	case NFT_XT_WATCHER:
> +	case NFT_XT_TARGET:
> +		if (!stmt->xt.target)
> +			break;
> +		if (stmt->xt.target->t)
> +			xfree(stmt->xt.target->t);
> +		/* this has been cloned */

Same here.

> +		xfree(stmt->xt.target);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +const char *xt_stmt_name(const struct stmt *stmt)
> +{
> +	switch (stmt->xt.type) {
> +	case NFT_XT_MATCH:
> +		if (stmt->xt.match == NULL)
> +			break;
> +		if (stmt->xt.match->alias)
> +			return stmt->xt.match->alias(stmt->xt.match->m);
> +		break;
> +	case NFT_XT_TARGET:
> +	case NFT_XT_WATCHER:
> +		if (stmt->xt.target == NULL)
> +			break;
> +		if (stmt->xt.target->alias)
> +			return stmt->xt.target->alias(stmt->xt.target->t);
> +		break;
> +	default:
> +		return "unknown";
> +	}
> +
> +	return stmt->xt.name;
> +}
> +
> +void xt_stmt_save(const struct stmt *stmt)
> +{
> +#ifdef DEBUG
> +	switch (stmt->xt.type) {
> +	case NFT_XT_MATCH:
> +		if (stmt->xt.match)
> +			break;
> +		if (stmt->xt.opts)
> +			fprintf(stdout, "%s", stmt->xt.opts);
> +		return;
> +	case NFT_XT_WATCHER:
> +	case NFT_XT_TARGET:
> +		if (stmt->xt.target)
> +			break;
> +		if (stmt->xt.opts)
> +			fprintf(stdout, "%s", stmt->xt.opts);
> +		return;
> +	default:
> +		break;
> +	}
> +#endif /* DEBUG */

I think you can merge this.

> +
> +	printf("[");
> +
> +	switch (stmt->xt.type) {
> +	case NFT_XT_MATCH:

I think the DEBUG case needs this:

                if (stmt->xt.match == NULL && stmt->xt.opts)
                        fprintf(stdout, "%s", stmt->xt.opts);

> +		if (stmt->xt.match->save) {
> +			stmt->xt.match->save(&stmt->xt.entry,
> +					     stmt->xt.match->m);
> +		} else if (stmt->xt.match->print) {
> +			stmt->xt.match->print(&stmt->xt.entry,
> +					      stmt->xt.match->m, 0);
> +		}
> +		break;
> +	case NFT_XT_WATCHER:
> +	case NFT_XT_TARGET:
> +		if (stmt->xt.target->save)
> +			stmt->xt.target->save(NULL, stmt->xt.target->t);
> +		else if (stmt->xt.target->print)
> +			stmt->xt.target->print(NULL, stmt->xt.target->t, 0);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	printf(" ]");
> +}
> +
> +static void *xt_entry_x_alloc(struct xt_stmt *xt)

xt_entry_data_alloc() ?

> +{
> +
> +	uint32_t size = 0;
> +
> +	switch (xt->type) {
> +	case NFT_XT_MATCH:
> +		size = XT_ALIGN(sizeof(struct xt_entry_match)) +
> +		       xt->match->size;
> +		break;
> +	case NFT_XT_WATCHER:
> +	case NFT_XT_TARGET:
> +		size = XT_ALIGN(sizeof(struct xt_entry_target)) +
> +		       xt->target->size;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return xzalloc(size);
> +}
> +
> +static void nft_entry_setup(struct xt_stmt *xt, uint32_t af)
> +{
> +	switch (af) {
> +	case NFPROTO_IPV4:
> +		xt->entry.e4.ip.proto = xt->proto;
> +		break;
> +	case NFPROTO_IPV6:
> +		xt->entry.e6.ipv6.proto = xt->proto;
> +		break;
> +	case NFPROTO_BRIDGE:
> +		xt->entry.ebt.ethproto = xt->proto;
> +		break;
> +	case NFPROTO_ARP:
> +		/* XXX hardcoded, these are the only values accepted by arpt */
> +		xt->entry.arp.arp.arhln_mask = 0xff;
> +		xt->entry.arp.arp.arhln = 6;

If this is good for all extensions, then you can probably remove the
comment.

> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static uint32_t xt_proto(const struct proto_ctx *pctx)
> +{
> +	const struct proto_desc *desc = NULL;
> +
> +	if (pctx->family == NFPROTO_BRIDGE) {
> +		desc = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
> +		if (desc == NULL)
> +			goto noproto;
> +		if (strcmp(desc->name, "ip") == 0)
> +			return __constant_htons(ETH_P_IP);
> +		if (strcmp(desc->name, "ip6") == 0)
> +			return __constant_htons(ETH_P_IPV6);
> +		goto noproto;

                return 0; instead ?

> +	}
> +
> +	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
> +	if (desc == NULL)
> +		goto noproto;
> +	if (strcmp(desc->name, "tcp") == 0)
> +		return IPPROTO_TCP;
> +	else if (strcmp(desc->name, "udp") == 0)
> +		return IPPROTO_UDP;
> +	else if (strcmp(desc->name, "udplite") == 0)
> +		return IPPROTO_UDPLITE;
> +	else if (strcmp(desc->name, "sctp") == 0)
> +		return IPPROTO_SCTP;
> +	else if (strcmp(desc->name, "dccp") == 0)
> +		return IPPROTO_DCCP;
> +	else if (strcmp(desc->name, "esp") == 0)
> +		return IPPROTO_ESP;
> +	else
> +		BUG("xt with unknown protocol\n");
> +
> +noproto:
> +	return 0;
> +}
> +
> +static struct xtables_target *clone_target(struct xtables_target *t)

xt_target_clone() ?

> +{
> +	struct xtables_target *clone;
> +
> +	clone = xzalloc(sizeof(struct xtables_target));
> +	memcpy(clone, t, sizeof(struct xtables_target));
> +	return clone;
> +}
> +
> +static struct xtables_match *clone_match(struct xtables_match *m)

xt_match_clone() ?

> +{
> +	struct xtables_match *clone;
> +
> +	clone = xzalloc(sizeof(struct xtables_match));
> +	memcpy(clone, m, sizeof(struct xtables_match));
> +	return clone;
> +}
> +
> +/*
> + * Evaluation
> + */
> +
> +static struct option original_opts[] = {
> +	{ NULL },
> +};
> +
> +static int xt_target_to_binary(struct xt_stmt *xt, int argc, char *argv[],
> +			       uint32_t af)
> +{
> +	struct option *opt;
> +	unsigned int offset;
> +	int c;
> +
> +	xt->target->t = xt_entry_x_alloc(xt);
> +	nft_entry_setup(xt, af);
> +
> +	if (xt->target->x6_options != NULL)
> +		opt = xtables_options_xfrm(original_opts, NULL,
> +					   xt->target->x6_options,
> +					   &offset);
> +	else
> +		opt = xtables_merge_options(original_opts, NULL,
> +					    xt->target->extra_opts,
> +					    &offset);
> +
> +	if (xt->target->init != NULL)
> +		xt->target->init(xt->target->t);
> +
> +	/* Reset internal state of getopt_long. */
> +	optind = 0;
> +	/* Suppress error messages. */
> +	opterr = 0;
> +
> +	while ((c = getopt_long(argc, argv, "-:", opt, NULL)) != -1) {
> +
> +		c -= offset;
> +		xtables_option_tpcall(xt->target->option_offset + c,
> +				      argv, 0, xt->target, &xt->entry);
> +	}
> +
> +	/* Reset parsing flags */
> +	xt->target->tflags = 0;
> +	xfree(opt);
> +
> +	return 0;
> +}
> +
> +static int xt_match_to_binary(struct xt_stmt *xt, int argc, char *argv[],
> +			      uint32_t af)
> +{
> +	struct option *opt;
> +	unsigned int offset;
> +	bool invert = false;
> +	int c;
> +
> +	xt->match->m = xt_entry_x_alloc(xt);
> +	nft_entry_setup(xt, af);
> +
> +	if (xt->match->x6_options != NULL)
> +		opt = xtables_options_xfrm(original_opts, NULL,
> +					   xt->match->x6_options,
> +					   &offset);
> +	else
> +		opt = xtables_merge_options(original_opts, NULL,
> +					    xt->match->extra_opts,
> +					    &offset);
> +
> +	if (xt->match->init != NULL)
> +		xt->match->init(xt->match->m);
> +
> +	/* Reset internal state of getopt_long. */
> +	optind = 0;
> +	/* Suppress error messages. */
> +	opterr = 0;
> +
> +	while ((c = getopt_long(argc, argv, "-:", opt, NULL)) != -1) {
> +		switch (c) {
> +		case 1:
> +			invert = true;
> +			continue;
> +		default:
> +			break;
> +		}
> +
> +		if (optarg != NULL && optarg[0] == '!' && optarg[1] == '\0') {
> +			invert = true;
> +			optarg = argv[optind];
> +		}
> +
> +		c -= offset;
> +		xtables_option_mpcall(xt->match->option_offset + c,
> +				      argv, invert, xt->match,
> +				      &xt->entry);
> +		if (invert)
> +			invert = false;
> +	}
> +
> +	/* Reset parsing flags */
> +	xt->match->mflags = 0;
> +	xfree(opt);
> +
> +	return 0;
> +}
> +
> +/* An xt extension doesn't have more than arguments. */
> +#define MAX_ARG			64
> +
> +static int string_to_argv(const char *str, char *argv[], uint32_t argc_max)
> +{
> +	uint32_t i, k = 1, len = 0;
> +	bool atquote = false, dupquote = false;
> +
> +	if (str == NULL)
> +		return 0;
> +
> +	/* skip first/last char, are '[' and ']' */
> +	for (i = 1; i < strlen(str)-1; i++) {

                        strlen(str) - 1

> +		if (k == argc_max)
> +			goto err;
> +
> +		if (isspace(str[i]) && !atquote) {
> +			if (len <= 0)
> +				continue;
> +
> +			if (dupquote) {
> +				argv[k] = strndup(&str[i - len + 1], len - 2);
> +				dupquote = false;
> +			} else {
> +				argv[k] = strndup(&str[i - len], len);
> +			}
> +
> +			k++;
> +			len = 0;
> +		} else {
> +			len++;
> +		}
> +
> +		if (str[i] == '"') {
> +			if (!atquote)
> +				dupquote = true;
> +			atquote = !atquote;
> +		}
> +	}
> +	return k;
> +err:
> +	for (i = 0; i < k; i++)
> +		free(argv[i]);
> +	return -1;
> +}
> +
> +int stmt_evaluate_xt(struct eval_ctx *ctx, struct stmt *stmt)
> +{
> +	char *argv[MAX_ARG] = { "iptables" };
> +	struct xtables_match *mt;
> +	struct xtables_target *tg;
> +	int argc, i, err;
> +
> +	argc = string_to_argv(stmt->xt.opts, argv, MAX_ARG);
> +	if (argc < 0)
> +		return stmt_error(ctx, stmt, "too many xt options");
> +
> +	xtables_set_nfproto(ctx->pctx.family);
> +	stmt->xt.proto = xt_proto(&ctx->pctx);
> +
> +	if (stmt->xt.type == NFT_XT_WATCHER &&
> +	    ctx->pctx.family != NFPROTO_BRIDGE)
> +		return stmt_error(ctx, stmt,
> +				  "watcher only available from bridge family");
> +
> +	switch (stmt->xt.type) {
> +	case NFT_XT_MATCH:
> +		mt = xtables_find_match(stmt->xt.name, XTF_TRY_LOAD, NULL);
> +		if (!mt)
> +			return stmt_error(ctx, stmt, "unknown match %s",
> +					  stmt->xt.name);
> +
> +		stmt->xt.match = clone_match(mt);
> +		err = xt_match_to_binary(&stmt->xt, argc, argv,
> +					 ctx->pctx.family);
> +		break;
> +	case NFT_XT_TARGET:
> +	case NFT_XT_WATCHER:
> +		tg = xtables_find_target(stmt->xt.name, XTF_TRY_LOAD);
> +		if (!tg)
> +			return stmt_error(ctx, stmt, "unknown target %s",
> +					  stmt->xt.name);
> +
> +		stmt->xt.target = clone_target(tg);
> +		err = xt_target_to_binary(&stmt->xt, argc, argv,
> +					 ctx->pctx.family);
> +		break;
> +	default:
> +		BUG("Unknown xt type %d\n", stmt->xt.type);
> +	}
> +
> +	if (stmt->xt.type == NFT_XT_TARGET)
> +		stmt->flags |= STMT_F_TERMINAL;
> +
> +	for (i = 1; i < argc; i++)
> +		xfree(argv[i]);
> +
> +	if (err < 0)
> +		return stmt_error(ctx, stmt, "failed to parse");
> +
> +	return 0;
> +}
> +
> +/*
> + * Delinearization
> + */
> +
> +void netlink_parse_match(struct netlink_parse_ctx *ctx,
> +			 const struct location *loc,
> +			 const struct nft_rule_expr *nle)
> +{
> +	struct stmt *stmt;
> +	const char *name;
> +	struct xtables_match *mt;
> +	const char *mtinfo;
> +	struct xt_entry_match *m;
> +	uint32_t mt_len;
> +
> +	xtables_set_nfproto(ctx->table->handle.family);
> +
> +	name = nft_rule_expr_get_str(nle, NFT_EXPR_MT_NAME);
> +
> +	/* XXXX mem leak. When is this memory freed?
> +	 * - can't call xtables_rule_matches_free()
> +	 * - the same match could be in use by the next rule
> +	 * - use a wrapper struct with a refcount? lot of code overhead
> +	 */

This comment ?

> +	mt = xtables_find_match(name, XTF_TRY_LOAD, NULL);
> +	if (!mt)
> +		BUG("XT match %s not found\n", name);
> +
> +	mtinfo = nft_rule_expr_get(nle, NFT_EXPR_MT_INFO, &mt_len);
> +
> +	m = xzalloc(sizeof(struct xt_entry_match) + mt_len);
> +	memcpy(&m->data, mtinfo, mt_len);
> +
> +	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
> +	m->u.user.revision = nft_rule_expr_get_u32(nle, NFT_EXPR_MT_REV);
> +
> +	stmt = xt_stmt_alloc(loc);
> +	stmt->xt.name = strdup(name);
> +	stmt->xt.type = NFT_XT_MATCH;
> +	stmt->xt.match = clone_match(mt);
> +	stmt->xt.match->m = m;
> +
> +	list_add_tail(&stmt->list, &ctx->rule->stmts);
> +}
> +
> +void netlink_parse_target(struct netlink_parse_ctx *ctx,
> +			  const struct location *loc,
> +			  const struct nft_rule_expr *nle)
> +{
> +	struct stmt *stmt;
> +	const char *name;
> +	struct xtables_target *tg;
> +	const void *tginfo;
> +	struct xt_entry_target *t;
> +	size_t size;
> +	uint32_t tg_len;
> +
> +	xtables_set_nfproto(ctx->table->handle.family);
> +
> +	name = nft_rule_expr_get_str(nle, NFT_EXPR_TG_NAME);
> +	tg = xtables_find_target(name, XTF_TRY_LOAD);
> +	if (!tg)
> +		BUG("XT target %s not found\n", name);
> +
> +	tginfo = nft_rule_expr_get(nle, NFT_EXPR_TG_INFO, &tg_len);
> +
> +	size = XT_ALIGN(sizeof(struct xt_entry_target)) + tg_len;
> +	t = xzalloc(size);
> +	memcpy(&t->data, tginfo, tg_len);
> +	t->u.target_size = size;
> +	t->u.user.revision = nft_rule_expr_get_u32(nle, NFT_EXPR_TG_REV);
> +	strcpy(t->u.user.name, tg->name);
> +
> +	stmt = xt_stmt_alloc(loc);
> +	stmt->xt.name = strdup(name);
> +	stmt->xt.type = NFT_XT_TARGET;
> +	stmt->xt.target = clone_target(tg);
> +	stmt->xt.target->t = t;
> +
> +	list_add_tail(&stmt->list, &ctx->rule->stmts);
> +}
> +
> +static bool is_watcher(uint32_t family, struct stmt *stmt)
> +{
> +	if (family != NFPROTO_BRIDGE)
> +		return false;
> +
> +	if (stmt->xt.type != NFT_XT_TARGET)
> +		return false;
> +
> +	/* this has to be hardcoded :-( */
> +	if (strcmp(stmt->xt.name, "log") == 0)
> +		return true;
> +	if (strcmp(stmt->xt.name, "nflog") == 0)
> +		return true;
> +	if (strcmp(stmt->xt.name, "uflog") == 0)

ulog ?

> +		return true;
> +
> +	return false;
> +}
